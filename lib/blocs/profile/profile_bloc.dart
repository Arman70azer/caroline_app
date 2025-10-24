import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../../models/user_profile.dart';
import 'dart:async';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<RefreshProfile>(_onRefreshProfile);
  }

  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
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
  }

  Future<void> _onRefreshProfile(
      RefreshProfile event, Emitter<ProfileState> emit) async {
    await _onLoadProfile(LoadProfile(), emit);
  }
}
