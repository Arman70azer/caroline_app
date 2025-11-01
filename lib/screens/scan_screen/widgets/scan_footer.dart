import 'package:flutter/material.dart';
import '../../../blocs/scan/scan_state.dart';

/// Footer affichant des informations selon l'état du scan
///
/// Affiche l'URL de l'API en cas de succès ou un message d'erreur
class ScanFooter extends StatelessWidget {
  final ScanState state;

  const ScanFooter({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is ScanSuccess) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          'API: http://monserver.com/scan',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      );
    }

    if (state is ScanError) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          state.toString(),
          style: const TextStyle(
            color: Colors.red,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
