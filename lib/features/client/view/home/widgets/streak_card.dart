import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class StreakCard extends StatelessWidget {
  final int streakCount;
  final List<bool> last7DaysLogged;
  final int personalBest;

  const StreakCard({
    super.key,
    this.streakCount = 14,
    this.last7DaysLogged = const [true, true, true, true, true, true, false],
    this.personalBest = 21,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    final List<double> heights = [28, 20, 28, 24, 28, 28, 12];

    return Container(
      clipBehavior: Clip.hardEdge,
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(16),
        vertical: AppSizes.height(16),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface, // #141414
        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
        border: Border.all(
          color: AppColors.borderDefault, // #2A2A2A
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.amber.withOpacity(0.04), // Subtle amber glow
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none, // Allow overflow within the container layout
        children: [
          // Decorative element
          Positioned(
            top: AppSizes.height(-36), // Align exactly based on 16 padding to reach target -20 from border edge
            right: AppSizes.width(-36),
            child: Container(
              width: AppSizes.width(120),
              height: AppSizes.width(120),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x0AF59E0B), // 4% opacity amber
              ),
            ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Section: Streak Number + Bars
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Inline Streak Number and Label
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        streakCount.toString(),
                        style: AppTextStyles.font48ExtraBold.copyWith(
                          color: AppColors.amber,
                          letterSpacing: -2.0,
                          height: 1.0,
                        ),
                      ),
                      SizedBox(width: AppSizes.width(8)),
                      Text(
                        AppTexts.homeDayStreak,
                        style: AppTextStyles.font12RegularMuted,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.height(12)),
                  // 7 Bars Mini Chart
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                      final isLogged = index < last7DaysLogged.length ? last7DaysLogged[index] : false;
                      final double opacity = 0.5 + (0.5 * (index / 6));
                      final barColor = isLogged 
                          ? AppColors.amber.withOpacity(opacity)
                          : AppColors.borderDefault; // #2A2A2A
                      
                      return Padding(
                        padding: EdgeInsets.only(right: index == 6 ? 0 : AppSizes.width(6)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: AppSizes.width(8),
                              height: AppSizes.height(heights[index]),
                              decoration: BoxDecoration(
                                color: barColor,
                                borderRadius: BorderRadius.circular(AppSizes.radius(3)),
                              ),
                            ),
                            SizedBox(height: AppSizes.height(6)),
                            Text(
                              days[index],
                              style: AppTextStyles.font10Regular.copyWith(
                                color: AppColors.dim, // #555555
                                letterSpacing: 10 * 0.05, // 0.05em
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
              
              // Right Section: Personal Best Mini Card
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.width(12),
                      vertical: AppSizes.height(8),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x22F59E0B), // 13% opacity
                      borderRadius: BorderRadius.circular(AppSizes.radius(12)),
                      border: Border.all(
                        color: const Color(0x44F59E0B),
                        width: AppSizes.width(1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppTexts.homePersonalBestLabel,
                          style: AppTextStyles.font10SemiBold.copyWith(
                            color: AppColors.muted,
                          ),
                        ),
                        SizedBox(height: AppSizes.height(2)),
                        Text(
                          '$personalBest ${AppTexts.homePersonalBestSuffix}',
                          style: AppTextStyles.font18Bold.copyWith(
                            color: AppColors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.height(6)),
                  Text(
                    AppTexts.homeKeepGoing,
                    style: AppTextStyles.font11RegularDim,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
