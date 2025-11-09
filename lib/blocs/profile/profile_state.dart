import '../../models/user_profile.dart';

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

class ProfileUpdating extends ProfileState {
  final UserProfile currentProfile;
  ProfileUpdating(this.currentProfile);
}

class ProfileUpdateSuccess extends ProfileState {
  final UserProfile profile;
  final String message;
  ProfileUpdateSuccess(this.profile, this.message);
}

class ProfileUpdateError extends ProfileState {
  final UserProfile currentProfile;
  final String message;
  ProfileUpdateError(this.currentProfile, this.message);
}

class GoalsUpdating extends ProfileState {
  final UserProfile currentProfile;
  GoalsUpdating(this.currentProfile);
}

class GoalsUpdateSuccess extends ProfileState {
  final UserProfile profile;
  final String message;
  GoalsUpdateSuccess(this.profile, this.message);
}

class GoalsUpdateError extends ProfileState {
  final UserProfile currentProfile;
  final String message;
  GoalsUpdateError(this.currentProfile, this.message);
}
