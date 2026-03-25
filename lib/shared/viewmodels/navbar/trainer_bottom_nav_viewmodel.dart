import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to manage the selected index of the Trainer Bottom Navigation Bar.
final trainerBottomNavIndexProvider = StateProvider<int>((ref) => 0);
