class ProgramAssignmentModel {
  final String id;
  final String programId;
  final String clientId;
  final String? clientName;
  final String? programName;
  final List<String>? exerciseNames;
  final DateTime startDate;
  final int durationWeeks;
  final bool active;

  ProgramAssignmentModel({
    required this.id,
    required this.programId,
    required this.clientId,
    this.clientName,
    this.programName,
    this.exerciseNames,
    required this.startDate,
    this.durationWeeks = 12,
    this.active = true,
  });

  int get currentDay => DateTime.now().difference(startDate).inDays + 1;
  int get totalDays => durationWeeks * 7;
  double get progressPercentage => totalDays == 0 ? 0 : (currentDay / totalDays).clamp(0.0, 1.0);

  factory ProgramAssignmentModel.fromJson(Map<String, dynamic> json) {
    return ProgramAssignmentModel(
      id: json['id']?.toString() ?? '',
      programId: json['program_id']?.toString() ?? '',
      clientId: json['client_id']?.toString() ?? '',
      clientName: json['client_name']?.toString() ?? 'Client',
      programName: json['program_name']?.toString() ?? 'Workout',
      exerciseNames: (json['exercises'] as List?)?.map((e) => e['name']?.toString() ?? '').toList(),
      startDate: DateTime.tryParse(json['start_date']?.toString() ?? '') ?? DateTime.now(),
      durationWeeks: int.tryParse(json['duration_weeks']?.toString() ?? '12') ?? 12,
      active: json['active'] == true,
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

