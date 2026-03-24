import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grit/features/authentication/view/splash/widgets/loading_dots.dart';
import 'package:grit/features/authentication/viewmodel/splash/splash_viewmodel.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the timer/navigation logic
    Future.microtask(() {
      ref.read(splashViewModelProvider.notifier).initTimer(
        onNavigate: (route) {
          if (mounted) context.go(route);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Name
            Text(
              AppTexts.appName,
              style: AppTextStyles.font48Bold.copyWith(
                fontSize: AppSizes.font(GritSizes.fontSize48),
              ),
            ),

            SizedBox(height: AppSizes.height(GritSizes.gap3)),

            // Tagline
            Text(
              AppTexts.tagline,
              style: TextStyle(
                fontSize: AppSizes.font(GritSizes.fontSize14),
                fontWeight: FontWeight.w400, // Regular
                color: AppColors.amber,
                fontFamily: 'Inter',
              ),
            ),

            SizedBox(height: AppSizes.height(20.0)), // 20px proportional approximation

            // Loading Dots
            const LoadingDots(),
          ],
        ),
      ),
    );
  }
}
