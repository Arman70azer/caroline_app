import '../../models/portion_size.dart';

abstract class ScanEvent {}

class ScanFood extends ScanEvent {
  final double? recipientSize;
  final PortionInfo?
      portionInfo; // Nouvelle propriété pour garder toutes les infos

  ScanFood({
    this.recipientSize,
    this.portionInfo,
  });

  /// Retourne le multiplicateur à utiliser, en priorité depuis portionInfo
  double get effectiveMultiplier {
    if (portionInfo != null) {
      return portionInfo!.multiplier;
    }
    return recipientSize ?? 1.0;
  }
}

class ResetScan extends ScanEvent {}
