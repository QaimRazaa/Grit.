class AppFormatters {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  AppFormatters._();
}
