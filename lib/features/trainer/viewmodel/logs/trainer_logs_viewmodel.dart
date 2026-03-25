import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repository/program_repository.dart';
import 'trainer_logs_state.dart';

class TrainerLogsViewModel extends StateNotifier<TrainerLogsState> {
  final ProgramRepository _repository;

  TrainerLogsViewModel(this._repository) : super(TrainerLogsState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // 1. Get all clients to know whose logs to fetch
      final clients = await _repository.loadClients();
      final clientIds = clients.map((c) => c.id).toList();

      if (clientIds.isEmpty) {
        state = state.copyWith(logs: [], isLoading: false);
        return;
      }

      // 2. Fetch global feed
      final logs = await _repository.loadGlobalActivityFeed(clientIds);
      
      state = state.copyWith(
        logs: logs,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() => load();
}

final trainerLogsProvider =
    StateNotifierProvider<TrainerLogsViewModel, TrainerLogsState>((ref) {
  final repository = ref.watch(programRepositoryProvider);
  return TrainerLogsViewModel(repository);
});
