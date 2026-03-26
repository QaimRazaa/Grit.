import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class ExerciseListItem extends StatelessWidget {
  final String name;
  final String muscleGroup;
  final bool isAdded;
  final VoidCallback onToggle;
  final bool isInjuryWarning;

  const ExerciseListItem({
    super.key,
    required this.name,
    required this.muscleGroup,
    required this.isAdded,
    required this.onToggle,
    this.isInjuryWarning = false,
  });

  IconData _muscleIcon(String group) {
    switch (group.toLowerCase()) {
      case 'chest':
        return Icons.accessibility_new_rounded;
      case 'back':
        return Icons.accessibility_rounded;
      case 'shoulders':
        return Icons.sports_gymnastics_rounded;
      case 'arms':
        return Icons.fitness_center_rounded;
      case 'legs':
        return Icons.directions_run_rounded;
      case 'core':
        return Icons.radio_button_checked_rounded;
      default:
        return Icons.fitness_center_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSizes.height(14)),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderDefault, width: 1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Muscle icon box
          Container(
            width: AppSizes.width(36),
            height: AppSizes.width(36),
            decoration: BoxDecoration(
              color: AppColors.amber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(AppSizes.radius(8)),
            ),
            alignment: Alignment.center,
            child: Icon(
              _muscleIcon(muscleGroup),
              color: AppColors.amber,
              size: AppSizes.font(16),
            ),
          ),
          SizedBox(width: AppSizes.width(12)),
          // Name + group
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.font14Regular),
                SizedBox(height: AppSizes.height(2)),
                Row(
                  children: [
                    Text(
                      muscleGroup.toUpperCase(),
                      style: AppTextStyles.font12RegularMuted.copyWith(letterSpacing: 0.5),
                    ),
                    if (isInjuryWarning) ...[
                      SizedBox(width: AppSizes.width(6)),
                      Icon(
                        Icons.warning_rounded,
                        color: AppColors.red,
                        size: AppSizes.font(12),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Add/check button
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: AppSizes.width(28),
              height: AppSizes.width(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isAdded ? AppColors.amber : Colors.transparent,
                border: isAdded ? null : Border.all(color: AppColors.amber, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Icon(
                isAdded ? Icons.check_rounded : Icons.add_rounded,
                color: isAdded ? AppColors.background : AppColors.amber,
                size: AppSizes.font(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
