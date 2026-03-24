import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/utils/constants/animations.dart';
import 'package:grit/utils/helpers/persistence.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, void>((ref) {
  return SplashViewModel();
});

class SplashViewModel extends StateNotifier<void> {
  SplashViewModel() : super(null);

  Future<void> initTimer({required void Function(String) onNavigate}) async {
    await Future.delayed(AppAnimations.splashScreenWait);
    await _handleNavigation(onNavigate);
  }

  Future<void> _handleNavigation(void Function(String) onNavigate) async {
    final bool onboardingCompleted = await PersistenceService.isOnboardingCompleted();
    
    // Auth state logic (placeholders for now)
    const isLoggedIn = false;
    const role = 'client'; // 'client' or 'trainer'
    const hasProgram = false;

    if (!onboardingCompleted) {
      onNavigate(AppRoutes.onboarding);
    } else if (!isLoggedIn) {
      onNavigate(AppRoutes.signup);
    } else if (role == 'trainer') {
      onNavigate(AppRoutes.trainerDashboard);
    } else if (role == 'client') {
      if (hasProgram) {
        onNavigate(AppRoutes.clientHome);
      } else {
        onNavigate(AppRoutes.waiting);
      }
    }
  }
}
