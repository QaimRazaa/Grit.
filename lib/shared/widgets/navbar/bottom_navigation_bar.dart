import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:grit/shared/viewmodels/navbar/bottom_nav_viewmodel.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/device/responsive_size.dart';

class SharedBottomNavBar extends ConsumerWidget {
  const SharedBottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.width(16.0), 
            vertical: AppSizes.height(8.0),
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
              ref.read(bottomNavIndexProvider.notifier).state = index;
              // Add GoRouter navigation here depending on tabs
            },
            tabs: [
              const GButton(
                icon: Icons.home_rounded,
                text: AppTexts.navHome,
              ),
              const GButton(
                icon: Icons.bar_chart_rounded,
                text: AppTexts.navProgress,
              ),
              GButton(
                icon: Icons.chat_bubble_rounded,
                text: AppTexts.navChat,
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.chat_bubble_rounded,
                      color: currentIndex == 2 ? AppColors.white : AppColors.muted,
                    ),
                    Positioned(
                      top: -AppSizes.height(2),
                      right: -AppSizes.width(2),
                      child: Container(
                        width: AppSizes.width(8),
                        height: AppSizes.width(8),
                        decoration: const BoxDecoration(
                          color: AppColors.red, // #EF4444
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
