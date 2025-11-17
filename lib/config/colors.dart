import 'package:flutter/material.dart';

/// 🎨 Palette de couleurs principale de l'application NutriSport
/// Basée sur le logo : Vert émeraude et Violet indigo
class AppColors {
  // 🌿 Verts Émeraude - Couleur principale du logo
  static const Color primaryGreen = Color(0xFF10B981); // Vert émeraude vif
  static const Color darkGreen = Color(0xFF059669); // Vert émeraude foncé
  static const Color lightGreen = Color(0xFF34D399); // Vert émeraude clair
  static const Color mintGreen = Color(0xFF6EE7B7); // Vert menthe
  static const Color emeraldLight = Color(0xFFA7F3D0); // Émeraude très clair
  static const Color emeraldPale = Color(0xFFD1FAE5); // Émeraude pâle

  // 🟣 Violets/Indigo - Couleur secondaire du logo
  static const Color primaryPurple = Color(0xFF6366F1); // Indigo vif
  static const Color darkPurple = Color(0xFF4F46E5); // Indigo foncé
  static const Color lightPurple = Color(0xFF818CF8); // Indigo clair
  static const Color lavender = Color(0xFFA5B4FC); // Lavande
  static const Color indigoPale = Color(0xFFE0E7FF); // Indigo pâle

  // 🔵 Bleus - Complémentaires
  static const Color primaryBlue = Color(0xFF3B82F6); // Bleu vif
  static const Color deepBlue = Color(0xFF1E40AF); // Bleu profond
  static const Color lightBlue = Color(0xFF60A5FA); // Bleu clair
  static const Color skyBlue = Color(0xFF93C5FD); // Bleu ciel

  // 🟠 Oranges - Énergie & Vitalité (tons chauds)
  static const Color primaryOrange = Color(0xFFF59E0B); // Ambre
  static const Color warmOrange = Color(0xFFFBBF24); // Ambre clair
  static const Color deepOrange = Color(0xFFD97706); // Ambre foncé
  static const Color peach = Color(0xFFFDE68A); // Pêche

  // 🔴 Rouges - Alertes & Erreurs
  static const Color primaryRed = Color(0xFFEF4444); // Rouge vif
  static const Color deepRed = Color(0xFFDC2626); // Rouge intense
  static const Color warmRed = Color(0xFFF87171); // Rouge chaleureux
  static const Color redLight = Color(0xFFFCA5A5); // Rouge clair

  // ⚪ Gris - Neutralité & Élégance
  static const Color lightGrey = Color(0xFFF9FAFB); // Gris très clair
  static const Color mediumGrey = Color(0xFFE5E7EB); // Gris moyen
  static const Color darkGrey = Color(0xFF6B7280); // Gris foncé
  static const Color charcoal = Color(0xFF374151); // Charbon
  static const Color slate = Color(0xFF1F2937); // Ardoise

  // 🎨 Couleurs fonctionnelles
  static const Color background = Color(0xFFFAFAFB); // Fond général
  static const Color surface = Colors.white; // Surface des cartes
  static const Color border = Color(0xFFE5E7EB); // Bordures
  static const Color divider = Color(0xFFF3F4F6); // Séparateurs

  // 🖤 Couleurs de texte
  static const Color textPrimary = Color(0xFF111827); // Texte principal
  static const Color textSecondary = Color(0xFF6B7280); // Texte secondaire
  static const Color textLight = Colors.white; // Texte sur fond foncé
  static const Color textHint = Color(0xFF9CA3AF); // Texte placeholder

  // ✅ Couleurs d'état
  static const Color success = Color(0xFF10B981); // Succès (vert émeraude)
  static const Color warning = Color(0xFFF59E0B); // Attention (ambre)
  static const Color error = Color(0xFFEF4444); // Erreur (rouge)
  static const Color info = Color(0xFF3B82F6); // Information (bleu)

  // 🌈 Dégradés prédéfinis basés sur le logo
  static const LinearGradient emeraldGradient = LinearGradient(
    colors: [Color(0xFF34D399), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient indigoGradient = LinearGradient(
    colors: [Color(0xFF818CF8), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient logoGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGreenGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF10B981)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // 🎨 Couleurs pour les macronutriments (à utiliser dans l'app)
  static const Color caloriesColor = Color(0xFFF59E0B); // Ambre
  static const Color proteinsColor = Color(0xFF6366F1); // Indigo
  static const Color carbsColor = Color(0xFF10B981); // Émeraude
  static const Color fatsColor = Color(0xFFEF4444); // Rouge
}
