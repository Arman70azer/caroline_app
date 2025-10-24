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
    await Future.delayed(const Duration(seconds: 2));
    final food = FoodInfo(
      name: 'Pomme Golden',
      calories: 95,
      proteins: 0.5,
      carbs: 25,
      fats: 0.3,
    );
    emit(ScanSuccess(food));
  }

  void _onResetScan(ResetScan event, Emitter<ScanState> emit) {
    emit(ScanInitial());
  }
}
