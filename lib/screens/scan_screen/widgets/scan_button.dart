import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/scan/scan_bloc.dart';
import '../../../blocs/scan/scan_event.dart';
import '../../../blocs/scan/scan_state.dart';

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
  void _handleScan(BuildContext context) {
    if (state is ScanSuccess) {
      // Reset puis nouveau scan
      context.read<ScanBloc>().add(ResetScan());
      Future.delayed(
        const Duration(milliseconds: 100),
        () => context.read<ScanBloc>().add(ScanFood()),
      );
    } else {
      // Nouveau scan
      context.read<ScanBloc>().add(ScanFood());
    }
  }

  /// Retourne le texte du bouton selon l'état
  String _getButtonText() {
    return state is ScanSuccess
        ? 'Scanner un autre aliment'
        : 'Scanner un aliment';
  }
}
