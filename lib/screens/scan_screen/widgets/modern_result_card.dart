import 'package:flutter/material.dart';
import '../../../config/colors.dart';
import '../../../models/food_info.dart';
import 'macro_card.dart';
import 'recommendation_card.dart';

class ModernResultCard extends StatelessWidget {
  final FoodInfo food;

  const ModernResultCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (food.recommended != null)
          RecommendationCard(recommendation: food.recommended!),

        // Carte d'informations nutritionnelles
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border(
              left: BorderSide(
                color: AppColors.primaryGreen,
                width: 4,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(),
              Divider(height: 1, color: AppColors.border),
              _buildMacrosGrid(),
              if (food.ingredients.isNotEmpty) ...[
                Divider(height: 1, color: AppColors.border),
                _buildIngredients(),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.mintGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              food.groupIcon,
              color: AppColors.primaryGreen,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (food.groupe.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          food.groupe,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.darkGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Icon(Icons.scale_rounded,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '${food.quantity.toInt()}g',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosGrid() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2,
        children: [
          MacroCard(
            label: 'Calories',
            value: food.calories.toInt().toString(),
            unit: 'kcal',
            color: AppColors.primaryOrange,
            icon: Icons.local_fire_department_rounded,
          ),
          MacroCard(
            label: 'Protéines',
            value: food.proteins.toStringAsFixed(1),
            unit: 'g',
            color: AppColors.primaryBlue,
            icon: Icons.fitness_center_rounded,
          ),
          MacroCard(
            label: 'Glucides',
            value: food.carbs.toStringAsFixed(1),
            unit: 'g',
            color: AppColors.carbsColor,
            icon: Icons.grain_rounded,
          ),
          MacroCard(
            label: 'Lipides',
            value: food.fats.toStringAsFixed(1),
            unit: 'g',
            color: AppColors.warmOrange,
            icon: Icons.water_drop_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredients() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant_rounded,
                  size: 16, color: AppColors.primaryBlue),
              const SizedBox(width: 6),
              Text(
                'Ingrédients (${food.ingredients.length})',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...food.ingredients.take(3).map((ingredient) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 6, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    '${ingredient.name} (${ingredient.quantity.toStringAsFixed(0)}g)',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
          if (food.ingredients.length > 3)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '... et ${food.ingredients.length - 3} autre(s)',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textHint,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
