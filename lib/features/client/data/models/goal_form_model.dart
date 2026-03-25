class GoalFormModel {
  final String userId;
  final String? primaryGoal;
  final String? weight;
  final String? height;
  final String? age;
  final String? gender;
  final String? experienceLevel;
  final String? daysPerWeek;
  final String? gymAccess;
  final String? trainingTime;
  final String? injuries;
  final String? source;

  GoalFormModel({
    required this.userId,
    this.primaryGoal,
    this.weight,
    this.height,
    this.age,
    this.gender,
    this.experienceLevel,
    this.daysPerWeek,
    this.gymAccess,
    this.trainingTime,
    this.injuries,
    this.source,
  });

  factory GoalFormModel.fromJson(Map<String, dynamic> json) {
    return GoalFormModel(
      userId: json['user_id']?.toString() ?? '',
      primaryGoal: json['primary_goal']?.toString(),
      weight: json['weight']?.toString(),
      height: json['height']?.toString(),
      age: json['age']?.toString(),
      gender: json['gender']?.toString(),
      experienceLevel: json['experience_level']?.toString(),
      daysPerWeek: json['days_per_week']?.toString(),
      gymAccess: json['gym_access']?.toString(),
      trainingTime: json['training_time']?.toString(),
      injuries: json['injuries']?.toString(),
      source: json['source']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'primary_goal': primaryGoal,
      'weight': weight,
      'height': height,
      'age': age,
      'gender': gender,
      'experience_level': experienceLevel,
      'days_per_week': daysPerWeek,
      'gym_access': gymAccess,
      'training_time': trainingTime,
      'injuries': injuries,
      'source': source,
    };
  }
}
