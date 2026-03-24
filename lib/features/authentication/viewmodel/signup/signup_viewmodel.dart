import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/utils/exceptions/app_exceptions.dart';
import 'package:grit/utils/validators/app_validators.dart';

class SignupState {
  final String name;
  final String email;
  final String password;
  final String? nameError;
  final String? emailError;
  final String? passwordError;
  final String? globalError;
  final bool isLoading;

  SignupState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.nameError,
    this.emailError,
    this.passwordError,
    this.globalError,
    this.isLoading = false,
  });

  bool get isButtonActive =>
      name.trim().isNotEmpty &&
      AppValidators.validateEmail(email) == null &&
      AppValidators.validatePassword(password) == null;

  static const _unset = Object();

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    Object? nameError = _unset,
    Object? emailError = _unset,
    Object? passwordError = _unset,
    Object? globalError = _unset,
    bool? isLoading,
  }) {
    return SignupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      nameError: nameError == _unset ? this.nameError : nameError as String?,
      emailError: emailError == _unset ? this.emailError : emailError as String?,
      passwordError: passwordError == _unset ? this.passwordError : passwordError as String?,
      globalError: globalError == _unset ? this.globalError : globalError as String?,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SignupViewModel extends StateNotifier<SignupState> {
  SignupViewModel() : super(SignupState());

  void setName(String value) =>
      state = state.copyWith(name: value, nameError: null, globalError: null);
  void setEmail(String value) =>
      state = state.copyWith(email: value, emailError: null, globalError: null);
  void setPassword(String value) => state = state.copyWith(
    password: value,
    passwordError: null,
    globalError: null,
  );

  Future<void> submit({required VoidCallback onSuccess}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      nameError: null,
      emailError: null,
      passwordError: null,
      globalError: null,
    );

    final nameError = AppValidators.validateName(state.name);
    if (nameError != null) {
      state = state.copyWith(nameError: nameError);
      return;
    }

    final emailError = AppValidators.validateEmail(state.email);
    if (emailError != null) {
      state = state.copyWith(emailError: emailError);
      return;
    }

    final passwordError = AppValidators.validatePassword(state.password);
    if (passwordError != null) {
      state = state.copyWith(passwordError: passwordError);
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(isLoading: false);
      onSuccess();
    } catch (e, st) {
      debugPrint('$e\n$st');
      state = state.copyWith(
        globalError: AppException.networkFailure().message,
        isLoading: false,
      );
    }
  }
}

final signupViewModelProvider =
    StateNotifierProvider.autoDispose<SignupViewModel, SignupState>((ref) {
      return SignupViewModel();
    });
