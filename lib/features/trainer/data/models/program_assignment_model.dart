import 'exercise_model.dart';

class ProgramAssignmentModel {
  final String id;
  final String programId;
  final String clientId;
  final String? clientName;
  final String? programName;
  final List<ExerciseModel>? exercises;
  final DateTime startDate;
  final int durationWeeks;
  final bool active;
  final int? completedDays;

  ProgramAssignmentModel({
    required this.id,
    required this.programId,
    required this.clientId,
    this.clientName,
    this.programName,
    this.exercises,
    required this.startDate,
    this.durationWeeks = 12,
    this.active = true,
    this.completedDays,
  });

  int get currentDay => completedDays ?? (DateTime.now().difference(startDate).inDays + 1);
  int get totalDays => durationWeeks * 7;
  double get progressPercentage => totalDays == 0 ? 0 : (currentDay / totalDays).clamp(0.0, 1.0);

  factory ProgramAssignmentModel.fromJson(Map<String, dynamic> json) {
    return ProgramAssignmentModel(
      id: json['id']?.toString() ?? '',
      programId: json['program_id']?.toString() ?? '',
      clientId: json['client_id']?.toString() ?? '',
      clientName: json['client_name']?.toString() ?? 'Client',
      programName: json['program_name']?.toString() ?? 'Workout',
      exercises: (json['exercises'] as List?)
          ?.map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDate: DateTime.tryParse(json['start_date']?.toString() ?? '') ?? DateTime.now(),
      durationWeeks: int.tryParse(json['duration_weeks']?.toString() ?? '12') ?? 12,
      active: json['active'] == true,
      completedDays: int.tryParse(json['completed_days']?.toString() ?? ''),
    );
  }

  String get clientInitials {
    if (clientName == null || clientName!.isEmpty) return '??';
    final parts = clientName!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }
}

