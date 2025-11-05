import 'package:flutter/material.dart';
import '../../../config/colors.dart';

class LoginTestCredentials extends StatelessWidget {
  const LoginTestCredentials({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.textLight,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'Identifiants de test',
                style: TextStyle(
                  color: AppColors.textLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Username: Arman',
            style: TextStyle(
              color: AppColors.textLight.withOpacity(0.9),
              fontSize: 13,
            ),
          ),
          Text(
            'Password: password',
            style: TextStyle(
              color: AppColors.textLight.withOpacity(0.9),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
