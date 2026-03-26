import 'streak_model.dart';

class ClientProfileModel {
  final String id;
  final String fullName;
  final String? primaryGoal;
  final String? experienceLevel;
  final int? daysPerWeek;
  final StreakModel? streak;
  final List<bool>? last7Days;
  final String? injuries;

  ClientProfileModel({
    required this.id,
    required this.fullName,
    this.primaryGoal,
    this.experienceLevel,
    this.daysPerWeek,
    this.streak,
    this.last7Days,
    this.injuries,
  });


  String get initials {
    if (fullName.isEmpty) return '';
    final parts = fullName.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }

  factory ClientProfileModel.fromJson(Map<String, dynamic> json) {
    return ClientProfileModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? 'Guest',
      primaryGoal: json['primary_goal']?.toString(),
      experienceLevel: json['experience_level']?.toString(),
      daysPerWeek: int.tryParse(json['days_per_week']?.toString() ?? ''),
      streak: json['streak'] != null && json['streak'] is Map<String, dynamic>
          ? StreakModel.fromJson(json['streak'] as Map<String, dynamic>)
          : null,
      last7Days: json['last_7_days'] != null && json['last_7_days'] is List
          ? List<bool>.from(json['last_7_days'] as List)
          : null,
      injuries: json['injuries']?.toString(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'primary_goal': primaryGoal,
      'experience_level': experienceLevel,
      'days_per_week': daysPerWeek,
      'streak': streak?.toJson(),
      'last_7_days': last7Days,
      'injuries': injuries,
    };
  }
}

