import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'scan_event.dart';
import 'scan_state.dart';
import '../../models/food_info.dart';

/// Exemple d'implémentation du ScanBloc avec envoi à l'API
///
/// Cette version montre comment envoyer l'image et les informations
/// de portion au serveur
class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ImagePicker _imagePicker = ImagePicker();

  ScanBloc() : super(ScanInitial()) {
    on<ScanFood>(_onScanFood);
    on<ResetScan>(_onResetScan);
  }

  Future<void> _onScanFood(ScanFood event, Emitter<ScanState> emit) async {
    emit(ScanLoading());

    try {
      // 1. Capture de l'image (caméra ou galerie)
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85, // Compression pour réduire la taille
      );

      if (image == null) {
        // L'utilisateur a annulé la capture
        emit(ScanInitial());
        return;
      }

      // 2. Préparation de la requête multipart
      final uri = Uri.parse('http://monserver.com/scan');
      final request = http.MultipartRequest('POST', uri);

      // 3. Ajout de l'image
      final imageFile = File(image.path);
      final multipartFile = await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        filename: 'food_scan.jpg',
      );
      request.files.add(multipartFile);

      // 4. Ajout des informations de portion
      final portionInfo = event.portionInfo;

      if (portionInfo != null) {
        // Si une taille d'assiette est sélectionnée
        if (portionInfo.plateSize != null) {
          request.fields['portion_type'] = 'plate';
          request.fields['plate_size'] = portionInfo.plateSize!.name;
          request.fields['multiplier'] = portionInfo.multiplier.toString();
        }

        // Si un poids est renseigné
        if (portionInfo.weight != null) {
          request.fields['portion_type'] = 'weight';
          request.fields['weight_grams'] = portionInfo.weight!.toString();
          request.fields['multiplier'] = portionInfo.multiplier.toString();
        }
      } else {
        // Valeur par défaut si pas d'info de portion
        request.fields['multiplier'] = (event.recipientSize ?? 1.0).toString();
      }

      // 5. Envoi de la requête
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // 6. Traitement de la réponse
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final food = FoodInfo.fromJson(data);
        emit(ScanSuccess(food));
      } else if (response.statusCode == 400) {
        // Erreur de validation côté serveur
        final error = jsonDecode(response.body);
        emit(ScanError(error['message'] ?? 'Erreur de validation'));
      } else {
        emit(ScanError('Erreur lors du scan (${response.statusCode})'));
      }
    } on SocketException {
      // Pas de connexion internet
      emit(ScanError('Pas de connexion internet'));
    } on FormatException {
      // Erreur de parsing JSON
      emit(ScanError('Réponse invalide du serveur'));
    } catch (e) {
      // Autres erreurs
      emit(ScanError('Erreur inattendue: ${e.toString()}'));
    }
  }

  void _onResetScan(ResetScan event, Emitter<ScanState> emit) {
    emit(ScanInitial());
  }
}

/* ===================================================================
   EXEMPLE DE RÉPONSE ATTENDUE DU SERVEUR
   ===================================================================

   POST http://monserver.com/scan
   
   Request Body (multipart/form-data):
   {
     "image": <binary file>,
     "portion_type": "plate",  // ou "weight"
     "plate_size": "medium",   // si portion_type = "plate"
     "weight_grams": "250",    // si portion_type = "weight"
     "multiplier": "1.0"
   }

   Response 200 (application/json):
   {
     "name": "Pomme Golden",
     "calories": 95,
     "proteins": 0.5,
     "carbs": 25,
     "fats": 0.3,
     "portion_info": {
       "type": "plate",
       "size": "medium",
       "multiplier": 1.0
     }
   }

   Response 400 (application/json):
   {
     "error": "INVALID_IMAGE",
     "message": "L'image n'a pas pu être analysée"
   }

   Response 500 (application/json):
   {
     "error": "SERVER_ERROR",
     "message": "Erreur interne du serveur"
   }

   ===================================================================
   DÉPENDANCES À AJOUTER DANS pubspec.yaml
   ===================================================================

   dependencies:
     flutter:
       sdk: flutter
     flutter_bloc: ^8.1.3
     http: ^1.1.0
     image_picker: ^1.0.4

   ===================================================================
   PERMISSIONS À CONFIGURER
   ===================================================================

   Android (android/app/src/main/AndroidManifest.xml):
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.INTERNET" />

   iOS (ios/Runner/Info.plist):
   <key>NSCameraUsageDescription</key>
   <string>Nous avons besoin d'accéder à votre caméra pour scanner les aliments</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>Nous avons besoin d'accéder à vos photos</string>

   ===================================================================
*/
