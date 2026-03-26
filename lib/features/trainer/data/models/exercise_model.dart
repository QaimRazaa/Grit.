class ExerciseModel {
  final String name;
  final int sets;
  final int reps;
  final int day;
  final int week;
  final bool toFailure;
  final int? restSeconds;

  ExerciseModel({
    required this.name,
    required this.sets,
    required this.reps,
    this.day = 1,
    this.week = 1,
    this.toFailure = false,
    this.restSeconds,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      name: json['name'] as String? ?? 'Unknown Exercise',
      sets: json['sets'] as int? ?? 4,
      reps: json['reps'] as int? ?? 10,
      day: json['day'] as int? ?? 1,
      week: json['week'] as int? ?? 1,
      toFailure: json['toFailure'] as bool? ?? false,
      restSeconds: json['restSeconds'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sets': sets,
      'reps': reps,
      'day': day,
      'week': week,
      'toFailure': toFailure,
      if (restSeconds != null) 'restSeconds': restSeconds,
    };
  }

  ExerciseModel copyWith({
    String? name,
    int? sets,
    int? reps,
    int? day,
    int? week,
    bool? toFailure,
    int? restSeconds,
  }) {
    return ExerciseModel(
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      day: day ?? this.day,
      week: week ?? this.week,
      toFailure: toFailure ?? this.toFailure,
      restSeconds: restSeconds ?? this.restSeconds,
    );
  }
}
