abstract class ProgramsEvent {}

class LoadPrograms extends ProgramsEvent {
  final bool forceRefresh;

  LoadPrograms({this.forceRefresh = false});
}
