import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/utils/exceptions/app_exceptions.dart';
import 'package:grit/utils/validators/app_validators.dart';

class SigninState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final String? globalError;
  final bool isLoading;

  SigninState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.globalError,
    this.isLoading = false,
  });

  bool get isButtonActive =>
      AppValidators.validateEmail(email) == null &&
      password.isNotEmpty;

  static const _unset = Object();

  SigninState copyWith({
    String? email,
    String? password,
    Object? emailError = _unset,
    Object? passwordError = _unset,
    Object? globalError = _unset,
    bool? isLoading,
  }) {
    return SigninState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError == _unset ? this.emailError : emailError as String?,
      passwordError: passwordError == _unset ? this.passwordError : passwordError as String?,
      globalError: globalError == _unset ? this.globalError : globalError as String?,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SigninViewModel extends StateNotifier<SigninState> {
  SigninViewModel() : super(SigninState());

  void setEmail(String value) =>
      state = state.copyWith(email: value, emailError: null, globalError: null);
  void setPassword(String value) =>
      state = state.copyWith(password: value, passwordError: null, globalError: null);

  Future<void> submit({required VoidCallback onSuccess}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      emailError: null,
      passwordError: null,
      globalError: null,
    );

    final emailError = AppValidators.validateEmail(state.email);
    if (emailError != null) {
      state = state.copyWith(emailError: emailError);
      return;
    }

    if (state.password.isEmpty) {
      state = state.copyWith(passwordError: AppException.passwordTooShort().message);
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

final signinViewModelProvider =
    StateNotifierProvider.autoDispose<SigninViewModel, SigninState>((ref) {
      return SigninViewModel();
    });
