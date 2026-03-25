import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:grit/shared/viewmodels/navbar/trainer_bottom_nav_viewmodel.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';
import 'package:grit/utils/helpers/ui_helper.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';

class TrainerBottomNavBar extends ConsumerWidget {
  final int? selectedIndex;
  const TrainerBottomNavBar({super.key, this.selectedIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = selectedIndex ?? ref.watch(trainerBottomNavIndexProvider);

    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width(16),
            vertical: AppSizes.height(8),
          ),
          child: GNav(
            backgroundColor: AppColors.background,
            tabBackgroundColor: AppColors.surface2,
            activeColor: AppColors.white,
            color: AppColors.muted,
            padding: EdgeInsets.all(AppSizes.width(16)),
            gap: AppSizes.width(8),
            selectedIndex: currentIndex,
            onTabChange: (index) {
              ref.read(trainerBottomNavIndexProvider.notifier).state = index;
              if (index == 0) {
                context.go(AppRoutes.trainerDashboard);
              } else if (index == 2) {
                context.go(AppRoutes.trainerPrograms);
              } else {
                final feature = index == 1
                    ? AppTexts.trainerNavClients
                    : index == 3
                        ? AppTexts.navChat
                        : AppTexts.onboardingStep1;
                UIHelper.showComingSoon(context, feature);
              }
            },
            tabs: const [
              GButton(
                icon: Icons.home_rounded,
                text: AppTexts.navHome,
              ),
              GButton(
                icon: Icons.people_outline_rounded,
                text: AppTexts.trainerNavClients,
              ),
              GButton(
                icon: Icons.fitness_center_rounded,
                text: AppTexts.trainerNavPrograms,
              ),
              GButton(
                icon: Icons.chat_bubble_rounded,
                text: AppTexts.navChat,
              ),
              GButton(
                icon: Icons.person_outline_rounded,
                text: AppTexts.onboardingStep1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
