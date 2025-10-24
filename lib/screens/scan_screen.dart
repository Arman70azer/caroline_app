import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/scan/scan_bloc.dart';
import '../blocs/scan/scan_event.dart';
import '../blocs/scan/scan_state.dart';
import '../widgets/nutrient_card.dart';

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
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NutriSport',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Votre coach santé personnel',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade100,
                    ),
                  ),
                ],
              ),
            ),
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
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.green.shade100,
                                    Colors.green.shade50
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
                              child: _buildScanContent(state),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: state is ScanLoading
                                  ? null
                                  : () {
                                      if (state is ScanSuccess) {
                                        context
                                            .read<ScanBloc>()
                                            .add(ResetScan());
                                        Future.delayed(
                                            const Duration(milliseconds: 100),
                                            () {
                                          context
                                              .read<ScanBloc>()
                                              .add(ScanFood());
                                        });
                                      } else {
                                        context
                                            .read<ScanBloc>()
                                            .add(ScanFood());
                                      }
                                    },
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
                                state is ScanSuccess
                                    ? 'Scanner un autre aliment'
                                    : 'Scanner un aliment',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (state is ScanSuccess) ...[
                              const SizedBox(height: 16),
                              Text(
                                'API: http://monserver.com/scan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                            if (state is ScanError) ...[
                              const SizedBox(height: 16),
                              Text(
                                state.message,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
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

  Widget _buildScanContent(ScanState state) {
    if (state is ScanLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 80, color: Colors.green.shade600),
          const SizedBox(height: 16),
          Text(
            'Analyse en cours...',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          CircularProgressIndicator(color: Colors.green.shade600),
        ],
      );
    }

    if (state is ScanSuccess) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.food.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                NutrientCard(
                    label: 'Calories', value: '${state.food.calories}'),
                NutrientCard(
                    label: 'Protéines', value: '${state.food.proteins}g'),
                NutrientCard(label: 'Glucides', value: '${state.food.carbs}g'),
                NutrientCard(label: 'Lipides', value: '${state.food.fats}g'),
              ],
            ),
          ],
        ),
      );
    }

    return Icon(Icons.camera_alt, size: 80, color: Colors.green.shade600);
  }
}
