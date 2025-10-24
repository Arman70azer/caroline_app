import '../../models/food_info.dart';

abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {
  final FoodInfo food;
  ScanSuccess(this.food);
}

class ScanError extends ScanState {
  final String message;
  ScanError(this.message);
}
