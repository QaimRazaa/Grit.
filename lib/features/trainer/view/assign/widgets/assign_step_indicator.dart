import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class AssignStepIndicator extends StatelessWidget {
  final int currentStep;

  const AssignStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Client', 'Program', 'Confirm'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(steps.length, (index) {
        final bool isDone = index < currentStep;
        final bool isCurrent = index == currentStep;
        final bool isUpcoming = index > currentStep;

        return Expanded(
          child: Row(
            children: [
              // Step circle and label
              Column(
                children: [
                  Container(
                    width: AppSizes.width(28),
                    height: AppSizes.width(28),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone || isCurrent ? AppColors.amber : AppColors.surface2,
                      border: isUpcoming ? Border.all(color: AppColors.borderDefault, width: 1) : null,
                    ),
                    alignment: Alignment.center,
                    child: isDone
                        ? Icon(
                            Icons.check_rounded,
                            color: AppColors.background,
                            size: AppSizes.font(16),
                          )
                        : Text(
                            '${index + 1}',
                            style: AppTextStyles.font12Regular.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isCurrent ? AppColors.background : AppColors.dim,
                            ),
                          ),
                  ),
                  SizedBox(height: AppSizes.height(6)),
                  Text(
                    steps[index],
                    style: AppTextStyles.font10Regular.copyWith(
                      color: isDone || isCurrent ? AppColors.white : AppColors.dim,
                    ),
                  ),
                ],
              ),

              // Connector line
              if (index < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 1,
                    margin: EdgeInsets.only(
                      left: AppSizes.width(8),
                      right: AppSizes.width(8),
                      bottom: AppSizes.height(18), // Align with circles
                    ),
                    color: index < currentStep ? AppColors.amber : AppColors.borderDefault,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
