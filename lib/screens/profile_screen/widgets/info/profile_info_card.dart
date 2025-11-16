import 'package:flutter/material.dart';
import '../../../../models/user_profile.dart';
import 'profile_info_row.dart';

class ProfileInfoCard extends StatelessWidget {
  final UserProfile profile;

  const ProfileInfoCard({
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations physiques',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 16),
          ProfileInfoRow(
            icon: Icons.monitor_weight,
            label: 'Poids',
            value: profile.weight != null
                ? '${profile.weight!.toStringAsFixed(1)} kg'
                : 'Non renseigné',
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          ProfileInfoRow(
            icon: Icons.height,
            label: 'Taille',
            value: profile.height != null
                ? '${profile.height!.toStringAsFixed(0)} cm'
                : 'Non renseigné',
            color: Colors.purple,
          ),
          if (profile.bmi != null) ...[
            const SizedBox(height: 12),
            ProfileInfoRow(
              icon: Icons.trending_up,
              label: 'IMC',
              value:
                  '${profile.bmi!.toStringAsFixed(1)} (${profile.bmiCategory})',
              color: Colors.orange,
            ),
          ],
        ],
      ),
    );
  }
}
