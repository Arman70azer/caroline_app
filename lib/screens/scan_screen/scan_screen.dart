import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/scan/scan_bloc.dart';
import '../../blocs/scan/scan_state.dart';
import '../../models/food_info.dart';
import '../../widgets/compact_header.dart';
import '../../widgets/app_notification.dart';
import 'widgets/container/scan_container.dart';
import 'widgets/scan_button.dart';
import 'widgets/scan_footer.dart';
import 'widgets/scanned_food_list_widget.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
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
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: BlocListener<ScanBloc, ScanState>(
                  listener: (context, state) {
                    if (state is ScanError) {
                      AppNotification.showError(context, state.message);
                    } else if (state is ScanSuccess) {
                      AppNotification.showSuccess(
                        context,
                        '✅ ${state.food.name} scanné avec succès !',
                      );
                    }
                  },
                  child: BlocBuilder<ScanBloc, ScanState>(
                    builder: (context, state) {
                      final scannedFoods = _getScannedFoods(state);

                      // ✅ LayoutBuilder : solution la plus fiable
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          // CAS 1 : Liste vide → Centrer avec Spacer
                          if (scannedFoods.isEmpty) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                  minWidth: constraints
                                      .maxWidth, // ✅ Prendre toute la largeur
                                ),
                                child: IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .stretch, // ✅ Étendre horizontalement
                                      children: [
                                        const Spacer(),
                                        ScanContainer(state: state),
                                        const SizedBox(height: 40),
                                        ScanButton(state: state),
                                        ScanFooter(state: state),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          // CAS 2 : Liste pleine → Scroll normal
                          return SingleChildScrollView(
                            child: SizedBox(
                              width: constraints
                                  .maxWidth, // ✅ Prendre toute la largeur
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .stretch, // ✅ Étendre horizontalement
                                  children: [
                                    ScanContainer(state: state),
                                    const SizedBox(height: 40),
                                    ScanButton(state: state),
                                    ScanFooter(state: state),
                                    ScannedFoodListWidget(foods: scannedFoods),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
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
