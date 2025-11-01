import 'package:flutter/material.dart';
import '../../../../blocs/scan/scan_state.dart';
import 'scan_content_idle.dart';
import 'scan_content_loading.dart';
import 'scan_content_success.dart';

/// Container principal pour l'affichage du contenu du scan
///
/// Gère l'affichage selon l'état actuel du scan (idle, loading, success)
class ScanContainer extends StatelessWidget {
  final ScanState state;

  const ScanContainer({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade100,
            Colors.green.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (state is ScanLoading) {
      return const ScanContentLoading();
    }

    if (state is ScanSuccess) {
      return ScanContentSuccess(food: (state as ScanSuccess).food);
    }

    return const ScanContentIdle();
  }
}
