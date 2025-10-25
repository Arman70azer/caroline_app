import 'package:flutter/material.dart';

class LoginTestCredentials extends StatelessWidget {
  const LoginTestCredentials({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        children: [
          Text(
            'Identifiants de test :',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Username: Arman',
            style: TextStyle(color: Colors.white70),
          ),
          Text(
            'Password: password',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
