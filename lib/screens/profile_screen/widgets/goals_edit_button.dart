import 'package:flutter/material.dart';
import '../../../models/user_profile.dart';
import '../widgets/goals_modal/goals_edit_modal.dart';

class GoalsEditButton extends StatelessWidget {
  final UserProfile profile;

  const GoalsEditButton({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (modalContext) => GoalsEditModal(
            profile: profile,
            parentContext: context,
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.orange.shade600,
        side: BorderSide(
          color: Colors.orange.shade600,
          width: 2,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.flag),
      label: const Text('Gérer mes objectifs'),
    );
  }
}
