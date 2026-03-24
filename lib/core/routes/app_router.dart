import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/features/authentication/view/onboarding/onboarding_screen.dart';
import 'package:grit/features/authentication/view/splash/splash_screen.dart';
import 'package:grit/features/authentication/view/signup/signup_screen.dart';
import 'package:grit/features/authentication/view/signin/signin_screen.dart';
import 'package:grit/features/dashboard/view/client_home/client_home_screen.dart';
import 'package:grit/features/dashboard/view/trainer_dashboard/trainer_dashboard_screen.dart';

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
      path: AppRoutes.clientHome,
      builder: (context, state) => const ClientHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.trainerDashboard,
      builder: (context, state) => const TrainerDashboardScreen(),
    ),
  ],
);

final appRouterProvider = Provider<GoRouter>((ref) => appRouter);
