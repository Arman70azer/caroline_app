abstract class ScanEvent {}

class ScanFood extends ScanEvent {
  final double? recipientSize;

  ScanFood({this.recipientSize});
}

class ResetScan extends ScanEvent {}
