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
import 'package:grit/features/client/view/home/home_screen.dart';
import 'package:grit/features/client/view/workout/active_workout_screen.dart';
import 'package:grit/features/client/view/workout/workout_complete_screen.dart';
import 'package:grit/features/trainer/view/home/trainer_home_screen.dart';
import 'package:grit/features/trainer/view/programs/programs_list_screen.dart';
import 'package:grit/features/trainer/view/programs/program_builder_screen.dart';
import 'package:grit/features/trainer/view/home/client_profile_screen.dart';
import 'package:grit/features/trainer/view/logs/trainer_logs_screen.dart';
import 'package:grit/features/trainer/view/assign/assign_program_screen.dart';


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
    GoRoute(
      path: AppRoutes.clientHome,
      builder: (context, state) => const ClientHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.activeWorkout,
      builder: (context, state) => const ActiveWorkoutScreen(),
    ),
    GoRoute(
      path: AppRoutes.workoutComplete,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return WorkoutCompleteScreen(
          streakDays: extra['streakDays'] as int? ?? 1,
          exercisesDone: extra['exercisesDone'] as int? ?? 0,
          totalSets: extra['totalSets'] as int? ?? 0,
          totalVolume: extra['totalVolume'] as double? ?? 0.0,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.trainerDashboard,
      builder: (context, state) => const TrainerHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.trainerPrograms,
      builder: (context, state) => const ProgramsListScreen(),
    ),
    GoRoute(
      path: AppRoutes.programBuilder,
      builder: (context, state) => const ProgramBuilderScreen(),
    ),
    GoRoute(
      path: AppRoutes.assignProgram,
      builder: (context, state) => const AssignProgramScreen(),
    ),
    GoRoute(
      path: '${AppRoutes.clientProfile}/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ClientProfileScreen(clientId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.trainerLogs,
      builder: (context, state) => const TrainerLogsScreen(),
    ),
  ],
);


final appRouterProvider = Provider<GoRouter>((ref) => appRouter);
