import 'package:flutter_bloc/flutter_bloc.dart';
import 'programs_event.dart';
import 'programs_state.dart';
import '../../models/nutrition_program.dart';
import 'dart:async';

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {
  ProgramsBloc() : super(ProgramsInitial()) {
    on<LoadPrograms>(_onLoadPrograms);
    on<AddProgram>(_onAddProgram);
  }

  Future<void> _onLoadPrograms(
      LoadPrograms event, Emitter<ProgramsState> emit) async {
    emit(ProgramsLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    final programs = [
      NutritionProgram(
        title: 'Programme Nutrition',
        subtitle: 'Semaine 3/12',
        progress: 0.25,
        nextMeal: 'Déjeuner à 12h30',
        isActive: true,
      ),
      NutritionProgram(
        title: 'Programme Sport',
        subtitle: 'Semaine 2/8',
        progress: 0.25,
        nextMeal: 'Cardio - 18h00',
        isActive: true,
      ),
    ];
    emit(ProgramsLoaded(programs));
  }

  Future<void> _onAddProgram(
      AddProgram event, Emitter<ProgramsState> emit) async {
    add(LoadPrograms());
  }
}
