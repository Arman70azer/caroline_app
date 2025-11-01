import 'package:flutter/material.dart';

/// Constantes de design pour l'écran de scan
class ScanScreenConstants {
  // Dimensions
  static const double scanContainerSize = 280.0;
  static const double scanContainerRadius = 30.0;
  static const double mainContentRadius = 30.0;
  static const double buttonRadius = 30.0;

  // Espacements
  static const double paddingLarge = 24.0;
  static const double paddingMedium = 16.0;
  static const double spacingXLarge = 40.0;
  static const double spacingLarge = 20.0;
  static const double spacingMedium = 16.0;
  static const double spacingSmall = 12.0;

  // Tailles d'icône
  static const double iconSizeLarge = 80.0;

  // Tailles de texte
  static const double fontSizeTitle = 24.0;
  static const double fontSizeButton = 16.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeSmall = 12.0;

  // Elevation
  static const double elevationButton = 8.0;
  static const double blurRadiusShadow = 20.0;

  // Couleurs
  static Color get primaryGreen => Colors.green.shade600;
  static Color get primaryGreenLight => Colors.green.shade500;
  static Color get primaryGreenDark => Colors.green.shade700;
  static Color get primaryGreenDarker => Colors.green.shade800;
  static Color get backgroundGreenLight => Colors.green.shade100;
  static Color get backgroundGreenLighter => Colors.green.shade50;
  static Color get greyText => Colors.grey.shade500;

  // Durées d'animation
  static const Duration resetDelay = Duration(milliseconds: 100);

  // Messages
  static const String scanButtonText = 'Scanner un aliment';
  static const String scanAgainButtonText = 'Scanner un autre aliment';
  static const String loadingText = 'Analyse en cours...';
  static const String apiUrl = 'API: http://monserver.com/scan';
}
