import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/utils/helpers/persistence.dart';

/// State for Onboarding
class OnboardingState {
  final int currentPage;
  final bool isLastPage;

  OnboardingState({
    this.currentPage = 0,
    this.isLastPage = false,
  });

  OnboardingState copyWith({
    int? currentPage,
    bool? isLastPage,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}

/// ViewModel for Onboarding
class OnboardingViewModel extends StateNotifier<OnboardingState> {
  OnboardingViewModel() : super(OnboardingState());

  final PageController pageController = PageController();

  void updatePageIndicator(int index) {
    state = state.copyWith(
      currentPage: index,
      isLastPage: index == 2,
    );
  }

  void nextPage({required VoidCallback onSuccess}) {
    if (state.currentPage < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding(onSuccess: onSuccess);
    }
  }

  void skip({required VoidCallback onSuccess}) {
    finishOnboarding(onSuccess: onSuccess);
  }

  void finishOnboarding({required VoidCallback onSuccess}) async {
    await PersistenceService.markOnboardingCompleted();
    onSuccess();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

final onboardingViewModelProvider =
    StateNotifierProvider<OnboardingViewModel, OnboardingState>((ref) {
  return OnboardingViewModel();
});
