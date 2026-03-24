class AppException implements Exception {
  final String message;

  const AppException(this.message);

  factory AppException.emptyName() =>
      const AppException('Please enter your name.');
  factory AppException.invalidEmail() =>
      const AppException('Enter a valid email address.');
  factory AppException.emailTaken() =>
      const AppException('This email is already in use. Log in instead.');
  factory AppException.passwordTooShort() =>
      const AppException('Password must be at least 8 characters.');
  factory AppException.networkFailure() => const AppException(
    'Something went wrong. Check your connection and try again.',
  );
  factory AppException.emptyPassword() =>
      const AppException('Please enter your password.');

  @override
  String toString() => message;
}
