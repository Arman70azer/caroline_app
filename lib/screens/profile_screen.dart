import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/profile/profile_bloc.dart';
import '../blocs/profile/profile_event.dart';
import '../blocs/profile/profile_state.dart';
import '../widgets/stat_card.dart';
import '../widgets/progress_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NutriSport',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text('Votre coach santé personnel',
                      style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: Colors.green.shade600));
                    }
                    if (state is ProfileError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message,
                                style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                                onPressed: () => context
                                    .read<ProfileBloc>()
                                    .add(RefreshProfile()),
                                child: const Text('Réessayer')),
                          ],
                        ),
                      );
                    }
                    if (state is ProfileLoaded) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<ProfileBloc>().add(RefreshProfile());
                          await Future.delayed(
                              const Duration(milliseconds: 500));
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.green.shade500,
                                    Colors.green.shade600
                                  ]),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.person,
                                    size: 48, color: Colors.white),
                              ),
                              const SizedBox(height: 16),
                              Text(state.profile.name,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold)),
                              Text('Membre depuis ${state.profile.memberSince}',
                                  style:
                                      TextStyle(color: Colors.grey.shade600)),
                              const SizedBox(height: 32),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4))
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Statistiques du jour',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade700)),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        StatCard(
                                            value:
                                                '${state.profile.caloriesConsumed}',
                                            label: 'Calories'),
                                        StatCard(
                                            value: state.profile.exerciseTime,
                                            label: 'Exercice'),
                                        StatCard(
                                            value: state.profile.waterIntake,
                                            label: 'Eau'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4))
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Objectifs',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade700)),
                                    const SizedBox(height: 16),
                                    ProgressBar(
                                        label: 'Perte de poids',
                                        progress:
                                            state.profile.weightLossProgress),
                                    const SizedBox(height: 16),
                                    ProgressBar(
                                        label: 'Masse musculaire',
                                        progress:
                                            state.profile.muscleMassProgress),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
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
