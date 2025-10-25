import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'dart:async';

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
      // Simulation appel API: POST http://monserver.com/login
      await Future.delayed(const Duration(seconds: 2));

      // Vérification hardcodée des credentials
      if (event.username == 'Arman' && event.password == 'password') {
        // Génération d'un token fictif
        final token = 'token_${DateTime.now().millisecondsSinceEpoch}';

        // Sauvegarde du token et username
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('username', event.username);

        emit(LoginAuthenticated(token, event.username));
      } else {
        emit(LoginError('Nom d\'utilisateur ou mot de passe incorrect'));
      }
    } catch (e) {
      emit(LoginError('Erreur de connexion'));
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
