import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'scan_event.dart';
import 'scan_state.dart';
import '../../models/food_info.dart';
import '../../models/portion_size.dart';
import '../../config/api_config.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ImagePicker _imagePicker = ImagePicker();
  List<FoodInfo> _currentList = [];

  ScanBloc() : super(ScanInitial()) {
    on<ScanFood>(_onScanFood);
    on<AddFoodToList>(_onAddFoodToList);
    on<RemoveFoodFromList>(_onRemoveFoodFromList);
    on<ClearFoodList>(_onClearFoodList);
    on<ResetScan>(_onResetScan);
  }

  /// Récupère le token d'authentification
  Future<String?> _getAuthToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('auth_token');
    } catch (e) {
      return null;
    }
  }

  Future<void> _onScanFood(ScanFood event, Emitter<ScanState> emit) async {
    emit(ScanLoading(scannedFoods: _currentList));

    try {
      final portionInfo = event.portionInfo;

      // Vérifier si c'est une saisie manuelle ou un scan photo
      if (portionInfo?.productName != null &&
          portionInfo!.productName!.isNotEmpty) {
        await _scanManualProduct(portionInfo, emit);
      } else {
        await _scanWithImage(portionInfo, emit);
      }
    } on SocketException {
      emit(ScanError('Pas de connexion internet', scannedFoods: _currentList));
    } on FormatException catch (e) {
      emit(ScanError('Réponse invalide du serveur: $e',
          scannedFoods: _currentList));
    } on TimeoutException {
      emit(ScanError('Le serveur ne répond pas', scannedFoods: _currentList));
    } catch (e) {
      emit(ScanError('Erreur inattendue: ${e.toString()}',
          scannedFoods: _currentList));
    }
  }

  Future<void> _scanWithImage(
      PortionInfo? portionInfo, Emitter<ScanState> emit) async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: ApiConfig.imageQuality,
    );

    if (image == null) {
      emit(ScanInitial(scannedFoods: _currentList));
      return;
    }

    // Récupérer le token
    final token = await _getAuthToken();
    if (token == null) {
      emit(ScanError('Vous devez être connecté pour scanner',
          scannedFoods: _currentList));
      return;
    }

    final uri = Uri.parse(ApiConfig.scanUrl);

    final request = http.MultipartRequest('POST', uri);

    // Ajouter le token dans les headers
    request.headers['Cookie'] = 'auth_token=$token';

    // Ajouter l'image
    final imageFile = File(image.path);
    final multipartFile = await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      filename: 'food_scan.jpg',
    );
    request.files.add(multipartFile);

    // Ajouter les informations de portion
    if (portionInfo != null) {
      request.fields.addAll(portionInfo.toFields());
    }

    final streamedResponse = await request.send().timeout(
      Duration(seconds: ApiConfig.requestTimeout),
      onTimeout: () {
        throw TimeoutException('Le serveur ne répond pas');
      },
    );

    final response = await http.Response.fromStream(streamedResponse);

    _handleResponse(response, emit);
  }

  Future<void> _scanManualProduct(
      PortionInfo portionInfo, Emitter<ScanState> emit) async {
    // Récupérer le token
    final token = await _getAuthToken();
    if (token == null) {
      emit(ScanError('Vous devez être connecté pour scanner',
          scannedFoods: _currentList));
      return;
    }

    // Si plusieurs produits, on les traite en batch
    if (portionInfo.productNames != null &&
        portionInfo.productNames!.length > 1) {
      final uri = Uri.parse(ApiConfig.scanManualBatchUrl);

      final response = await http
          .post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'auth_token=$token',
        },
        body: jsonEncode({
          'product_names': portionInfo.productNames,
          ...portionInfo.toJson(),
        }),
      )
          .timeout(
        Duration(seconds: ApiConfig.requestTimeout),
        onTimeout: () {
          throw TimeoutException('Le serveur ne répond pas');
        },
      );

      _handleBatchResponse(response, emit);
    } else {
      final uri = Uri.parse(ApiConfig.scanManualUrl);

      final response = await http
          .post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Cookie': 'auth_token=$token',
        },
        body: jsonEncode({
          'product_name':
              portionInfo.productName ?? portionInfo.productNames?.first,
          ...portionInfo.toJson(),
        }),
      )
          .timeout(
        Duration(seconds: ApiConfig.requestTimeout),
        onTimeout: () {
          throw TimeoutException('Le serveur ne répond pas');
        },
      );

      _handleResponse(response, emit);
    }
  }

  void _handleBatchResponse(http.Response response, Emitter<ScanState> emit) {
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);

        // Réponse avec plusieurs aliments
        if (data is List) {
          for (var foodData in data) {
            final food = FoodInfo.fromJson(foodData);
            _currentList = [..._currentList, food];
          }
          emit(ScanInitial(scannedFoods: _currentList));
        } else {
          final food = FoodInfo.fromJson(data);
          emit(ScanSuccess(food, scannedFoods: _currentList));
        }
      } catch (e) {
        emit(ScanError('Format de réponse invalide',
            scannedFoods: _currentList));
      }
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Erreur de validation';
      emit(ScanError(message, scannedFoods: _currentList));
    } else if (response.statusCode == 401) {
      emit(ScanError('Session expirée. Veuillez vous reconnecter.',
          scannedFoods: _currentList));
    } else if (response.statusCode == 404) {
      emit(ScanError('Aliment non trouvé dans la base de données',
          scannedFoods: _currentList));
    } else if (response.statusCode == 500) {
      emit(ScanError('Erreur interne du serveur', scannedFoods: _currentList));
    } else {
      emit(ScanError('Erreur lors du scan (${response.statusCode})',
          scannedFoods: _currentList));
    }
  }

  void _handleResponse(http.Response response, Emitter<ScanState> emit) {
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        final food = FoodInfo.fromJson(data);
        emit(ScanSuccess(food, scannedFoods: _currentList));
      } catch (e) {
        emit(ScanError('Format de réponse invalide',
            scannedFoods: _currentList));
      }
    } else if (response.statusCode == 400) {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Erreur de validation';
      emit(ScanError(message, scannedFoods: _currentList));
    } else if (response.statusCode == 401) {
      emit(ScanError('Session expirée. Veuillez vous reconnecter.',
          scannedFoods: _currentList));
    } else if (response.statusCode == 404) {
      emit(ScanError('Aliment non trouvé dans la base de données',
          scannedFoods: _currentList));
    } else if (response.statusCode == 500) {
      emit(ScanError('Erreur interne du serveur', scannedFoods: _currentList));
    } else {
      emit(ScanError('Erreur lors du scan (${response.statusCode})',
          scannedFoods: _currentList));
    }
  }

  void _onAddFoodToList(AddFoodToList event, Emitter<ScanState> emit) {
    if (state is ScanSuccess) {
      final currentFood = (state as ScanSuccess).food;
      _currentList = [..._currentList, currentFood];
      emit(ScanInitial(scannedFoods: _currentList));
    }
  }

  void _onRemoveFoodFromList(
      RemoveFoodFromList event, Emitter<ScanState> emit) {
    _currentList = List.from(_currentList)..removeAt(event.index);
    emit(ScanInitial(scannedFoods: _currentList));
  }

  void _onClearFoodList(ClearFoodList event, Emitter<ScanState> emit) {
    _currentList = [];
    emit(ScanInitial(scannedFoods: _currentList));
  }

  void _onResetScan(ResetScan event, Emitter<ScanState> emit) {
    emit(ScanInitial(scannedFoods: _currentList));
  }
}
