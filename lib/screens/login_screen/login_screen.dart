import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/login/login_bloc.dart';
import '../../blocs/login/login_state.dart';
import '../../screens/login_screen/widgets/login_background.dart';
import '../../screens/login_screen/widgets/login_logo.dart';
import '../../screens/login_screen/widgets/login_header.dart';
import '../../screens/login_screen/widgets/form/login_form.dart';
import '../../screens/login_screen/widgets/login_test_credentials.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: LoginBackground(
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
                  LoginTestCredentials(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
