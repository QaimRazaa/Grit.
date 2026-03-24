import 'package:grit/utils/constants/texts.dart';

enum PrimaryGoal {
  loseWeight,
  buildMuscle,
  getFit,
  improveStamina,
  bodyRecomposition,
}

extension PrimaryGoalExtension on PrimaryGoal {
  String get title {
    switch (this) {
      case PrimaryGoal.loseWeight:
        return AppTexts.goalLoseWeight;
      case PrimaryGoal.buildMuscle:
        return AppTexts.goalBuildMuscle;
      case PrimaryGoal.getFit:
        return AppTexts.goalGetFit;
      case PrimaryGoal.improveStamina:
        return AppTexts.goalImproveStamina;
      case PrimaryGoal.bodyRecomposition:
        return AppTexts.goalBodyRecomp;
    }
  }

  String get description {
    switch (this) {
      case PrimaryGoal.loseWeight:
        return AppTexts.goalLoseWeightDesc;
      case PrimaryGoal.buildMuscle:
        return AppTexts.goalBuildMuscleDesc;
      case PrimaryGoal.getFit:
        return AppTexts.goalGetFitDesc;
      case PrimaryGoal.improveStamina:
        return AppTexts.goalImproveStaminaDesc;
      case PrimaryGoal.bodyRecomposition:
        return AppTexts.goalBodyRecompDesc;
    }
  }
}

enum Gender {
  male,
  female,
  preferNotToSay,
}

extension GenderExtension on Gender {
  String get label {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.preferNotToSay:
        return 'Prefer not to say';
    }
  }
}

enum ExperienceLevel { beginner, some, intermediate, advanced }

extension ExperienceLevelExtension on ExperienceLevel {
  String get label {
    switch (this) {
      case ExperienceLevel.beginner:
        return 'Beginner';
      case ExperienceLevel.some:
        return 'Some Experience';
      case ExperienceLevel.intermediate:
        return 'Intermediate';
      case ExperienceLevel.advanced:
        return 'Advanced';
    }
  }
}

enum DaysPerWeek { two, three, four, five, six }

extension DaysPerWeekExtension on DaysPerWeek {
  String get label {
    switch (this) {
      case DaysPerWeek.two:
        return '2';
      case DaysPerWeek.three:
        return '3';
      case DaysPerWeek.four:
        return '4';
      case DaysPerWeek.five:
        return '5';
      case DaysPerWeek.six:
        return '6';
    }
  }
}

enum GymAccess { full, home, bodyweight, sometimes }

extension GymAccessExtension on GymAccess {
  String get label {
    switch (this) {
      case GymAccess.full:
        return 'Full Gym';
      case GymAccess.home:
        return 'Home + Equipment';
      case GymAccess.bodyweight:
        return 'Bodyweight Only';
      case GymAccess.sometimes:
        return 'Sometimes Gym';
    }
  }
}

enum TrainingTime { morning, afternoon, evening, night, flexible }

extension TrainingTimeExtension on TrainingTime {
  String get label {
    switch (this) {
      case TrainingTime.morning:
        return 'Morning';
      case TrainingTime.afternoon:
        return 'Afternoon';
      case TrainingTime.evening:
        return 'Evening';
      case TrainingTime.night:
        return 'Night';
      case TrainingTime.flexible:
        return 'Flexible';
    }
  }
}

enum GoalSource { whatsapp, instagram, friend, other }

extension GoalSourceExtension on GoalSource {
  String get label {
    switch (this) {
      case GoalSource.whatsapp:
        return 'WhatsApp';
      case GoalSource.instagram:
        return 'Instagram';
      case GoalSource.friend:
        return 'Friend';
      case GoalSource.other:
        return 'Other';
    }
  }
}
