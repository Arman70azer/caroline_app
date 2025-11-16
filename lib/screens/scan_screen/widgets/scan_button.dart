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
        // Bouton principal : Ajouter
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
              elevation: 4,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Bouton secondaire : Rescanner
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed:
                state is ScanLoading ? null : () => _scanDirectly(context),
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: const Text(
              'Scanner un autre aliment',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: AppColors.primaryGreen, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScanButtons(BuildContext context) {
    return Column(
      children: [
        // Bouton principal : Scanner
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed:
                state is ScanLoading ? null : () => _scanDirectly(context),
            icon: const Icon(Icons.camera_alt_rounded, size: 22),
            label: const Text(
              'Scanner avec la caméra',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              disabledBackgroundColor: AppColors.mediumGrey,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Bouton secondaire : Options
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
              foregroundColor: AppColors.primaryGreen,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: AppColors.primaryGreen, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _scanDirectly(BuildContext context) async {
    if (state is ScanSuccess) {
      context.read<ScanBloc>().add(ResetScan());
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (context.mounted) {
      context.read<ScanBloc>().add(ScanFood(portionInfo: null));
    }
  }

  Future<void> _showOptionsDialog(BuildContext context) async {
    if (state is ScanSuccess) {
      context.read<ScanBloc>().add(ResetScan());
      await Future.delayed(const Duration(milliseconds: 100));
    }

    final portionInfo = await showDialog<PortionInfo>(
      context: context,
      builder: (context) => const PortionSelectorDialog(),
    );

    if (portionInfo != null && portionInfo.isValid) {
      if (context.mounted) {
        context.read<ScanBloc>().add(ScanFood(portionInfo: portionInfo));
      }
    }
  }
}
