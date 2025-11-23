import 'package:flutter/material.dart';

/// Modèle représentant les informations nutritionnelles d'un aliment
class FoodInfo {
  final String name;
  final String groupe;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final double quantity; // Quantité en grammes
  final List<FoodIngredient> ingredients;
  final Recommendation? recommended; // NOUVEAU

  const FoodInfo({
    required this.name,
    required this.groupe,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.quantity,
    this.ingredients = const [],
    this.recommended, // NOUVEAU
  });

  /// Crée une instance depuis un JSON (backend response)
  factory FoodInfo.fromJson(Map<String, dynamic> json) {
    return FoodInfo(
      name: json['name'] as String? ?? '',
      groupe: json['groupe'] as String? ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      proteins: (json['proteins'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 100.0,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((i) => FoodIngredient.fromJson(i as Map<String, dynamic>))
              .toList() ??
          [],
      recommended: json['recommended'] != null
          ? Recommendation.fromJson(json['recommended'] as Map<String, dynamic>)
          : null, // NOUVEAU
    );
  }

  /// Convertit l'instance en JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'groupe': groupe,
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
      'quantity': quantity,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      if (recommended != null) 'recommended': recommended!.toJson(), // NOUVEAU
    };
  }

  /// Crée une copie avec des valeurs modifiées
  FoodInfo copyWith({
    String? name,
    String? groupe,
    double? calories,
    double? proteins,
    double? carbs,
    double? fats,
    double? quantity,
    List<FoodIngredient>? ingredients,
    Recommendation? recommended, // NOUVEAU
  }) {
    return FoodInfo(
      name: name ?? this.name,
      groupe: groupe ?? this.groupe,
      calories: calories ?? this.calories,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      quantity: quantity ?? this.quantity,
      ingredients: ingredients ?? this.ingredients,
      recommended: recommended ?? this.recommended, // NOUVEAU
    );
  }

  @override
  String toString() {
    return 'FoodInfo(name: $name, groupe: $groupe, quantity: ${quantity}g, calories: $calories kcal, proteins: ${proteins}g, carbs: ${carbs}g, fats: ${fats}g)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodInfo &&
        other.name == name &&
        other.groupe == groupe &&
        other.calories == calories &&
        other.proteins == proteins &&
        other.carbs == carbs &&
        other.fats == fats &&
        other.quantity == quantity;
  }

  @override
  int get hashCode {
    return Object.hash(name, groupe, calories, proteins, carbs, fats, quantity);
  }

  /// Retourne l'icône correspondant au groupe alimentaire
  IconData get groupIcon {
    final groupeLower = groupe.toLowerCase();
    if (groupeLower.contains('fruit')) return Icons.apple;
    if (groupeLower.contains('légume')) return Icons.eco;
    if (groupeLower.contains('poisson') | groupeLower.contains('viande')) {
      return Icons.set_meal;
    }
    if (groupeLower.contains('céréale') || groupeLower.contains('pain')) {
      return Icons.bakery_dining;
    }
    if (groupeLower.contains('produit laitier') ||
        groupeLower.contains('lait')) {
      return Icons.local_drink;
    }
    if (groupeLower.contains('plat')) return Icons.restaurant;
    return Icons.fastfood;
  }

  /// Retourne la couleur correspondant au groupe alimentaire
  Color get groupColor {
    final groupeLower = groupe.toLowerCase();
    if (groupeLower.contains('fruit')) return Colors.orange;
    if (groupeLower.contains('légume')) return Colors.green;
    if (groupeLower.contains('viande')) return Colors.red;
    if (groupeLower.contains('poisson')) return Colors.blue;
    if (groupeLower.contains('céréale') || groupeLower.contains('pain')) {
      return Colors.brown;
    }
    if (groupeLower.contains('produit laitier') ||
        groupeLower.contains('lait')) {
      return Colors.indigo;
    }
    if (groupeLower.contains('plat')) return Colors.purple;
    return Colors.grey;
  }
}

/// NOUVEAU: Modèle pour la recommandation
class Recommendation {
  final bool accept;
  final String message;

  const Recommendation({
    required this.accept,
    required this.message,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    return Recommendation(
      accept: json['accept'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accept': accept,
      'message': message,
    };
  }
}

/// Modèle pour les ingrédients d'un aliment
class FoodIngredient {
  final String name;
  final String groupe;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final double quantity;

  const FoodIngredient({
    required this.name,
    required this.groupe,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.quantity,
  });

  factory FoodIngredient.fromJson(Map<String, dynamic> json) {
    return FoodIngredient(
      name: json['name'] as String? ?? '',
      groupe: json['groupe'] as String? ?? '',
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      proteins: (json['proteins'] as num?)?.toDouble() ?? 0.0,
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      fats: (json['fats'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'groupe': groupe,
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
      'quantity': quantity,
    };
  }
}
