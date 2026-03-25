import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/authentication/view/onboarding/onboarding_screen.dart';
import 'package:grit/features/authentication/view/splash/splash_screen.dart';
import 'package:grit/features/authentication/view/signup/signup_screen.dart';
import 'package:grit/features/authentication/view/signin/signin_screen.dart';
import 'package:grit/features/client/view/goal/goal_step1_screen.dart';
import 'package:grit/features/client/view/goal/goal_step2_screen.dart';
import 'package:grit/features/client/view/goal/goal_step3_screen.dart';
import 'package:grit/features/client/view/goal/goal_step4_screen.dart';
import 'package:grit/features/client/view/goal/waiting_screen.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.signin,
      builder: (context, state) => const SigninScreen(),
    ),
    GoRoute(
      path: AppRoutes.goalStep1,
      builder: (context, state) => const GoalStep1Screen(),
    ),
    GoRoute(
      path: AppRoutes.goalStep2,
      builder: (context, state) => const GoalStep2Screen(),
    ),
    GoRoute(
      path: AppRoutes.goalStep3,
      builder: (context, state) => const GoalStep3Screen(),
    ),
    GoRoute(
      path: AppRoutes.goalStep4,
      builder: (context, state) => const GoalStep4Screen(),
    ),
    GoRoute(
      path: AppRoutes.waiting,
      builder: (context, state) => const WaitingScreen(),
    ),
  ],
);

final appRouterProvider = Provider<GoRouter>((ref) => appRouter);
