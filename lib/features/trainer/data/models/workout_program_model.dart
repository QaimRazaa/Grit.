import 'exercise_model.dart';

class WorkoutProgramModel {
  final String? id;
  final String name;
  final String? description;
  final String level;
  final List<ExerciseModel> exercises;
  final Map<String, String> dayLabels;
  final DateTime? createdAt;
  final String? createdBy;

  WorkoutProgramModel({
    this.id,
    required this.name,
    this.description,
    this.level = 'Beginner',
    required this.exercises,
    this.dayLabels = const {},
    this.createdAt,
    this.createdBy,
  });

  factory WorkoutProgramModel.fromJson(Map<String, dynamic> json) {
    return WorkoutProgramModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      level: json['level'] as String? ?? 'Beginner',
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      dayLabels: Map<String, String>.from(json['day_labels'] as Map? ?? {}),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
      createdBy: json['created_by'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'level': level,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'day_labels': dayLabels,
      if (createdBy != null) 'created_by': createdBy,
    };
  }

  WorkoutProgramModel copyWith({
    String? id,
    String? name,
    String? description,
    String? level,
    List<ExerciseModel>? exercises,
    Map<String, String>? dayLabels,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return WorkoutProgramModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      exercises: exercises ?? this.exercises,
      dayLabels: dayLabels ?? this.dayLabels,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
