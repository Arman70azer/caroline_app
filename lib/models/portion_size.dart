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
  final double? weight;
  final String? productName;
  final List<String>? productNames; // Liste des produits

  const PortionInfo({
    this.plateSize,
    this.weight,
    this.productName,
    this.productNames,
  });

  /// Retourne le multiplicateur à utiliser pour les calculs nutritionnels
  double get multiplier {
    if (weight != null) {
      return weight! / 100.0;
    }
    return plateSize?.multiplier ?? 1.0;
  }

  bool get isValid => plateSize != null || weight != null;

  PortionInfo copyWith({
    PlateSize? plateSize,
    double? weight,
    String? productName,
    List<String>? productNames,
  }) {
    return PortionInfo(
      plateSize: plateSize ?? this.plateSize,
      weight: weight ?? this.weight,
      productName: productName ?? this.productName,
      productNames: productNames ?? this.productNames,
    );
  }

  /// Conversion en Map pour l'envoi à l'API
  Map<String, String> toFields() {
    return {
      if (plateSize != null) 'plate_size': plateSize!.name,
      if (weight != null) 'weight_grams': weight.toString(),
      if (productName != null) 'product_name': productName!,
      if (productNames != null && productNames!.isNotEmpty)
        'product_names': productNames!.join(','),
      'multiplier': multiplier.toString(),
      'portion_type': weight != null ? 'weight' : 'plate',
    };
  }

  /// Conversion en Map pour l'envoi JSON
  Map<String, dynamic> toJson() {
    return {
      if (plateSize != null) 'plate_size': plateSize!.name,
      if (weight != null) 'weight_grams': weight,
      if (productName != null) 'product_name': productName,
      if (productNames != null && productNames!.isNotEmpty)
        'product_names': productNames,
      'multiplier': multiplier,
      'portion_type': weight != null ? 'weight' : 'plate',
    };
  }
}
