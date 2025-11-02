import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/scan/scan_bloc.dart';
import '../../blocs/scan/scan_event.dart';
import '../../blocs/scan/scan_state.dart';
import '../../widgets/compact_header.dart';
import 'widgets/container/scan_container.dart';
import 'widgets/scan_button.dart';
import 'widgets/scan_footer.dart';

/// Écran principal de scan d'aliments
///
/// Cet écran permet à l'utilisateur de scanner des aliments
/// et d'afficher leurs informations nutritionnelles
class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.green.shade600, Colors.green.shade500],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const CompactHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: BlocBuilder<ScanBloc, ScanState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      // ← FIX: Permet le scroll
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height -
                                200, // ← Hauteur minimum
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ScanContainer(state: state),
                              const SizedBox(height: 40),
                              ScanButton(state: state),
                              ScanFooter(state: state),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
