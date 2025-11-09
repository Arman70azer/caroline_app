import 'package:flutter/material.dart';
import '../../../../models/user_profile.dart';
import 'profile_goal_row.dart';

class ProfileGoalsCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileGoalsCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mes objectifs',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),
          if (profile.weightLossGoal != null)
            ProfileGoalRow(
              icon: Icons.trending_down,
              label: 'Perte de poids',
              value: '${profile.weightLossGoal!.toStringAsFixed(1)} kg',
              color: Colors.red,
              onTap: () {
                // TODO: Naviguer vers détails de l'objectif
              },
            ),
          if (profile.weightLossGoal != null && profile.muscleGainGoal != null)
            const SizedBox(height: 12),
          if (profile.muscleGainGoal != null)
            ProfileGoalRow(
              icon: Icons.fitness_center,
              label: 'Prise de muscle',
              value: '${profile.muscleGainGoal!.toStringAsFixed(1)} kg',
              color: Colors.green,
              onTap: () {
                // TODO: Naviguer vers détails de l'objectif
              },
            ),
        ],
      ),
    );
  }
}
