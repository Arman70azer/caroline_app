/// Modèle pour les objectifs
class Goal {
  final double? weightLoss;
  final double? muscleGain;

  Goal({
    this.weightLoss,
    this.muscleGain,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      weightLoss: json['weight_loss'] != null
          ? (json['weight_loss'] as num).toDouble()
          : null,
      muscleGain: json['muscle_gain'] != null
          ? (json['muscle_gain'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weight_loss': weightLoss,
      'muscle_gain': muscleGain,
    };
  }
}
