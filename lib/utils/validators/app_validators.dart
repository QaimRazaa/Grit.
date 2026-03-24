import 'package:grit/utils/exceptions/app_exceptions.dart';
import 'package:grit/utils/formatters/app_formatters.dart';

class AppValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppException.emptyName().message;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppException.invalidEmail().message;
    }
    if (!AppFormatters.isValidEmail(value)) {
      return AppException.invalidEmail().message;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return AppException.passwordTooShort().message;
    }
    return null;
  }
  static String? validatePasswordSignin(String? value) {
    if (value == null || value.isEmpty) {
      return AppException.emptyPassword().message;
    }
    return null;
  }

  AppValidators._();
}
