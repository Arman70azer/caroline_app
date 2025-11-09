import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String fullName;
  final String gender;
  final int? age;

  const ProfileHeader({
    super.key,
    required this.fullName,
    required this.gender,
    this.age,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          fullName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$gender${age != null ? " • $age ans" : ""}',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
