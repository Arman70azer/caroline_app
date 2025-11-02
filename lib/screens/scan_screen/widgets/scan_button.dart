import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/scan/scan_bloc.dart';
import '../../../blocs/scan/scan_event.dart';
import '../../../blocs/scan/scan_state.dart';
import '../../../models/portion_size.dart';
import 'portion_selector_dialog.dart';

/// Bouton pour déclencher le scan d'aliment
///
/// Le texte et le comportement du bouton changent selon l'état du scan
class ScanButton extends StatelessWidget {
  final ScanState state;

  const ScanButton({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Text(
        _getButtonText(),
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Gère l'action du bouton selon l'état actuel
  Future<void> _handleScan(BuildContext context) async {
    if (state is ScanSuccess) {
      // Reset puis nouveau scan avec dialogue
      context.read<ScanBloc>().add(ResetScan());
      await Future.delayed(const Duration(milliseconds: 100));
      await _showPortionDialogAndScan(context);
    } else {
      // Afficher le dialogue puis scanner
      await _showPortionDialogAndScan(context);
    }
  }

  /// Affiche le dialogue de sélection de portion et lance le scan
  Future<void> _showPortionDialogAndScan(BuildContext context) async {
    final portionInfo = await showDialog<PortionInfo>(
      context: context,
      builder: (context) => const PortionSelectorDialog(),
    );

    // Si l'utilisateur a confirmé une portion, lancer le scan
    if (portionInfo != null && portionInfo.isValid) {
      if (context.mounted) {
        context.read<ScanBloc>().add(
              ScanFood(recipientSize: portionInfo.multiplier),
            );
      }
    }
  }

  /// Retourne le texte du bouton selon l'état
  String _getButtonText() {
    return state is ScanSuccess
        ? 'Scanner un autre aliment'
        : 'Scanner un aliment';
  }
}
