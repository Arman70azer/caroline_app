import '../../models/portion_size.dart';

abstract class ScanEvent {}

class ScanFood extends ScanEvent {
  final double? recipientSize;
  final PortionInfo? portionInfo;

  ScanFood({
    this.recipientSize,
    this.portionInfo,
  });

  double get effectiveMultiplier {
    if (portionInfo != null) {
      return portionInfo!.multiplier;
    }
    return recipientSize ?? 1.0;
  }
}

class AddFoodToList extends ScanEvent {}

class RemoveFoodFromList extends ScanEvent {
  final int index;

  RemoveFoodFromList(this.index);
}

class ClearFoodList extends ScanEvent {}

class ResetScan extends ScanEvent {}
