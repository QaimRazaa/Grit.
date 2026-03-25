class StreakModel {
  final String userId;
  final int currentStreak;
  final DateTime? lastLoggedDate;
  final int longestStreak;

  StreakModel({
    required this.userId,
    this.currentStreak = 0,
    this.lastLoggedDate,
    this.longestStreak = 0,
  });

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      userId: json['client_id']?.toString() ?? '',
      currentStreak: int.tryParse(json['current_streak']?.toString() ?? '0') ?? 0,
      lastLoggedDate: json['last_logged_date'] != null 
          ? DateTime.tryParse(json['last_logged_date']?.toString() ?? '') 
          : null,
      longestStreak: int.tryParse(json['longest_streak']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': userId,
      'current_streak': currentStreak,
      'last_logged_date': lastLoggedDate?.toIso8601String().split('T')[0],
      'longest_streak': longestStreak,
    };
  }

  int get daysSinceLastLog {
    if (lastLoggedDate == null) return 0;
    return DateTime.now().difference(lastLoggedDate!).inDays;
  }

  bool get isSkipping => lastLoggedDate != null && daysSinceLastLog >= 2;
}
