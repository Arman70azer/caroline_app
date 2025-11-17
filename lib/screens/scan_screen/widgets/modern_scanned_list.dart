import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/scan/scan_bloc.dart';
import '../../../blocs/scan/scan_event.dart';
import '../../../config/colors.dart';
import '../../../models/food_info.dart';

class ModernScannedList extends StatelessWidget {
  final List<FoodInfo> foods;

  const ModernScannedList({
    super.key,
    required this.foods,
  });

  @override
  Widget build(BuildContext context) {
    final totalCalories =
        foods.fold<double>(0.0, (sum, food) => sum + food.calories);
    final totalProteins =
        foods.fold<double>(0.0, (sum, food) => sum + food.proteins);
    final totalCarbs = foods.fold<double>(0.0, (sum, food) => sum + food.carbs);
    final totalFats = foods.fold<double>(0.0, (sum, food) => sum + food.fats);
    final totalQuantity =
        foods.fold<double>(0.0, (sum, food) => sum + food.quantity);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          Divider(height: 1, color: AppColors.border),
          _buildFoodList(context),
          Divider(height: 1, color: AppColors.border),
          _buildTotals(totalCalories, totalProteins, totalCarbs, totalFats,
              totalQuantity),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(Icons.list_alt_rounded, size: 20, color: AppColors.primaryGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Aliments ajoutés (${foods.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () {
              context.read<ScanBloc>().add(ClearFoodList());
            },
            icon: Icon(Icons.delete_sweep_rounded,
                size: 18, color: AppColors.error),
            label: Text(
              'Effacer',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: foods.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final food = foods[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: food.groupColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  food.groupIcon,
                  color: food.groupColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${food.quantity.toInt()}g • ${food.calories.toInt()} kcal • ${food.proteins.toStringAsFixed(1)}g prot.',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon:
                    Icon(Icons.close_rounded, color: AppColors.error, size: 20),
                onPressed: () {
                  context.read<ScanBloc>().add(RemoveFoodFromList(index));
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTotals(double calories, double proteins, double carbs,
      double fats, double quantity) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.calculate_rounded,
                  size: 16, color: AppColors.primaryGreen),
              const SizedBox(width: 6),
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const Spacer(),
              Text(
                '${quantity.toInt()}g',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildTotalItem('Calories', calories.toInt().toString(),
                    'kcal', AppColors.primaryOrange),
              ),
              Expanded(
                child: _buildTotalItem('Protéines', proteins.toStringAsFixed(1),
                    'g', AppColors.primaryBlue),
              ),
              Expanded(
                child: _buildTotalItem('Glucides', carbs.toStringAsFixed(1),
                    'g', AppColors.carbsColor),
              ),
              Expanded(
                child: _buildTotalItem('Lipides', fats.toStringAsFixed(1), 'g',
                    AppColors.warmOrange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTotalItem(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              TextSpan(
                text: unit,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
