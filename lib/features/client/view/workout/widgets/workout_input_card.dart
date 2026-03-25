import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class WorkoutInputCard extends StatelessWidget {
  final String label;
  final String displayValue;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const WorkoutInputCard({
    super.key,
    required this.label,
    required this.displayValue,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final isBodyweight = displayValue == "BW";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.width(24)),
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.width(24),
        vertical: AppSizes.height(20),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface, // #141414
        border: Border.all(
          color: AppColors.borderDefault, // #2A2A2A
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(AppSizes.radius(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.font11RegularDim.copyWith(
                  color: AppColors.muted, // #A3A3A3
                  letterSpacing: 11 * 0.1, // 0.1em
                ),
              ),
              SizedBox(height: AppSizes.height(8)),
              Text(
                displayValue,
                style: isBodyweight 
                    ? AppTextStyles.font32Regular.copyWith(
                        color: AppColors.muted, // #A3A3A3
                      )
                    : AppTextStyles.font52Bold.copyWith(
                        letterSpacing: -2.0,
                      ),
              ),
            ],
          ),
          
          // Right side
          Row(
            children: [
              _buildControlButton("−", onMinus),
              SizedBox(width: AppSizes.width(8)),
              _buildControlButton("+", onPlus),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildControlButton(String symbol, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSizes.width(48),
        height: AppSizes.width(48),
        decoration: BoxDecoration(
          color: AppColors.surface2, // #1F1F1F
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.borderDefault, // #2A2A2A
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            symbol,
            style: AppTextStyles.font24Bold.copyWith(
              color: AppColors.amber, // #F59E0B
              // Subtle alignment tweak might be needed for perfect centering of symbols, but flutter handles standard ones fine
            ),
          ),
        ),
      ),
    );
  }
}
