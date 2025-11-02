/// Modèle représentant les informations nutritionnelles d'un aliment
class FoodInfo {
  final String name;
  final int calories;
  final double proteins;
  final int carbs;
  final double fats;

  const FoodInfo({
    required this.name,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  /// Crée une instance depuis un JSON
  factory FoodInfo.fromJson(Map<String, dynamic> json) {
    return FoodInfo(
      name: json['name'] as String,
      calories: json['calories'] as int,
      proteins: (json['proteins'] as num).toDouble(),
      carbs: json['carbs'] as int,
      fats: (json['fats'] as num).toDouble(),
    );
  }

  /// Convertit l'instance en JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'proteins': proteins,
      'carbs': carbs,
      'fats': fats,
    };
  }

  /// Crée une copie avec des valeurs modifiées
  FoodInfo copyWith({
    String? name,
    int? calories,
    double? proteins,
    int? carbs,
    double? fats,
  }) {
    return FoodInfo(
      name: name ?? this.name,
      calories: calories ?? this.calories,
      proteins: proteins ?? this.proteins,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
    );
  }

  @override
  String toString() {
    return 'FoodInfo(name: $name, calories: $calories, proteins: ${proteins}g, carbs: ${carbs}g, fats: ${fats}g)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodInfo &&
        other.name == name &&
        other.calories == calories &&
        other.proteins == proteins &&
        other.carbs == carbs &&
        other.fats == fats;
  }

  @override
  int get hashCode {
    return Object.hash(name, calories, proteins, carbs, fats);
  }
}
