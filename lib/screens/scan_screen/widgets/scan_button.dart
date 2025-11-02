import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/scan/scan_bloc.dart';
import '../../../blocs/scan/scan_event.dart';
import '../../../blocs/scan/scan_state.dart';
import '../../../models/portion_size.dart';
import 'portion_selector_dialog.dart';

class ScanButton extends StatelessWidget {
  final ScanState state;

  const ScanButton({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    // Si on a un résultat, afficher deux boutons
    if (state is ScanSuccess) {
      return Column(
        children: [
          // Bouton "Ajouter à la liste"
          ElevatedButton.icon(
            onPressed: () {
              context.read<ScanBloc>().add(AddFoodToList());
            },
            icon: const Icon(Icons.add),
            label: const Text('Ajouter à la liste'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 8,
            ),
          ),
          const SizedBox(height: 12),
          // Bouton "Scanner un autre aliment"
          OutlinedButton(
            onPressed: state is ScanLoading ? null : () => _handleScan(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green.shade600,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              side: BorderSide(color: Colors.green.shade600, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Scanner un autre aliment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    // Sinon, afficher le bouton de scan normal
    return ElevatedButton(
      onPressed: state is ScanLoading ? null : () => _handleScan(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 18,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
      ),
      child: const Text(
        'Scanner un aliment',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _handleScan(BuildContext context) async {
    if (state is ScanSuccess) {
      context.read<ScanBloc>().add(ResetScan());
      await Future.delayed(const Duration(milliseconds: 100));
      await _showPortionDialogAndScan(context);
    } else {
      await _showPortionDialogAndScan(context);
    }
  }

  Future<void> _showPortionDialogAndScan(BuildContext context) async {
    final portionInfo = await showDialog<PortionInfo>(
      context: context,
      builder: (context) => const PortionSelectorDialog(),
    );

    if (portionInfo != null && portionInfo.isValid) {
      if (context.mounted) {
        context.read<ScanBloc>().add(
              ScanFood(portionInfo: portionInfo),
            );
      }
    }
  }
}
