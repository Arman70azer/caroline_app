import 'package:flutter/material.dart';

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
          colors: [
            Colors.green.shade400,
            Colors.green.shade600,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade200,
            blurRadius: 20,
            offset: const Offset(0, 8),
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
                return Center(
                  child: Icon(
                    gender?.toLowerCase() == 'female'
                        ? Icons.person
                        : Icons.person,
                    size: 60,
                    color: Colors.white,
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
