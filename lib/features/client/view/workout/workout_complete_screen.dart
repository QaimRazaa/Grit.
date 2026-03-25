import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grit/core/routes/app_routes.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class WorkoutCompleteScreen extends StatelessWidget {
  final int streakDays;
  final int exercisesDone;
  final int totalSets;
  final double totalVolume;

  const WorkoutCompleteScreen({
    super.key,
    required this.streakDays,
    required this.exercisesDone,
    required this.totalSets,
    required this.totalVolume,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // #0A0A0A
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.width(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: AppSizes.height(48)),

              // Amber checkmark circle
              Container(
                width: AppSizes.width(80),
                height: AppSizes.height(80),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.amber, // #F59E0B
                ),
                child: Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.background,
                    size: AppSizes.font(40),
                  ),
                ),
              ),

              SizedBox(height: AppSizes.height(24)),

              // Headline
              Text(
                "Workout done.",
                style: AppTextStyles.font32Bold.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSizes.height(12)),

              // Subtext
              Text(
                "Day $streakDays complete. Keep showing up.",
                style: AppTextStyles.font15Medium.copyWith(
                  color: AppColors.muted, // #A3A3A3
                  fontWeight: FontWeight.w400, // Regular mapping
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSizes.height(32)),

              // Streak section
              Text(
                streakDays.toString(),
                style: AppTextStyles.font48Bold.copyWith(
                  color: AppColors.amber, // #F59E0B
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.height(4)),
              Text(
                "day streak",
                style: AppTextStyles.font13Medium.copyWith(
                  color: AppColors.muted, // #A3A3A3
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSizes.height(32)),

              // Summary card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface, // #141414
                  borderRadius: BorderRadius.circular(AppSizes.radius(16)),
                  border: Border.all(
                    color: AppColors.borderDefault, // #2A2A2A
                    width: 1.0,
                  ),
                ),
                padding: EdgeInsets.all(AppSizes.width(24)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Exercises Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          exercisesDone.toString(),
                          style: AppTextStyles.font24Bold.copyWith(
                            color: AppColors.amber,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(4)),
                        Text(
                          'Exercises',
                          style: AppTextStyles.font12RegularMuted.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 1,
                      height: AppSizes.height(40),
                      color: AppColors.borderDefault,
                    ),

                    // Sets Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          totalSets.toString(),
                          style: AppTextStyles.font24Bold.copyWith(
                            color: AppColors.amber,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(4)),
                        Text(
                          'Sets',
                          style: AppTextStyles.font12RegularMuted.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),

                    Container(
                      width: 1,
                      height: AppSizes.height(40),
                      color: AppColors.borderDefault,
                    ),

                    // Volume Column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${totalVolume.toStringAsFixed(0)}kg',
                          style: AppTextStyles.font24Bold.copyWith(
                            color: AppColors.amber,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(4)),
                        Text(
                          'Volume',
                          style: AppTextStyles.font12RegularMuted.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSizes.height(32)),

              // Done button
              GestureDetector(
                onTap: () => context.go(AppRoutes.clientHome),
                child: Container(
                  width: double.infinity,
                  height: AppSizes.height(52),
                  decoration: BoxDecoration(
                    color: AppColors.surface, // #141414
                    borderRadius: BorderRadius.circular(AppSizes.radius(14)),
                    border: Border.all(
                      color: AppColors.amber, // #F59E0B
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Back to Home",
                      style: AppTextStyles.font15Medium.copyWith(
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSizes.height(40)),
            ],
          ),
        ),
      ),
    );
  }
}
