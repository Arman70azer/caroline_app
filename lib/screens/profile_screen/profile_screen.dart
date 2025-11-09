import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../../widgets/compact_header.dart';
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
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
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
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              // Avatar
                              ProfileAvatar(genderIcon: profile.genderIcon),
                              const SizedBox(height: 16),

                              // Nom et infos de base
                              ProfileHeader(
                                fullName: profile.fullName,
                                gender: profile.genderFormatted,
                                age: profile.age,
                              ),
                              const SizedBox(height: 32),

                              // Informations physiques
                              ProfileInfoCard(profile: profile),
                              const SizedBox(height: 16),

                              // Objectifs
                              if (profile.goals.isNotEmpty)
                                ProfileGoalsCard(profile: profile),

                              const SizedBox(height: 16),

                              // Bouton de modification
                              ProfileEditButton(
                                onPressed: () {
                                  // TODO: Naviguer vers l'écran d'édition
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Modification du profil - À venir',
                                      ),
                                    ),
                                  );
                                },
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
