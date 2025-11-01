import 'package:flutter/material.dart';

/// Contenu affiché pendant le chargement du scan
///
/// Affiche une icône de caméra, un message et un indicateur de progression
class ScanContentLoading extends StatelessWidget {
  const ScanContentLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.camera_alt,
          size: 80,
          color: Colors.green.shade600,
        ),
        const SizedBox(height: 16),
        Text(
          'Analyse en cours...',
          style: TextStyle(
            color: Colors.green.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        CircularProgressIndicator(
          color: Colors.green.shade600,
        ),
      ],
    );
  }
}
