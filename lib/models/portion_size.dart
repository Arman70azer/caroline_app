/// Classe pour stocker les informations de portion
/// Simplifié - OpenAI gère maintenant la détection de quantité
class PortionInfo {
  final double? weight; // Poids manuel en grammes (optionnel)
  final String? productName; // Nom du produit pour recherche manuelle
  final List<String>? productNames; // Liste des produits pour batch

  const PortionInfo({
    this.weight,
    this.productName,
    this.productNames,
  });

  /// Retourne le multiplicateur à utiliser pour les calculs nutritionnels
  /// (Utilisé uniquement si l'utilisateur entre un poids manuel)
  double get multiplier {
    if (weight != null) {
      return weight! / 100.0;
    }
    return 1.0;
  }

  bool get isValid =>
      productName != null || productNames != null || weight != null;

  /// Indique si c'est une saisie manuelle (nom de produit)
  bool get isManualEntry =>
      productName != null || (productNames != null && productNames!.isNotEmpty);

  PortionInfo copyWith({
    double? weight,
    String? productName,
    List<String>? productNames,
  }) {
    return PortionInfo(
      weight: weight ?? this.weight,
      productName: productName ?? this.productName,
      productNames: productNames ?? this.productNames,
    );
  }

  /// Conversion en Map pour l'envoi à l'API
  Map<String, String> toFields() {
    return {
      if (weight != null) 'weight_grams': weight.toString(),
      if (productName != null) 'product_name': productName!,
      if (productNames != null && productNames!.isNotEmpty)
        'product_names': productNames!.join(','),
    };
  }

  /// Conversion en Map pour l'envoi JSON
  Map<String, dynamic> toJson() {
    return {
      if (weight != null) 'weight_grams': weight,
      if (productName != null) 'product_name': productName,
      if (productNames != null && productNames!.isNotEmpty)
        'product_names': productNames,
    };
  }

  @override
  String toString() {
    if (productNames != null && productNames!.isNotEmpty) {
      return 'PortionInfo(products: ${productNames!.join(", ")}, weight: ${weight ?? "auto"}g)';
    }
    if (productName != null) {
      return 'PortionInfo(product: $productName, weight: ${weight ?? "auto"}g)';
    }
    return 'PortionInfo(weight: ${weight ?? "auto"}g)';
  }
}
