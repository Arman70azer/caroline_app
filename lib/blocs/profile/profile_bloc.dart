import 'dart:async';
import 'package:application_nutrition/config/api_config.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../models/user_profile.dart';
import '../../blocs/token.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserProfile? _cachedProfile;
  bool _isFirstLoad = true;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<RefreshProfile>(_onRefreshProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateGoals>(_onUpdateGoals);
  }

  Future<void> _onUpdateGoals(
      UpdateGoals event, Emitter<ProfileState> emit) async {
    final currentProfile = _cachedProfile;
    if (currentProfile == null) {
      emit(ProfileError('Aucun profil chargé'));
      return;
    }

    emit(GoalsUpdating(currentProfile));

    try {
      final token = await getAuthToken();

      if (token == null) {
        emit(GoalsUpdateError(currentProfile, 'Session expirée'));
        return;
      }

      final response = await http
          .post(
            Uri.parse(ApiConfig.createGoalUrl),
            headers: {
              'Content-Type': 'application/json',
              'Cookie': '${ApiConfig.tokenKey}=$token',
            },
            body: jsonEncode({
              'weightLoss': event.weightLoss,
              'muscleGain': event.muscleGain,
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Le serveur ne répond pas'),
          );

      if (response.statusCode == 200) {
        // Invalider le cache et forcer le rechargement
        clearCache();
        _isFirstLoad = true;

        // Recharger le profil depuis le serveur
        await _onLoadProfile(LoadProfile(), emit);

        if (state is ProfileLoaded) {
          final updatedProfile = (state as ProfileLoaded).profile;

          emit(GoalsUpdateSuccess(
            updatedProfile,
            'Objectifs mis à jour avec succès !',
          ));

          // Revenir à l'état normal après une courte pause
          await Future.delayed(const Duration(milliseconds: 150));
          emit(ProfileLoaded(updatedProfile));
        }
      } else {
        final error = jsonDecode(response.body);
        emit(GoalsUpdateError(
          currentProfile,
          error['message'] ?? 'Erreur lors de la mise à jour des objectifs',
        ));
      }
    } on SocketException {
      emit(GoalsUpdateError(currentProfile, 'Pas de connexion internet'));
    } on TimeoutException {
      emit(GoalsUpdateError(currentProfile, 'Le serveur ne répond pas'));
    } on FormatException {
      emit(GoalsUpdateError(currentProfile, 'Réponse invalide du serveur'));
    } catch (e) {
      emit(GoalsUpdateError(
          currentProfile, 'Erreur inattendue: ${e.toString()}'));
    }
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    if (_cachedProfile != null && !_isFirstLoad) {
      emit(ProfileLoaded(_cachedProfile!));
      return;
    }

    emit(ProfileLoading());

    try {
      final token = await getAuthToken();
      if (token == null) {
        emit(ProfileError('Vous devez être connecté pour voir votre profil'));
        return;
      }

      final response = await http.get(
        Uri.parse(ApiConfig.profileUrl),
        headers: {
          'Cookie': 'auth_token=$token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Le serveur ne répond pas');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final profile = UserProfile.fromJson(data);

        _cachedProfile = profile;
        _isFirstLoad = false;

        emit(ProfileLoaded(profile));
      } else if (response.statusCode == 401) {
        emit(ProfileError('Session expirée. Veuillez vous reconnecter.'));
      } else {
        emit(ProfileError(
            'Erreur lors du chargement du profil (${response.statusCode})'));
      }
    } on SocketException {
      if (_cachedProfile != null) {
        emit(ProfileLoaded(_cachedProfile!));
      } else {
        emit(ProfileError('Pas de connexion internet'));
      }
    } on TimeoutException {
      if (_cachedProfile != null) {
        emit(ProfileLoaded(_cachedProfile!));
      } else {
        emit(ProfileError('Le serveur ne répond pas'));
      }
    } on FormatException {
      emit(ProfileError('Réponse invalide du serveur'));
    } catch (e) {
      emit(ProfileError('Erreur inattendue: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshProfile(
      RefreshProfile event, Emitter<ProfileState> emit) async {
    final wasFirstLoad = _isFirstLoad;
    _isFirstLoad = true;

    await _onLoadProfile(LoadProfile(), emit);

    if (state is! ProfileLoaded) {
      _isFirstLoad = wasFirstLoad;
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<ProfileState> emit) async {
    // Garder le profil actuel pour revenir en cas d'erreur
    final currentProfile = _cachedProfile;
    if (currentProfile == null) {
      emit(ProfileError('Aucun profil chargé'));
      return;
    }

    emit(ProfileUpdating(currentProfile));

    try {
      final token = await getAuthToken();

      if (token == null) {
        emit(ProfileUpdateError(currentProfile, 'Session expirée'));
        return;
      }

      final response = await http
          .post(
        Uri.parse(ApiConfig.editProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Cookie': '${ApiConfig.tokenKey}=$token',
        },
        body: jsonEncode({
          'name': event.name,
          'surname': event.surname,
          'weight': event.weight,
          'height': event.height,
          'age': event.age,
          'gender': event.gender,
          'password': event.password,
        }),
      )
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Le serveur ne répond pas');
        },
      );

      if (response.statusCode == 200) {
        // Invalider le cache et recharger le profil
        clearCache();
        _isFirstLoad = true;

        // Recharger le profil depuis le serveur
        await _onLoadProfile(LoadProfile(), emit);

        // Si le chargement a réussi, émettre un état de succès
        if (state is ProfileLoaded) {
          final updatedProfile = (state as ProfileLoaded).profile;

          emit(ProfileUpdateSuccess(
              updatedProfile, 'Profil mis à jour avec succès !'));
          // Remettre l'état ProfileLoaded après un court instant
          await Future.delayed(const Duration(milliseconds: 100));
          emit(ProfileLoaded(updatedProfile));
        }
      } else {
        final error = jsonDecode(response.body);
        emit(ProfileUpdateError(
          currentProfile,
          error['message'] ?? 'Erreur lors de la mise à jour',
        ));
      }
    } on SocketException catch (_) {
      emit(ProfileUpdateError(currentProfile, 'Pas de connexion internet'));
    } on TimeoutException catch (_) {
      emit(ProfileUpdateError(currentProfile, 'Le serveur ne répond pas'));
    } on FormatException catch (_) {
      emit(ProfileUpdateError(currentProfile, 'Réponse invalide du serveur'));
    } catch (e) {
      emit(ProfileUpdateError(
          currentProfile, 'Erreur inattendue: ${e.toString()}'));
    }
  }

  void clearCache() {
    _cachedProfile = null;
    _isFirstLoad = true;
  }
}
