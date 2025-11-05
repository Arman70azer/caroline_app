import 'package:flutter/material.dart';
import '../../../config/colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Caroline',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: AppColors.textLight,
            shadows: [
              Shadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        Text(
          'Votre coach santé personnel',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textLight.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}
