abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class RefreshProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String surname;
  final double? weight;
  final double? height;
  final int? age;
  final String? gender;
  final String? password;

  UpdateProfile({
    required this.name,
    required this.surname,
    this.weight,
    this.height,
    this.age,
    this.gender,
    this.password,
  });
}

class UpdateGoals extends ProfileEvent {
  final double? weightLoss;
  final double? muscleGain;

  UpdateGoals({
    this.weightLoss,
    this.muscleGain,
  });
}
