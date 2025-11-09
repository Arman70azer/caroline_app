import 'package:flutter/material.dart';

class ProfileLoadingFetch extends StatelessWidget {
  const ProfileLoadingFetch({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.green.shade600,
      ),
    );
  }
}
