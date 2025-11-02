/// Énumération des tailles d'assiette disponibles
enum PlateSize {
  small,
  medium,
  large;

  String get label {
    switch (this) {
      case PlateSize.small:
        return 'Petite assiette';
      case PlateSize.medium:
        return 'Assiette moyenne';
      case PlateSize.large:
        return 'Grande assiette';
    }
  }

  /// Coefficient multiplicateur pour ajuster les valeurs nutritionnelles
  double get multiplier {
    switch (this) {
      case PlateSize.small:
        return 0.7;
      case PlateSize.medium:
        return 1.0;
      case PlateSize.large:
        return 1.5;
    }
  }
}

/// Classe pour stocker les informations de portion
class PortionInfo {
  final PlateSize? plateSize;
  final double? weight; // Poids en grammes

  const PortionInfo({
    this.plateSize,
    this.weight,
  });

  /// Retourne le multiplicateur à utiliser pour les calculs nutritionnels
  double get multiplier {
    if (weight != null) {
      // Si un poids est renseigné, on utilise un ratio basé sur 100g
      return weight! / 100.0;
    }
    return plateSize?.multiplier ?? 1.0;
  }

  bool get isValid => plateSize != null || weight != null;

  PortionInfo copyWith({
    PlateSize? plateSize,
    double? weight,
  }) {
    return PortionInfo(
      plateSize: plateSize ?? this.plateSize,
      weight: weight ?? this.weight,
    );
  }
}
