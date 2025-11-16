import 'package:flutter/material.dart';
import '../../../../models/food_info.dart';
import '../../../../widgets/nutrient_card.dart';

class ScanContentSuccess extends StatelessWidget {
  final FoodInfo food;

  const ScanContentSuccess({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nom de l'aliment
          Text(
            food.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
            textAlign: TextAlign.center,
          ),

          // Groupe alimentaire
          if (food.groupe.isNotEmpty) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                food.groupe,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          // Quantité
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.scale, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${food.quantity.toStringAsFixed(0)}g',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Grille des nutriments
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              NutrientCard(
                label: 'Calories',
                value: '${food.calories.toStringAsFixed(0)}',
                unit: 'kcal',
              ),
              NutrientCard(
                label: 'Protéines',
                value: '${food.proteins.toStringAsFixed(1)}',
                unit: 'g',
              ),
              NutrientCard(
                label: 'Glucides',
                value: '${food.carbs.toStringAsFixed(1)}',
                unit: 'g',
              ),
              NutrientCard(
                label: 'Lipides',
                value: '${food.fats.toStringAsFixed(1)}',
                unit: 'g',
              ),
            ],
          ),

          // Ingrédients (si disponibles)
          if (food.ingredients.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.restaurant,
                          size: 16, color: Colors.blue.shade700),
                      const SizedBox(width: 6),
                      Text(
                        'Ingrédients (${food.ingredients.length})',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...food.ingredients.take(3).map((ingredient) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• ${ingredient.name} (${ingredient.quantity.toStringAsFixed(0)}g)',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  }),
                  if (food.ingredients.length > 3)
                    Text(
                      '... et ${food.ingredients.length - 3} autre(s)',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
