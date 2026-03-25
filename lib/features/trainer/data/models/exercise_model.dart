class ExerciseModel {
  final String name;
  final int sets;
  final int reps;
  final int day;
  final int? restSeconds;

  ExerciseModel({
    required this.name,
    required this.sets,
    required this.reps,
    this.day = 1,
    this.restSeconds,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      name: json['name'] as String? ?? 'Unknown Exercise',
      sets: json['sets'] as int? ?? 4,
      reps: json['reps'] as int? ?? 10,
      day: json['day'] as int? ?? 1,
      restSeconds: json['restSeconds'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'day': day,
      if (restSeconds != null) 'restSeconds': restSeconds,
    };
  }

  ExerciseModel copyWith({
    String? name,
    int? sets,
    int? reps,
    int? day,
    int? restSeconds,
  }) {
    return ExerciseModel(
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      day: day ?? this.day,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }
}
