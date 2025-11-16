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
        foods.fold<double>(0.0, (sum, food) => sum + food.calories);
    final totalProteins =
        foods.fold<double>(0.0, (sum, food) => sum + food.proteins);
    final totalCarbs = foods.fold<double>(0.0, (sum, food) => sum + food.carbs);
    final totalFats = foods.fold<double>(0.0, (sum, food) => sum + food.fats);
    final totalQuantity =
        foods.fold<double>(0.0, (sum, food) => sum + food.quantity);

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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.list_alt, size: 20, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Aliments ajoutés (${foods.length})',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {
                  context.read<ScanBloc>().add(ClearFoodList());
                },
                icon: Icon(Icons.delete_sweep,
                    size: 18, color: Colors.red.shade600),
                label: Text(
                  'Effacer',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Liste des aliments
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
                    // Icône selon le groupe
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: food.groupColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        food.groupIcon,
                        color: food.groupColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Informations
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (food.groupe.isNotEmpty) ...[
                                Text(
                                  food.groupe,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  ' • ',
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                              ],
                              Text(
                                '${food.quantity.toStringAsFixed(0)}g',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${food.calories.toStringAsFixed(0)} kcal • ${food.proteins.toStringAsFixed(1)}g prot.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bouton supprimer
                    IconButton(
                      icon: Icon(Icons.close,
                          color: Colors.red.shade400, size: 20),
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

          // Totaux
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.calculate,
                        size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 6),
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${totalQuantity.toStringAsFixed(0)}g',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTotalItem(
                        'Calories', totalCalories.toStringAsFixed(0), 'kcal'),
                    _buildTotalItem(
                        'Protéines', totalProteins.toStringAsFixed(1), 'g'),
                    _buildTotalItem(
                        'Glucides', totalCarbs.toStringAsFixed(1), 'g'),
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
