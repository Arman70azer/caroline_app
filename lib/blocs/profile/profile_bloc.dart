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
  // Cache du profil pour éviter les requêtes inutiles
  UserProfile? _cachedProfile;
  bool _isFirstLoad = true;

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<RefreshProfile>(_onRefreshProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    // Si on a déjà un profil en cache et que ce n'est pas un refresh forcé
    if (_cachedProfile != null && !_isFirstLoad) {
      emit(ProfileLoaded(_cachedProfile!));
      return;
    }

    emit(ProfileLoading());

    try {
      // Récupérer le token
      final token = await getAuthToken();
      if (token == null) {
        emit(ProfileError('Vous devez être connecté pour voir votre profil'));
        return;
      }

      // Faire la requête
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

        // Sauvegarder dans le cache
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
      // Si on a un cache, on l'affiche avec un message
      if (_cachedProfile != null) {
        emit(ProfileLoaded(_cachedProfile!));
      } else {
        emit(ProfileError('Pas de connexion internet'));
      }
    } on TimeoutException {
      // Si on a un cache, on l'affiche avec un message
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
    // Forcer le rechargement en réinitialisant le flag
    final wasFirstLoad = _isFirstLoad;
    _isFirstLoad = true;

    await _onLoadProfile(LoadProfile(), emit);

    // Si le chargement a échoué, restaurer le flag
    if (state is! ProfileLoaded) {
      _isFirstLoad = wasFirstLoad;
    }
  }

  /// Méthode pour invalider le cache (utile lors d'un logout)
  void clearCache() {
    _cachedProfile = null;
    _isFirstLoad = true;
  }
}
