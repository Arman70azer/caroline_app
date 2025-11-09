import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String genderIcon;

  const ProfileAvatar({
    super.key,
    required this.genderIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.shade500,
            Colors.green.shade600,
          ],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          genderIcon,
          style: const TextStyle(fontSize: 48),
        ),
      ),
    );
  }
}
