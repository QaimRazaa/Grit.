class BodyMetricsHelper {
  /// Calculates Body Fat Percentage using the BMI-based formula:
  /// Body Fat % = (1.20 × BMI) + (0.23 × Age) − (10.8 × Gender) − 5.4
  /// Gender: 1 for male, 0 for female.
  static double calculateBodyFat({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
  }) {
    if (heightCm <= 0) return 0.0;

    // 1. Calculate BMI
    final double heightMeters = heightCm / 100;
    final double bmi = weightKg / (heightMeters * heightMeters);

    // 2. Determine gender factor
    final isMale = gender.toLowerCase() == 'male' || gender.toLowerCase().startsWith('m');
    final double genderFactor = isMale ? 1.0 : 0.0;

    // 3. Calculate Body Fat %
    final double bodyFat = (1.20 * bmi) + (0.23 * age) - (10.8 * genderFactor) - 5.4;

    return bodyFat.clamp(2.0, 60.0); // Keep within realistic bounds
  }

  /// Parses strings like "70 kg" or "180 cm" to doubles
  static double parseMetric(String? value, double defaultValue) {
    if (value == null || value.isEmpty || value == '--') return defaultValue;
    final clean = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? defaultValue;
  }
  
  /// Parses age to int
  static int parseAge(String? value, int defaultValue) {
    if (value == null || value.isEmpty || value == '--') return defaultValue;
    final clean = value.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(clean) ?? defaultValue;
  }
}
