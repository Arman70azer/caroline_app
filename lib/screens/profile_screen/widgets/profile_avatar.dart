import 'package:flutter/material.dart';
import '../../../config/colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? gender;

  const ProfileAvatar({
    super.key,
    this.gender,
  });

  String _getAvatarImage() {
    if (gender == null) return 'assets/fitboy.png';

    switch (gender!.toLowerCase()) {
      case 'male':
      case 'homme':
      case 'm':
        return 'assets/fitboy.png';
      case 'female':
      case 'femme':
      case 'f':
        return 'assets/fitgirl.png';
      default:
        return 'assets/fitboy.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      height: 125,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lightGreen,
            AppColors.primaryGreen,
            AppColors.darkGreen,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.emeraldLight.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: -5,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(
          padding: const EdgeInsets.all(0.5), // Padding intérieur pour l'image
          child: ClipOval(
            child: Image.asset(
              _getAvatarImage(),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Fallback en cas d'erreur de chargement
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.mintGreen,
                        AppColors.primaryGreen,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      gender?.toLowerCase() == 'female'
                          ? Icons.person
                          : Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
