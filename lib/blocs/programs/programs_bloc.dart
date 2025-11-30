import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:application_nutrition/config/api_config.dart';
import 'programs_event.dart';
import 'programs_state.dart';
import '../../models/nutrition_program.dart';
import '../../blocs/token.dart';

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {
  List<NutritionProgram>? _cachedPrograms;
  bool _isFirstLoad = true;

  ProgramsBloc() : super(ProgramsInitial()) {
    on<LoadPrograms>(_onLoadPrograms);
  }

  Future<void> _onLoadPrograms(
      LoadPrograms event, Emitter<ProgramsState> emit) async {
    // Si on a déjà des données en cache et que ce n'est pas le premier chargement
    // et que ce n'est pas un refresh forcé
    if (_cachedPrograms != null && !_isFirstLoad && !event.forceRefresh) {
      emit(ProgramsLoaded(_cachedPrograms!));
      return;
    }

    emit(ProgramsLoading());

    try {
      final token = await getAuthToken();

      if (token == null) {
        emit(
            ProgramsError('Vous devez être connecté pour voir vos programmes'));
        return;
      }

      final response = await http.get(
        Uri.parse(ApiConfig.programsUrl),
        headers: {
          'Cookie': '${ApiConfig.tokenKey}=$token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Le serveur ne répond pas');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          final programsList = data['programs'] as List<dynamic>;
          final programs = programsList
              .map((programJson) => NutritionProgram.fromJson(programJson))
              .toList();

          _cachedPrograms = programs;
          _isFirstLoad = false;

          emit(ProgramsLoaded(programs));
        } else {
          emit(ProgramsError('Erreur lors de la récupération des programmes'));
        }
      } else if (response.statusCode == 401) {
        emit(ProgramsError('Session expirée. Veuillez vous reconnecter.'));
      } else {
        emit(ProgramsError(
            'Erreur lors du chargement des programmes (${response.statusCode})'));
      }
    } on SocketException {
      if (_cachedPrograms != null) {
        emit(ProgramsLoaded(_cachedPrograms!));
      } else {
        emit(ProgramsError('Pas de connexion internet'));
      }
    } on TimeoutException {
      if (_cachedPrograms != null) {
        emit(ProgramsLoaded(_cachedPrograms!));
      } else {
        emit(ProgramsError('Le serveur ne répond pas'));
      }
    } on FormatException {
      emit(ProgramsError('Réponse invalide du serveur'));
    } catch (e) {
      emit(ProgramsError('Erreur inattendue: ${e.toString()}'));
    }
  }

  void clearCache() {
    _cachedPrograms = null;
    _isFirstLoad = true;
  }
}
