import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/scan/scan_bloc.dart';
import '../../../blocs/scan/scan_event.dart';
import '../../../blocs/scan/scan_state.dart';
import '../../../config/colors.dart';
import '../../../models/portion_size.dart';
import '../widgets/portion_selector_dialog.dart';

class ModernActionButtons extends StatelessWidget {
  final ScanState state;

  const ModernActionButtons({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is ScanSuccess) {
      return _buildSuccessButtons(context);
    }

    return _buildScanButtons(context);
  }

  Widget _buildSuccessButtons(BuildContext context) {
    return Column(
      children: [
        // Bouton principal : Ajouter à la liste
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<ScanBloc>().add(AddFoodToList());
            },
            icon: const Icon(Icons.add_rounded, size: 22),
            label: const Text(
              'Ajouter à la liste',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              shadowColor: AppColors.primaryGreen.withOpacity(0.3),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Boutons secondaires (côte à côte)
        Row(
          children: [
            // Bouton Passer
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<ScanBloc>().add(ResetScan());
                },
                icon: const Icon(Icons.skip_next_rounded, size: 20),
                label: const Text(
                  'Passer',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkGrey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: AppColors.mediumGrey,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Bouton Options
            Expanded(
              child: OutlinedButton.icon(
                onPressed: state is ScanLoading
                    ? null
                    : () => _showOptionsDialog(context),
                icon: const Icon(Icons.tune_rounded, size: 20),
                label: const Text(
                  'Options',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: AppColors.primaryPurple,
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScanButtons(BuildContext context) {
    return Column(
      children: [
        // Bouton unique : Options de scan
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed:
                state is ScanLoading ? null : () => _showOptionsDialog(context),
            icon: const Icon(Icons.tune_rounded, size: 20),
            label: const Text(
              'Options de scan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: AppColors.primaryPurple,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showOptionsDialog(BuildContext context) async {
    // Capturer le BuildContext avant l'opération async
    final scanBloc = context.read<ScanBloc>();

    if (state is ScanSuccess) {
      scanBloc.add(ResetScan());
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // Vérifier que le widget est toujours monté
    if (!context.mounted) return;

    final portionInfo = await showDialog<PortionInfo>(
      context: context,
      builder: (context) => const PortionSelectorDialog(),
    );

    // Vérifier à nouveau après le dialog
    if (portionInfo != null && portionInfo.isValid) {
      scanBloc.add(ScanFood(portionInfo: portionInfo));
    }
  }
}
