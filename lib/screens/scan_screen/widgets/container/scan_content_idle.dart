import 'package:flutter/material.dart';

/// Contenu affiché quand le scan est au repos
///
/// Affiche simplement une icône de caméra
class ScanContentIdle extends StatelessWidget {
  const ScanContentIdle({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.camera_alt,
      size: 80,
      color: Colors.green.shade600,
    );
  }
}
