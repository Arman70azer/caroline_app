import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_event.dart';
import 'login_state.dart';
import 'dart:async';
import '../../config/api_config.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginUser>(_onLoginUser);
    on<LogoutUser>(_onLogoutUser);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final username = prefs.getString('username');

      if (token != null && username != null) {
        emit(LoginAuthenticated(token, username));
      } else {
        emit(LoginUnauthenticated());
      }
    } catch (e) {
      emit(LoginUnauthenticated());
    }
  }

  Future<void> _onLoginUser(LoginUser event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final response = await http
          .post(
        Uri.parse(ApiConfig.loginUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': event.username,
          'password': event.password,
        }),
      )
          .timeout(
        Duration(seconds: ApiConfig.requestTimeout),
        onTimeout: () {
          throw http.ClientException('Timeout: Le serveur ne répond pas');
        },
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Vérification du statut de la réponse
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        // Récupération du token depuis les cookies
        final cookies = response.headers['set-cookie'];

        String? token;

        if (cookies != null) {
          // Extraction du token depuis les cookies
          final cookiesList = cookies.split(';');
          for (var cookie in cookiesList) {
            if (cookie.trim().startsWith('auth_token=')) {
              token = cookie.trim().substring('auth_token='.length);
              break;
            }
          }
        }

        if (token != null) {
          // Sauvegarde du token et username
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          await prefs.setString('username', event.username);

          emit(LoginAuthenticated(token, event.username));
        } else {
          emit(LoginError('Erreur lors de la récupération du token'));
        }
      } else if (response.statusCode == 400) {
        final errorMsg = responseData['message'] ??
            'Nom d\'utilisateur ou mot de passe manquant';
        emit(LoginError(errorMsg));
      } else if (response.statusCode == 401) {
        final errorMsg = responseData['message'] ??
            'Nom d\'utilisateur ou mot de passe incorrect';
        emit(LoginError(errorMsg));
      } else if (response.statusCode == 500) {
        final errorMsg = responseData['message'] ?? 'Erreur interne du serveur';
        emit(LoginError(errorMsg));
      } else {
        emit(LoginError('Erreur de connexion'));
      }
    } on http.ClientException catch (e) {
      emit(LoginError('Impossible de contacter le serveur: ${e.message}'));
    } on FormatException catch (e) {
      emit(LoginError('Réponse du serveur invalide: ${e.message}'));
    } on SocketException catch (_) {
      emit(LoginError(
          'Impossible de contacter le serveur. Vérifiez votre connexion.'));
    } on TimeoutException catch (_) {
      emit(LoginError('Le serveur ne répond pas'));
    } catch (e) {
      emit(LoginError('Erreur de connexion: $e'));
    }
  }

  Future<void> _onLogoutUser(LogoutUser event, Emitter<LoginState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('username');

      emit(LoginUnauthenticated());
    } catch (e) {
      emit(LoginError('Erreur lors de la déconnexion'));
    }
  }
}
