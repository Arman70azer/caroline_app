import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/login/login_bloc.dart';
import '../../blocs/login/login_state.dart';
import '../../screens/login_screen/widgets/login_background.dart';
import '../../screens/login_screen/widgets/login_logo.dart';
import '../../screens/login_screen/widgets/login_header.dart';
import '../../screens/login_screen/widgets/form/login_form.dart';
import '../../widgets/app_notification.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginState? _previousState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (_previousState != state) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state is LoginError) {
                AppNotification.showError(context, state.message);
              }
            });
            _previousState = state;
          }

          return LoginBackground(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    LoginLogo(),
                    SizedBox(height: 8),
                    LoginHeader(),
                    SizedBox(height: 16),
                    LoginForm(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
