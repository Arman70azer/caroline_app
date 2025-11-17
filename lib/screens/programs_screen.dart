import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/programs/programs_bloc.dart';
import '../blocs/programs/programs_event.dart';
import '../blocs/programs/programs_state.dart';
import '../widgets/program_card.dart';

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
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: BlocBuilder<ProgramsBloc, ProgramsState>(
                  builder: (context, state) {
                    if (state is ProgramsLoading) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: Colors.green.shade600));
                    }
                    if (state is ProgramsError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message,
                                style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                                onPressed: () => context
                                    .read<ProgramsBloc>()
                                    .add(LoadPrograms()),
                                child: const Text('Réessayer')),
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
                            const Text('Mes Programmes',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 24),
                            ...state.programs.asMap().entries.map((entry) {
                              final index = entry.key;
                              final program = entry.value;
                              final isFirst = index == 0;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ProgramCard(
                                    program: program, isGradient: isFirst),
                              );
                            }),
                            GestureDetector(
                              onTap: () => context
                                  .read<ProgramsBloc>()
                                  .add(AddProgram()),
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
                                    Icon(Icons.add,
                                        color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    Text('Ajouter un programme',
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: Text('API: http://monserver.com/programs',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade400)),
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
}
