import 'package:flutter/material.dart';

class ProfileEditButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ProfileEditButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.green.shade600,
        side: BorderSide(
          color: Colors.green.shade600,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.edit),
      label: const Text('Modifier mon profil'),
    );
  }
}
