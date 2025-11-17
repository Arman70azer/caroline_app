import 'package:flutter/material.dart';
import '../../../blocs/scan/scan_state.dart';

class ScanFooter extends StatelessWidget {
  final ScanState state;

  const ScanFooter({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is ScanError) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text(
          (state as ScanError).message,
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
