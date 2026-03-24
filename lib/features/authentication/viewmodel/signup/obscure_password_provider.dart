import 'package:flutter_riverpod/flutter_riverpod.dart';

final obscurePasswordProvider =
    StateProvider.family<bool, String>((ref, screenId) => true);
