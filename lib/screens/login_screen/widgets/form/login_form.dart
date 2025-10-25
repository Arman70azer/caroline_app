import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/login/login_bloc.dart';
import '../../../../blocs/login/login_event.dart';
import '../../../../blocs/login/login_state.dart';
import 'login_text_field.dart';
import 'login_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    context.read<LoginBloc>().add(
          LoginUser(
            _usernameController.text,
            _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Connexion',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          LoginTextField(
            controller: _usernameController,
            label: 'Nom d\'utilisateur',
            icon: Icons.person,
            isPassword: false,
          ),
          const SizedBox(height: 16),
          LoginTextField(
            controller: _passwordController,
            label: 'Mot de passe',
            icon: Icons.lock,
            isPassword: true,
          ),
          const SizedBox(height: 24),
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return LoginButton(
                onPressed: state is LoginLoading ? null : _handleLogin,
                isLoading: state is LoginLoading,
              );
            },
          ),
        ],
      ),
    );
  }
}
