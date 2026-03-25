import 'package:grit/utils/constants/texts.dart';

class AppException implements Exception {
  final String message;

  const AppException(this.message);

  factory AppException.emptyName() =>
      const AppException(AppTexts.errorEmptyName);
  factory AppException.invalidEmail() =>
      const AppException(AppTexts.errorInvalidEmail);
  factory AppException.emailTaken() =>
      const AppException(AppTexts.errorEmailTaken);
  factory AppException.passwordTooShort() =>
      const AppException(AppTexts.errorPasswordTooShort);
  factory AppException.networkFailure() => 
      const AppException(AppTexts.errorNetworkFailure);
  factory AppException.emptyPassword() =>
      const AppException('Please enter your password.');
  factory AppException.accountCreated() =>
      const AppException(AppTexts.successAccountCreated);
  factory AppException.invalidCredentials() =>
      const AppException(AppTexts.errorWrongPassword);
  factory AppException.sessionExpired() =>
      const AppException('Your session has expired. Please sign in again.');

  @override
  String toString() => message;
}
