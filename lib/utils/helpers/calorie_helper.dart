class CalorieHelper {
  /// MET (Metabolic Equivalent of Task) values for various activities
  static const double metResistanceTraining = 5.0; // Moderate resistance training
  static const double metHighIntensity = 8.0;    // High intensity / Circuit training
  static const double metYoga = 2.5;             // Light yoga/stretching

  /// Calculates estimated calories burned
  /// Formula: Calories = (MET * 3.5 * weight_kg / 200) * duration_minutes
  static int calculate({
    required double weightKg,
    required int durationMinutes,
    double metValue = metResistanceTraining,
  }) {
    if (weightKg <= 0 || durationMinutes <= 0) return 0;
    
    final calories = (metValue * 3.5 * weightKg / 200) * durationMinutes;
    return calories.round();
  }

  /// Estimates duration based on number of exercises
  /// Assumption: ~10 minutes per exercise including sets, reps, and rest
  static int estimateDuration(int exerciseCount) {
    return exerciseCount * 10;
  }
}
