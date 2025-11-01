import 'package:flutter/material.dart';
import '../../../../widgets/nutrient_card.dart';

/// Contenu affiché quand le scan est réussi
///
/// Affiche le nom de l'aliment et ses informations nutritionnelles
class ScanContentSuccess extends StatelessWidget {
  final dynamic food; // Remplacer 'dynamic' par votre modèle Food

  const ScanContentSuccess({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            food.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              NutrientCard(
                label: 'Calories',
                value: '${food.calories}',
              ),
              NutrientCard(
                label: 'Protéines',
                value: '${food.proteins}g',
              ),
              NutrientCard(
                label: 'Glucides',
                value: '${food.carbs}g',
              ),
              NutrientCard(
                label: 'Lipides',
                value: '${food.fats}g',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
