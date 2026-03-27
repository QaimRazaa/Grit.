import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/features/authentication/data/repository/auth_repository.dart';
import 'package:grit/features/client/data/repository/client_repository.dart';
import 'package:grit/features/trainer/data/models/workout_program_model.dart';
import 'package:grit/features/trainer/data/models/streak_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:grit/utils/helpers/calorie_helper.dart';
import 'package:grit/utils/helpers/body_metrics_helper.dart';

class HomeState {
  final Map<String, dynamic>? activeAssignment;
  final WorkoutProgramModel? activeProgram;
  final StreakModel? streak;
  final List<String> last7DaysActivity;
  final Set<String> todaysLoggedExercises;
  final int todaysCalories;
  final int weeklyCalories;
  final int weeklyWorkouts;
  final int weeklyGoal;
  final String weeklyTime;
  final Map<String, int> weeklyExerciseCounts;
  final List<bool> last7DaysLogStatus;
  final String userName;
  final String userInitials;
  final String weight;
  final String bodyFat;
  final double strengthTrend;
  final int currentDayNumber;
  final String todayWorkoutName;
  final List<String> todaysMuscleGroups;
  final bool isRestDay;
  final bool isWorkoutDoneToday;
  final int missedDays;
  final bool isLoading;
  final String? error;

  HomeState({
    this.activeAssignment,
    this.activeProgram,
    this.streak,
    this.last7DaysActivity = const [],
    this.todaysLoggedExercises = const {},
    this.todaysCalories = 0,
    this.weeklyCalories = 0,
    this.weeklyWorkouts = 0,
    this.weeklyGoal = 4,
    this.weeklyTime = '0H 0M',
    this.weeklyExerciseCounts = const {},
    this.last7DaysLogStatus = const [false, false, false, false, false, false, false],
    this.userName = 'Guest',
    this.userInitials = 'G',
    this.weight = '--',
    this.bodyFat = '--',
    this.strengthTrend = 0.0,
    this.currentDayNumber = 1,
    this.todayWorkoutName = 'Workout',
    this.todaysMuscleGroups = const [],
    this.isRestDay = false,
    this.isWorkoutDoneToday = false,
    this.missedDays = 0,
    this.isLoading = false,
    this.error,
  });

  static const _unset = Object();

  HomeState copyWith({
    Object? activeAssignment = _unset,
    Object? activeProgram = _unset,
    Object? streak = _unset,
    List<String>? last7DaysActivity,
    Set<String>? todaysLoggedExercises,
    int? todaysCalories,
    int? weeklyCalories,
    int? weeklyWorkouts,
    int? weeklyGoal,
    String? weeklyTime,
    Map<String, int>? weeklyExerciseCounts,
    List<bool>? last7DaysLogStatus,
    String? userName,
    String? userInitials,
    String? weight,
    String? bodyFat,
    double? strengthTrend,
    int? currentDayNumber,
    String? todayWorkoutName,
    List<String>? todaysMuscleGroups,
    bool? isRestDay,
    bool? isWorkoutDoneToday,
    int? missedDays,
    bool? isLoading,
    Object? error = _unset,
  }) {
    return HomeState(
      activeAssignment: activeAssignment == _unset ? this.activeAssignment : activeAssignment as Map<String, dynamic>?,
      activeProgram: activeProgram == _unset ? this.activeProgram : activeProgram as WorkoutProgramModel?,
      streak: streak == _unset ? this.streak : streak as StreakModel?,
      last7DaysActivity: last7DaysActivity ?? this.last7DaysActivity,
      todaysLoggedExercises: todaysLoggedExercises ?? this.todaysLoggedExercises,
      todaysCalories: todaysCalories ?? this.todaysCalories,
      weeklyCalories: weeklyCalories ?? this.weeklyCalories,
      weeklyWorkouts: weeklyWorkouts ?? this.weeklyWorkouts,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      weeklyTime: weeklyTime ?? this.weeklyTime,
      weeklyExerciseCounts: weeklyExerciseCounts ?? this.weeklyExerciseCounts,
      last7DaysLogStatus: last7DaysLogStatus ?? this.last7DaysLogStatus,
      userName: userName ?? this.userName,
      userInitials: userInitials ?? this.userInitials,
      weight: weight ?? this.weight,
      bodyFat: bodyFat ?? this.bodyFat,
      strengthTrend: strengthTrend ?? this.strengthTrend,
      currentDayNumber: currentDayNumber ?? this.currentDayNumber,
      todayWorkoutName: todayWorkoutName ?? this.todayWorkoutName,
      todaysMuscleGroups: todaysMuscleGroups ?? this.todaysMuscleGroups,
      isRestDay: isRestDay ?? this.isRestDay,
      isWorkoutDoneToday: isWorkoutDoneToday ?? this.isWorkoutDoneToday,
      missedDays: missedDays ?? this.missedDays,
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
    );
  }
}

class HomeViewModel extends StateNotifier<HomeState> {
  final AuthRepository _authRepository;
  final ClientRepository _clientRepository;
  final User? _initialUser;

  HomeViewModel(this._authRepository, this._clientRepository, this._initialUser) : super(HomeState()) {
    if (_initialUser != null) {
      refresh();
    }
  }

  Future<void> refresh() async {
    final now = DateTime.now();
    if (!mounted) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = _initialUser ?? _authRepository.currentUser;
      if (user == null) {
        if (!mounted) return;
        state = state.copyWith(isLoading: false);
        return;
      }
      
      final results = await Future.wait([
        _authRepository.getUserProfile(user.id),
        _clientRepository.fetchActiveAssignment(),
        _clientRepository.fetchStreak(),
        _clientRepository.fetchLast7DaysActivity(),
        _clientRepository.fetchTodaysLoggedExercises(),
        _clientRepository.fetchGoalForm(),
        _clientRepository.fetchWeeklyLogs(),
        _clientRepository.fetchPreviousWeeklyLogs(),
      ]);

      final profile        = results[0] as Map<String, dynamic>?;
      final assignment     = results[1] as Map<String, dynamic>?;
      final streak         = results[2] as StreakModel?;
      final activity       = results[3] as List<String>;
      final todaysLogs     = results[4] as Set<String>;
      final goalForm       = results[5] as Map<String, dynamic>?;
      final weeklyLogs     = results[6] as List<Map<String, dynamic>>;
      final prevWeeklyLogs = results[7] as List<Map<String, dynamic>>;

      WorkoutProgramModel? program;
      int currentDayNumber = 1;
      bool isWorkoutDoneToday = false;
      int missedDays = 0;
      String? workoutDayName;

      if (assignment != null) {
        final assignmentId = assignment['id']?.toString();
        if (assignmentId != null) {
          final completedDays = await _clientRepository.fetchCompletedWorkoutDays(assignmentId);
          currentDayNumber = completedDays + 1;

          final lastLoggedDate = await _clientRepository.fetchLastLoggedDate(assignmentId);
          final today = DateTime.now().toIso8601String().split('T')[0];
          
          isWorkoutDoneToday = lastLoggedDate == today;
          
          if (lastLoggedDate != null && lastLoggedDate != today) {
            final lastDate = DateTime.parse(lastLoggedDate);
            final diff = DateTime.now().difference(DateTime(lastDate.year, lastDate.month, lastDate.day)).inDays;
            missedDays = (diff - 1).clamp(0, 99);
          }
        }

        final totalDays = (assignment['duration_weeks'] as int? ?? 12) * 7;
        if (currentDayNumber > totalDays) {
          // Program is complete, treat as no program
          if (mounted) {
            state = state.copyWith(isLoading: false, activeProgram: null);
          }
          return;
        }

        if (assignment['workout_programs'] != null) {
          final rawProgram = WorkoutProgramModel.fromJson(assignment['workout_programs']);
          
          // Filter exercises for current week and day
          final int daysPerWeek = (assignment['days_per_week'] as int?) ?? 
              rawProgram.exercises.fold<int>(0, (m, e) => e.day > m ? e.day : m);

          final currentWeek = ((currentDayNumber - 1) / daysPerWeek.clamp(1, 7)).floor() + 1;
          final currentDay = ((currentDayNumber - 1) % daysPerWeek.clamp(1, 7)) + 1;

          final filteredExercises = rawProgram.exercises
              .where((e) => e.week == currentWeek && e.day == currentDay)
              .toList();
          
          final dayLabel = rawProgram.dayLabels["day_$currentDay"];
          workoutDayName = (dayLabel != null && dayLabel.isNotEmpty) ? dayLabel : rawProgram.name;
          
          program = rawProgram.copyWith(exercises: filteredExercises);
        }
      }

      final isRestDay = program != null && program.exercises.isEmpty;

      // Parse user weight using safe helper
      final weightVal = goalForm?['weight']?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '70';
      final weightNum = double.tryParse(weightVal) ?? 70.0;

      // 1. Calculate Today's Calories
      int calories = 0;
      if (todaysLogs.isNotEmpty) {
        final duration = CalorieHelper.estimateDuration(todaysLogs.length);
        calories = CalorieHelper.calculate(weightKg: weightNum, durationMinutes: duration);
      }

      // 2. Calculate Weekly Stats
      int totalWeeklyCalories = 0;
      final uniqueDays = <String>{};
      final weeklyCounts = <String, int>{};
      
      // Group weekly logs by date to count unique exercises per day
      final logsByDate = <String, Set<String>>{};
      for (final log in weeklyLogs) {
        final date = log['date']?.toString() ?? '';
        final exerciseName = log['exercise_name']?.toString() ?? '';
        if (date.isEmpty) continue;

        uniqueDays.add(date);
        logsByDate.putIfAbsent(date, () => {}).add(exerciseName);
      }

      // Sum calories and time for each day
      int totalMinutes = 0;
      logsByDate.forEach((date, exercises) {
        final dayDuration = CalorieHelper.estimateDuration(exercises.length);
        totalMinutes += dayDuration;
        totalWeeklyCalories += CalorieHelper.calculate(weightKg: weightNum, durationMinutes: dayDuration);
        weeklyCounts[date] = exercises.length;
      });

      final hours = totalMinutes ~/ 60;
      final mins = totalMinutes % 60;
      final timeStr = hours > 0 ? '${hours}H ${mins}M' : '${mins}M';

      // 3. Get Weekly Goal
      final daysPerWeekStr = goalForm?['days_per_week']?.toString() ?? '4';
      final daysPerWeek = int.tryParse(daysPerWeekStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 4;

      // 4. Calculate Current Week's Streak Status (Mon-Sun)
      final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
      final List<bool> weekStatus = [];
      for (int i = 0; i < 7; i++) {
        final day = monday.add(Duration(days: i));
        final dayStr = day.toIso8601String().split('T')[0];
        weekStatus.add(uniqueDays.contains(dayStr));
      }

      // 5. User Profile
      String userName = 'Guest';
      String userInitials = 'G';
      if (profile != null) {
        final fullName = profile['full_name']?.toString() ?? 'Guest';
        final names = fullName.trim().split(' ');
        userName = names.isNotEmpty ? names[0] : 'Guest';
        userInitials = names.isNotEmpty 
            ? names.map((n) => n.isNotEmpty ? n[0] : '').where((s) => s.isNotEmpty).take(2).join().toUpperCase()
            : 'G';
      }

      // 6. Body Metrics
      final rawWeight = goalForm?['weight']?.toString() ?? '--';
      final weightMetricNum = BodyMetricsHelper.parseMetric(rawWeight, 70.0);
      final heightNum = BodyMetricsHelper.parseMetric(goalForm?['height']?.toString(), 175.0);
      final ageNum = BodyMetricsHelper.parseAge(goalForm?['age']?.toString(), 25);
      final genderStr = goalForm?['gender']?.toString() ?? 'Male';

      final bodyFatVal = BodyMetricsHelper.calculateBodyFat(
        weightKg: weightMetricNum,
        heightCm: heightNum,
        age: ageNum,
        gender: genderStr,
      );

      final weightDisplay = rawWeight != '--' && !rawWeight.contains(RegExp(r'[a-zA-Z]')) 
          ? '$rawWeight kg' 
          : rawWeight;
      
      final bodyFatDisplay = rawWeight == '--' ? '--' : '${bodyFatVal.toStringAsFixed(1)}%';

      // 7. Strength Trend (Volume Comparison)
      double currentVolume = 0;
      for (final log in weeklyLogs) {
        final reps = double.tryParse(log['reps']?.toString() ?? '0') ?? 0;
        final weightLog = double.tryParse(log['weight']?.toString() ?? '0') ?? 0;
        currentVolume += reps * weightLog;
      }
      
      double prevVolume = 0;
      for (final log in prevWeeklyLogs) {
        final reps = double.tryParse(log['reps']?.toString() ?? '0') ?? 0;
        final weightLog = double.tryParse(log['weight']?.toString() ?? '0') ?? 0;
        prevVolume += reps * weightLog;
      }
      
      double trend = 0;
      if (prevVolume > 0) {
        trend = ((currentVolume - prevVolume) / prevVolume) * 100;
      } else if (currentVolume > 0) {
        trend = 100.0;
      }

      state = state.copyWith(
        activeAssignment: assignment,
        activeProgram: program,
        streak: streak,
        last7DaysActivity: activity,
        todaysLoggedExercises: todaysLogs,
        todaysCalories: calories,
        weeklyCalories: totalWeeklyCalories,
        weeklyWorkouts: uniqueDays.length,
        weeklyGoal: daysPerWeek,
        weeklyTime: timeStr,
        weeklyExerciseCounts: weeklyCounts,
        last7DaysLogStatus: weekStatus,
        userName: userName,
        userInitials: userInitials,
        weight: weightDisplay,
        bodyFat: bodyFatDisplay,
        strengthTrend: trend,
        currentDayNumber: currentDayNumber,
        todayWorkoutName: workoutDayName ?? program?.name ?? 'Workout',
        todaysMuscleGroups: (workoutDayName ?? program?.name.toString() ?? '')
          .replaceAll(RegExp(r'[^\w\s]'), ' ') // spaces for punctuation
          .split(' ')
          .where((s) => s.length > 3) // basic filter for labels
          .toList(),
        isRestDay: isRestDay,
        isWorkoutDoneToday: isWorkoutDoneToday,
        missedDays: missedDays,
        isLoading: false,
      );
    } catch (e, stack) {
      if (!mounted) return;
      debugPrint('HOME_VIEWMODEL ERROR: $e');
      debugPrint('STACK: $stack');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    if (!mounted) return;
    state = state.copyWith(isLoading: true);
    try {
      await _authRepository.signOut();
      if (!mounted) return;
      state = state.copyWith(isLoading: false);
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final homeViewModelProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>((ref) {
  final user = ref.watch(currentUserProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final clientRepository = ref.watch(clientRepositoryProvider);
  return HomeViewModel(authRepository, clientRepository, user);
});
