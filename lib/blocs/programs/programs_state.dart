import '../../models/nutrition_program.dart';

abstract class ProgramsState {}

class ProgramsInitial extends ProgramsState {}

class ProgramsLoading extends ProgramsState {}

class ProgramsLoaded extends ProgramsState {
  final List<NutritionProgram> programs;
  ProgramsLoaded(this.programs);
}

class ProgramsError extends ProgramsState {
  final String message;
  ProgramsError(this.message);
}
