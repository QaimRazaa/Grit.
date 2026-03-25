import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get trainerUserId => dotenv.env['TRAINER_USER_ID'] ?? '';
}
