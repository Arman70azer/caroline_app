import 'package:application_nutrition/screens/profile_screen/widgets/goals_edit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../config/colors.dart';
import 'widgets/profile_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Charger le profil seulement s'il n'est pas déjà chargé
    final currentState = context.read<ProfileBloc>().state;
    if (currentState is! ProfileLoaded) {
      context.read<ProfileBloc>().add(LoadProfile());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return const ProfileLoadingFetch();
                  }

                  if (state is ProfileError) {
                    return ProfileErrorFetch(
                      message: state.message,
                      onRetry: () =>
                          context.read<ProfileBloc>().add(RefreshProfile()),
                    );
                  }

                  if (state is ProfileLoaded) {
                    final profile = state.profile;

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ProfileBloc>().add(RefreshProfile());
                        await context.read<ProfileBloc>().stream.firstWhere(
                              (state) =>
                                  state is ProfileLoaded ||
                                  state is ProfileError,
                            );
                      },
                      color: AppColors.primaryGreen,
                      backgroundColor: Colors.white,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Card principale du profil
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Avatar et Header
                                  const SizedBox(height: 16),
                                  ProfileAvatar(gender: profile.gender),
                                  const SizedBox(height: 16),
                                  ProfileHeader(
                                    fullName: profile.fullName,
                                    gender: profile.genderFormatted,
                                    age: profile.age,
                                  ),

                                  // Informations physiques
                                  ProfileInfoCard(profile: profile),
                                ],
                              ),
                            ),

                            // Objectifs (si présents)
                            if (profile.goals.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              ProfileGoalsCard(profile: profile),
                            ],

                            const SizedBox(height: 24),

                            // Boutons d'action
                            Column(
                              children: [
                                // Bouton de modification du profil
                                SizedBox(
                                  width: double.infinity,
                                  child: ProfileEditButton(profile: profile),
                                ),

                                const SizedBox(height: 12),

                                // Bouton de gestion des objectifs
                                SizedBox(
                                  width: double.infinity,
                                  child: GoalsEditButton(profile: profile),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
