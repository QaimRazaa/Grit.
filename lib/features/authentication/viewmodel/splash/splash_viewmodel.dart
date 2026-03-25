import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/authentication/data/repository/auth_repository.dart';
import 'package:grit/utils/constants/animations.dart';
import 'package:grit/utils/helpers/persistence.dart';

final splashViewModelProvider = StateNotifierProvider<SplashViewModel, void>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SplashViewModel(authRepository);
});

class SplashViewModel extends StateNotifier<void> {
  final AuthRepository _authRepository;

  SplashViewModel(this._authRepository) : super(null);

  Future<void> initTimer({required void Function(String) onNavigate}) async {
    await Future.delayed(AppAnimations.splashScreenWait);
    await _handleNavigation(onNavigate);
  }

  Future<void> _handleNavigation(void Function(String) onNavigate) async {
    final bool onboardingCompleted = await PersistenceService.isOnboardingCompleted();
    
    if (!onboardingCompleted) {
      onNavigate(AppRoutes.onboarding);
      return;
    }

    final user = _authRepository.currentUser;
    if (user == null) {
      onNavigate(AppRoutes.signin);
      return;
    }

    try {
      final profile = await _authRepository.getUserProfile(user.id);
      if (profile != null) {
        final role = profile['role'] as String?;
        if (role == 'trainer') {
          onNavigate(AppRoutes.trainerDashboard);
        } else {
          final goalDone = profile['profile_completed'] == true;
          onNavigate(goalDone ? AppRoutes.clientHome : AppRoutes.goalStep1);
        }
      } else {
        // Fallback if profile not found
        onNavigate(AppRoutes.signin);
      }
    } catch (e) {
      // Handle error (e.g., netork issue)
      onNavigate(AppRoutes.signin);
    }
  }
}
