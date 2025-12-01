import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/scan/scan_bloc.dart';
import '../../blocs/scan/scan_state.dart';
import '../../config/colors.dart';
import '../../models/food_info.dart';
import '../../widgets/app_notification.dart';
import 'widgets/modern_scanner_zone.dart';
import 'widgets/scan_button.dart';
import 'widgets/modern_result_card.dart';
import 'widgets/modern_scanned_list.dart';

class ModernScanScreen extends StatelessWidget {
  const ModernScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocListener<ScanBloc, ScanState>(
                listener: (context, state) {
                  if (state is ScanError) {
                    AppNotification.showError(context, state.message);
                  } else if (state is ScanSuccess) {
                    AppNotification.showSuccess(
                      context,
                      '${state.food.name} scanné avec succès !',
                    );
                  }
                },
                child: BlocBuilder<ScanBloc, ScanState>(
                  builder: (context, state) {
                    final scannedFoods = _getScannedFoods(state);
                    final hasResult = state is ScanSuccess; // NOUVEAU

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          // MODIFIÉ: Cacher le scanner si on a un résultat
                          if (!hasResult) ...[
                            ModernScannerZone(state: state),
                            const SizedBox(height: 32),
                          ],
                          ModernActionButtons(state: state),
                          const SizedBox(height: 24),
                          if (state is ScanSuccess)
                            ModernResultCard(food: state.food),
                          if (scannedFoods.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            ModernScannedList(foods: scannedFoods),
                          ],
                        ],
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

  List<FoodInfo> _getScannedFoods(ScanState state) {
    if (state is ScanInitial) return state.scannedFoods;
    if (state is ScanLoading) return state.scannedFoods;
    if (state is ScanSuccess) return state.scannedFoods;
    if (state is ScanError) return state.scannedFoods;
    return [];
  }
}
