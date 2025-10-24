import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

void main() {
  runApp(const NutriSportApp());
}

class NutriSportApp extends StatelessWidget {
  const NutriSportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriSport',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ScanBloc()),
          BlocProvider(create: (_) => ProfileBloc()..add(LoadProfile())),
          BlocProvider(create: (_) => ProgramsBloc()..add(LoadPrograms())),
        ],
        child: const MainScreen(),
      ),
    );
  }
}

// ========== MODELS ==========
class FoodInfo {
  final String name;
  final int calories;
  final double proteins;
  final int carbs;
  final double fats;

  FoodInfo({
    required this.name,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });
}

class UserProfile {
  final String name;
  final String memberSince;
  final int caloriesConsumed;
  final String exerciseTime;
  final String waterIntake;
  final double weightLossProgress;
  final double muscleMassProgress;

  UserProfile({
    required this.name,
    required this.memberSince,
    required this.caloriesConsumed,
    required this.exerciseTime,
    required this.waterIntake,
    required this.weightLossProgress,
    required this.muscleMassProgress,
  });
}

class NutritionProgram {
  final String title;
  final String subtitle;
  final double progress;
  final String nextMeal;
  final bool isActive;

  NutritionProgram({
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.nextMeal,
    required this.isActive,
  });
}

// ========== SCAN BLOC ==========
abstract class ScanEvent {}

class ScanFood extends ScanEvent {}

class ResetScan extends ScanEvent {}

abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {
  final FoodInfo food;
  ScanSuccess(this.food);
}

class ScanError extends ScanState {
  final String message;
  ScanError(this.message);
}

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanInitial()) {
    on<ScanFood>(_onScanFood);
    on<ResetScan>(_onResetScan);
  }

  Future<void> _onScanFood(ScanFood event, Emitter<ScanState> emit) async {
    emit(ScanLoading());

    try {
      // Simulation appel API: POST http://monserver.com/scan avec image
      await Future.delayed(const Duration(seconds: 2));

      final food = FoodInfo(
        name: 'Pomme Golden',
        calories: 95,
        proteins: 0.5,
        carbs: 25,
        fats: 0.3,
      );

      emit(ScanSuccess(food));
    } catch (e) {
      emit(ScanError('Erreur lors du scan'));
    }
  }

  void _onResetScan(ResetScan event, Emitter<ScanState> emit) {
    emit(ScanInitial());
  }
}

// ========== PROFILE BLOC ==========
abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class RefreshProfile extends ProfileEvent {}

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<RefreshProfile>(_onRefreshProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());

    try {
      // Simulation appel API: GET http://monserver.com/profile
      await Future.delayed(const Duration(milliseconds: 500));

      final profile = UserProfile(
        name: 'Thomas Martin',
        memberSince: 'janvier 2025',
        caloriesConsumed: 1850,
        exerciseTime: '45m',
        waterIntake: '2.1L',
        weightLossProgress: 0.75,
        muscleMassProgress: 0.60,
      );

      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Erreur de chargement du profil'));
    }
  }

  Future<void> _onRefreshProfile(
      RefreshProfile event, Emitter<ProfileState> emit) async {
    await _onLoadProfile(LoadProfile(), emit);
  }
}

// ========== PROGRAMS BLOC ==========
abstract class ProgramsEvent {}

class LoadPrograms extends ProgramsEvent {}

class AddProgram extends ProgramsEvent {}

abstract class ProgramsState {}

class ProgramsInitial extends ProgramsState {}

class ProgramsLoading extends ProgramsState {}

class ProgramsLoaded extends ProgramsState {
  final List<NutritionProgram> programs;
  ProgramsLoaded(this.programs);
}

class ProgramsError extends ProgramsState {
  final String message;
  ProgramsError(this.message);
}

class ProgramsBloc extends Bloc<ProgramsEvent, ProgramsState> {
  ProgramsBloc() : super(ProgramsInitial()) {
    on<LoadPrograms>(_onLoadPrograms);
    on<AddProgram>(_onAddProgram);
  }

  Future<void> _onLoadPrograms(
      LoadPrograms event, Emitter<ProgramsState> emit) async {
    emit(ProgramsLoading());

    try {
      // Simulation appel API: GET http://monserver.com/programs
      await Future.delayed(const Duration(milliseconds: 500));

      final programs = [
        NutritionProgram(
          title: 'Programme Nutrition',
          subtitle: 'Semaine 3/12',
          progress: 0.25,
          nextMeal: 'Déjeuner à 12h30',
          isActive: true,
        ),
        NutritionProgram(
          title: 'Programme Sport',
          subtitle: 'Semaine 2/8',
          progress: 0.25,
          nextMeal: 'Cardio - 18h00',
          isActive: true,
        ),
      ];

      emit(ProgramsLoaded(programs));
    } catch (e) {
      emit(ProgramsError('Erreur de chargement des programmes'));
    }
  }

  Future<void> _onAddProgram(
      AddProgram event, Emitter<ProgramsState> emit) async {
    // Logique pour ajouter un nouveau programme
    add(LoadPrograms());
  }
}

// ========== CONFIGURATION SECTIONS ==========
class AppSection {
  final String id;
  final IconData icon;
  final String label;

  const AppSection({
    required this.id,
    required this.icon,
    required this.label,
  });
}

// ========== MAIN SCREEN ==========
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<AppSection> _sections = const [
    AppSection(id: 'scan', icon: Icons.camera_alt, label: 'Scanner'),
    AppSection(id: 'profile', icon: Icons.person, label: 'Profil'),
    AppSection(id: 'programs', icon: Icons.calendar_today, label: 'Programmes'),
  ];

  final List<Widget> _screens = const [
    ScanScreen(),
    ProfileScreen(),
    ProgramsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index < _sections.length) {
              setState(() => _currentIndex = index);
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green.shade600,
          unselectedItemColor: Colors.grey.shade500,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            ..._sections.map((section) => BottomNavigationBarItem(
                  icon: Icon(section.icon),
                  label: section.label,
                )),
            BottomNavigationBarItem(
              icon: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.add, size: 16, color: Colors.grey.shade300),
              ),
              label: 'Bientôt',
            ),
          ],
        ),
      ),
    );
  }
}

// ========== SCAN SCREEN ==========
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
            // Header
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

            // Content
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
                            // Zone de scan
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

                            // Bouton scan
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
          Icon(
            Icons.camera_alt,
            size: 80,
            color: Colors.green.shade600,
          ),
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
                _buildNutrientCard('Calories', '${state.food.calories}'),
                _buildNutrientCard('Protéines', '${state.food.proteins}g'),
                _buildNutrientCard('Glucides', '${state.food.carbs}g'),
                _buildNutrientCard('Lipides', '${state.food.fats}g'),
              ],
            ),
          ],
        ),
      );
    }

    return Icon(
      Icons.camera_alt,
      size: 80,
      color: Colors.green.shade600,
    );
  }

  Widget _buildNutrientCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

// ========== PROFILE SCREEN ==========
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
            // Header
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
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
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Content
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
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.green.shade600,
                        ),
                      );
                    }

                    if (state is ProfileError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<ProfileBloc>()
                                    .add(RefreshProfile());
                              },
                              child: const Text('Réessayer'),
                            ),
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
                              // Avatar
                              Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade500,
                                      Colors.green.shade600
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 48,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                state.profile.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Membre depuis ${state.profile.memberSince}',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Statistiques
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Statistiques du jour',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildStat(
                                            '${state.profile.caloriesConsumed}',
                                            'Calories'),
                                        _buildStat(state.profile.exerciseTime,
                                            'Exercice'),
                                        _buildStat(
                                            state.profile.waterIntake, 'Eau'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Objectifs
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Objectifs',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildProgressBar('Perte de poids',
                                        state.profile.weightLossProgress),
                                    const SizedBox(height: 16),
                                    _buildProgressBar('Masse musculaire',
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

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade600,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(String label, double progress) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

// ========== PROGRAMS SCREEN ==========
class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

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
            // Header
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
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
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: BlocBuilder<ProgramsBloc, ProgramsState>(
                  builder: (context, state) {
                    if (state is ProgramsLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.green.shade600,
                        ),
                      );
                    }

                    if (state is ProgramsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context
                                    .read<ProgramsBloc>()
                                    .add(LoadPrograms());
                              },
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is ProgramsLoaded) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mes Programmes',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Liste des programmes
                            ...state.programs.asMap().entries.map((entry) {
                              final index = entry.key;
                              final program = entry.value;
                              final isFirst = index == 0;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildProgramCard(program, isFirst),
                              );
                            }),

                            // Bouton ajouter
                            GestureDetector(
                              onTap: () {
                                context.read<ProgramsBloc>().add(AddProgram());
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add,
                                      color: Colors.grey.shade600,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Ajouter un programme',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            Center(
                              child: Text(
                                'API: http://monserver.com/programs',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ],
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

  Widget _buildProgramCard(NutritionProgram program, bool isGradient) {
    if (isGradient) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade500, Colors.green.shade600],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      program.subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Actif',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: program.progress,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Prochain repas : ${program.nextMeal}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    program.subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Actif',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: program.progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.green.shade600,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Prochaine séance : ${program.nextMeal}',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
