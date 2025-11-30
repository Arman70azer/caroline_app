import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/programs/programs_bloc.dart';
import '../../blocs/programs/programs_event.dart';
import '../../blocs/programs/programs_state.dart';
import '../../config/colors.dart';
import 'screen_states/index.dart';

class ProgramsScreen extends StatelessWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: BlocBuilder<ProgramsBloc, ProgramsState>(
          builder: (context, state) {
            if (state is ProgramsLoading) return const ProgramsLoadingWidget();
            if (state is ProgramsError) {
              return ProgramsErrorWidget(state: state);
            }
            if (state is ProgramsLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<ProgramsBloc>()
                      .add(LoadPrograms(forceRefresh: true));
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                color: AppColors.primaryGreen,
                backgroundColor: AppColors.surface,
                child: state.programs.isEmpty
                    ? const ProgramsEmptyWidget()
                    : ProgramsListWidget(programs: state.programs),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
