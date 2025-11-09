import '../models/goal.dart';

class UserProfile {
  final int id;
  final String name;
  final String surname;
  final double? weight;
  final double? height;
  final int? age;
  final String? gender;
  final List<Goal> goals;

  UserProfile({
    required this.id,
    required this.name,
    required this.surname,
    this.weight,
    this.height,
    this.age,
    this.gender,
    this.goals = const [],
  });

  /// Construit un UserProfile depuis un JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int,
      name: json['name'] as String,
      surname: json['surname'] as String,
      weight:
          json['weight'] != null ? (json['weight'] as num).toDouble() : null,
      height:
          json['height'] != null ? (json['height'] as num).toDouble() : null,
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      goals: (json['goals'] as List<dynamic>?)
              ?.map((g) => Goal.fromJson(g as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convertit le profil en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'goals': goals.map((g) => g.toJson()).toList(),
    };
  }

  /// Nom complet
  String get fullName => '$name $surname';

  /// IMC (Indice de Masse Corporelle)
  double? get bmi {
    if (weight == null || height == null || height == 0) return null;
    final heightInMeters = height! / 100; // Convertir cm en m
    return weight! / (heightInMeters * heightInMeters);
  }

  /// Catégorie IMC
  String get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return 'Non disponible';
    if (bmiValue < 18.5) return 'Sous-poids';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Surpoids';
    return 'Obésité';
  }

  /// Icône du genre
  String get genderIcon {
    if (gender == null) return '👤';
    switch (gender!.toLowerCase()) {
      case 'male':
      case 'homme':
      case 'm':
        return '👨';
      case 'female':
      case 'femme':
      case 'f':
        return '👩';
      default:
        return '👤';
    }
  }

  /// Genre formaté
  String get genderFormatted {
    if (gender == null) return 'Non spécifié';
    switch (gender!.toLowerCase()) {
      case 'male':
      case 'homme':
      case 'm':
        return 'Homme';
      case 'female':
      case 'femme':
      case 'f':
        return 'Femme';
      default:
        return gender!;
    }
  }

  /// Objectif de perte de poids
  double? get weightLossGoal {
    if (goals.isEmpty) return null;
    for (var goal in goals) {
      if (goal.weightLoss != null) return goal.weightLoss;
    }
    return null;
  }

  /// Objectif de prise de muscle
  double? get muscleGainGoal {
    if (goals.isEmpty) return null;
    for (var goal in goals) {
      if (goal.muscleGain != null) return goal.muscleGain;
    }
    return null;
  }

  /// Copie avec modifications
  UserProfile copyWith({
    int? id,
    String? name,
    String? surname,
    double? weight,
    double? height,
    int? age,
    String? gender,
    List<Goal>? goals,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      goals: goals ?? this.goals,
    );
  }
}
