import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/scan/scan_bloc.dart';
import '../../../blocs/scan/scan_event.dart';
import '../../../models/food_info.dart';

class ScannedFoodListWidget extends StatelessWidget {
  final List<FoodInfo> foods;

  const ScannedFoodListWidget({
    super.key,
    required this.foods,
  });

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calcul des totaux
    final totalCalories =
        foods.fold<int>(0, (sum, food) => sum + food.calories);
    final totalProteins =
        foods.fold<double>(0.0, (sum, food) => sum + food.proteins);
    final totalCarbs = foods.fold<int>(0, (sum, food) => sum + food.carbs);
    final totalFats = foods.fold<double>(0.0, (sum, food) => sum + food.fats);

    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aliments ajoutés (${foods.length})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<ScanBloc>().add(ClearFoodList());
                },
                child: Text(
                  'Tout supprimer',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${food.calories} kcal • ${food.proteins}g protéines',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline,
                          color: Colors.red.shade400),
                      onPressed: () {
                        context.read<ScanBloc>().add(RemoveFoodFromList(index));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTotalItem('Calories', '$totalCalories', 'kcal'),
                    _buildTotalItem(
                        'Protéines', totalProteins.toStringAsFixed(1), 'g'),
                    _buildTotalItem('Glucides', '$totalCarbs', 'g'),
                    _buildTotalItem(
                        'Lipides', totalFats.toStringAsFixed(1), 'g'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              TextSpan(
                text: unit,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
