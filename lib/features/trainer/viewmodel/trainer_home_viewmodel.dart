import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/client_profile_model.dart';
import '../data/models/program_assignment_model.dart';
import '../data/models/streak_model.dart';
import '../data/repository/program_repository.dart';

class TrainerHomeState {
  final int totalClients;
  final int activeToday;
  final String trainerName;
  final List<Map<String, dynamic>> todaysSessions;
  final List<ClientProfileModel> skipAlerts;
  final List<ClientProfileModel> clientRoster;
  final List<ProgramAssignmentModel> activeAssignments;
  final List<Map<String, dynamic>> globalActivity;
  final bool isLoading;
  final String? error;

  TrainerHomeState({
    this.totalClients = 0,
    this.activeToday = 0,
    this.trainerName = '',
    this.todaysSessions = const [],
    this.skipAlerts = const [],
    this.clientRoster = const [],
    this.activeAssignments = const [],
    this.globalActivity = const [],
    this.isLoading = false,
    this.error,
  });

  static const _unset = Object();

  TrainerHomeState copyWith({
    int? totalClients,
    int? activeToday,
    String? trainerName,
    List<Map<String, dynamic>>? todaysSessions,
    List<ClientProfileModel>? skipAlerts,
    List<ClientProfileModel>? clientRoster,
    List<ProgramAssignmentModel>? activeAssignments,
    List<Map<String, dynamic>>? globalActivity,
    bool? isLoading,
    Object? error = _unset,
  }) {
    return TrainerHomeState(
      totalClients: totalClients ?? this.totalClients,
      activeToday: activeToday ?? this.activeToday,
      trainerName: trainerName ?? this.trainerName,
      todaysSessions: todaysSessions ?? this.todaysSessions,
      skipAlerts: skipAlerts ?? this.skipAlerts,
      clientRoster: clientRoster ?? this.clientRoster,
      activeAssignments: activeAssignments ?? this.activeAssignments,
      globalActivity: globalActivity ?? this.globalActivity,
      isLoading: isLoading ?? this.isLoading,
      error: error == _unset ? this.error : error as String?,
    );
  }
}

class TrainerHomeViewModel extends StateNotifier<TrainerHomeState> {
  final ProgramRepository _repository;

  TrainerHomeViewModel(this._repository) : super(TrainerHomeState()) {
    refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final clients = await _repository.loadClients();
      final clientIds = clients.map((c) => c.id).toList();

      if (clientIds.isEmpty) {
        state = state.copyWith(isLoading: false, totalClients: 0);
        return;
      }

      final results = await Future.wait([
        _repository.loadActiveTodayCount(clientIds),
        _repository.loadStreaks(clientIds),
        _repository.loadLast7DaysActivity(clientIds),
        _repository.loadTrainerProfile(),
        _repository.loadTodaysLogsAcrossClients(clientIds),
        _repository.loadAssignments(),
        _repository.loadGlobalActivityFeed(clientIds, limit: 10),
      ]);

      final activeTodayCount = results[0] as int;
      final streaks = results[1] as List<StreakModel>;
      final activityRows = List<Map<String, dynamic>>.from(results[2] as Iterable);
      final trainerProfile = results[3] as Map<String, dynamic>?;
      final todaysSessions = List<Map<String, dynamic>>.from(results[4] as Iterable);
      final activeAssignments = results[5] as List<ProgramAssignmentModel>;
      final globalActivity = List<Map<String, dynamic>>.from(results[6] as Iterable);

      final now = DateTime.now();
      final last7DaysDates = List.generate(7, (i) => 
        DateTime(now.year, now.month, now.day).subtract(Duration(days: 6 - i))
      );

      // Map streaks and activity back to clients
      final roster = clients.map((client) {
        final streak = streaks.firstWhere(
          (s) => s.userId == client.id,
          orElse: () => StreakModel(userId: client.id),
        );

        final clientLogs = activityRows
            .where((row) => row['client_id'] == client.id)
            .map((row) => row['date'] as String)
            .toList();
        
        final last7Days = last7DaysDates.map((date) {
          final dateStr = date.toIso8601String().split('T')[0];
          return clientLogs.contains(dateStr);
        }).toList();

        return ClientProfileModel(
          id: client.id,
          fullName: client.fullName,
          primaryGoal: client.primaryGoal,
          experienceLevel: client.experienceLevel,
          daysPerWeek: client.daysPerWeek,
          streak: streak,
          last7Days: last7Days,
        );
      }).toList();

      final skipAlerts = roster.where((c) => c.streak?.isSkipping ?? false).toList();

      state = state.copyWith(
        totalClients: clients.length,
        activeToday: activeTodayCount,
        trainerName: trainerProfile?['full_name'] ?? 'Trainer',
        todaysSessions: todaysSessions,
        skipAlerts: skipAlerts,
        clientRoster: roster,
        activeAssignments: activeAssignments,
        globalActivity: globalActivity,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

}


final trainerHomeProvider =
    StateNotifierProvider<TrainerHomeViewModel, TrainerHomeState>((ref) {
  final repository = ref.watch(programRepositoryProvider);
  return TrainerHomeViewModel(repository);
});
