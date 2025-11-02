import '../../models/food_info.dart';

abstract class ScanState {}

class ScanInitial extends ScanState {
  final List<FoodInfo> scannedFoods;

  ScanInitial({this.scannedFoods = const []});
}

class ScanLoading extends ScanState {
  final List<FoodInfo> scannedFoods;

  ScanLoading({this.scannedFoods = const []});
}

class ScanSuccess extends ScanState {
  final FoodInfo food;
  final List<FoodInfo> scannedFoods;

  ScanSuccess(this.food, {this.scannedFoods = const []});
}

class ScanError extends ScanState {
  final String message;
  final List<FoodInfo> scannedFoods;

  ScanError(this.message, {this.scannedFoods = const []});
}
