class TrainerLogsState {
  final List<Map<String, dynamic>> logs;
  final bool isLoading;
  final String? error;

  TrainerLogsState({
    this.logs = const [],
    this.isLoading = false,
    this.error,
  });

  TrainerLogsState copyWith({
    List<Map<String, dynamic>>? logs,
    bool? isLoading,
    String? error,
  }) {
    return TrainerLogsState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
