import 'package:flutter_bloc/flutter_bloc.dart';
import 'scan_event.dart';
import 'scan_state.dart';
import '../../models/food_info.dart';
import 'dart:async';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanInitial()) {
    on<ScanFood>(_onScanFood);
    on<ResetScan>(_onResetScan);
  }

  Future<void> _onScanFood(ScanFood event, Emitter<ScanState> emit) async {
    emit(ScanLoading());

    // Simulation d'un appel API
    await Future.delayed(const Duration(seconds: 2));

    // Données de base de l'aliment scanné
    final baseFoodInfo = FoodInfo(
      name: 'Pomme Golden',
      calories: 95,
      proteins: 0.5,
      carbs: 25,
      fats: 0.3,
    );

    // Ajustement des valeurs selon la taille du récipient
    final recipientSize = event.recipientSize ?? 1.0;
    final adjustedFoodInfo = FoodInfo(
      name: baseFoodInfo.name,
      calories: (baseFoodInfo.calories * recipientSize).round(),
      proteins: baseFoodInfo.proteins * recipientSize,
      carbs: baseFoodInfo.carbs * recipientSize.toInt(),
      fats: baseFoodInfo.fats * recipientSize,
    );

    emit(ScanSuccess(adjustedFoodInfo));

    // TODO: Remplacer par un vrai appel API
    // try {
    //   final response = await http.post(
    //     Uri.parse('http://monserver.com/scan'),
    //     body: {'recipientSize': recipientSize.toString()},
    //   );
    //
    //   if (response.statusCode == 200) {
    //     final data = jsonDecode(response.body);
    //     final food = FoodInfo.fromJson(data);
    //     emit(ScanSuccess(food));
    //   } else {
    //     emit(ScanError('Erreur lors du scan'));
    //   }
    // } catch (e) {
    //   emit(ScanError('Erreur de connexion'));
    // }
  }

  void _onResetScan(ResetScan event, Emitter<ScanState> emit) {
    emit(ScanInitial());
  }
}
