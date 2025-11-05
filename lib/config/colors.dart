import 'package:flutter/material.dart';

/// 🎨 Palette de couleurs principale de l'application NutriSport
class AppColors {
  // 🌱 Verts - Nature & Santé
  static const Color primaryGreen =
      Color(0xFF4CAF50); // Vert équilibré et chaleureux
  static const Color darkGreen = Color(0xFF2E7D32); // Vert profond
  static const Color lightGreen = Color(0xFF81C784); // Vert clair
  static const Color mintGreen = Color(0xFFA5D6A7); // Vert menthe
  static const Color limeGreen = Color(0xFF9CCC65); // Vert lime

  // 🥕 Oranges - Énergie & Vitalité
  static const Color primaryOrange = Color(0xFFFF9800); // Orange énergique
  static const Color warmOrange = Color(0xFFFFB74D); // Orange chaleureux
  static const Color deepOrange = Color(0xFFFF6F00); // Orange profond
  static const Color peach = Color(0xFFFFCC80); // Pêche

  // 🔵 Bleus - Hydratation & Fraîcheur
  static const Color primaryBlue = Color(0xFF42A5F5); // Bleu eau
  static const Color deepBlue = Color(0xFF1976D2); // Bleu profond
  static const Color lightBlue = Color(0xFF90CAF9); // Bleu clair
  static const Color skyBlue = Color(0xFF64B5F6); // Bleu ciel

  // 🟣 Violets - Récupération & Bien-être
  static const Color primaryPurple = Color(0xFF9C27B0); // Violet équilibre
  static const Color lightPurple = Color(0xFFBA68C8); // Violet clair
  static const Color deepPurple = Color(0xFF7B1FA2); // Violet profond

  // 🔴 Rouges - Performance & Effort
  static const Color primaryRed = Color(0xFFE57373); // Rouge effort (doux)
  static const Color deepRed = Color(0xFFD32F2F); // Rouge intense
  static const Color warmRed = Color(0xFFEF5350); // Rouge chaleureux

  // ⚪ Gris - Neutralité & Élégance
  static const Color lightGrey = Color(0xFFF5F5F5); // Gris très clair
  static const Color mediumGrey = Color(0xFFE0E0E0); // Gris moyen
  static const Color darkGrey = Color(0xFF757575); // Gris foncé
  static const Color charcoal = Color(0xFF424242); // Charbon

  // 🎨 Couleurs fonctionnelles
  static const Color background = Color(0xFFFAFAFA); // Fond général
  static const Color surface = Colors.white; // Surface des cartes
  static const Color border = Color(0xFFE0E0E0); // Bordures

  // 🖤 Couleurs de texte
  static const Color textPrimary = Color(0xFF212121); // Texte principal
  static const Color textSecondary = Color(0xFF757575); // Texte secondaire
  static const Color textLight = Colors.white; // Texte sur fond foncé
  static const Color textHint = Color(0xFFBDBDBD); // Texte placeholder

  // ✅ Couleurs d'état
  static const Color success = Color(0xFF4CAF50); // Succès (vert)
  static const Color warning = Color(0xFFFF9800); // Attention (orange)
  static const Color error = Color(0xFFE57373); // Erreur (rouge doux)
  static const Color info = Color(0xFF42A5F5); // Information (bleu)

  // 🌈 Dégradés prédéfinis
  static const LinearGradient greenGradient = LinearGradient(
    colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient blueGradient = LinearGradient(
    colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFBA68C8), Color(0xFF9C27B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFFB74D), Color(0xFFEF5350)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
