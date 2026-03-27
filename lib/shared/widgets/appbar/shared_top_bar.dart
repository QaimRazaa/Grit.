import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/texts.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class SharedTopBar extends StatelessWidget {
  final String greeting;
  final String firstName;
  final String initials;
  final VoidCallback? onLogout;

  const SharedTopBar({
    super.key,
    this.greeting = AppTexts.homeGreeting,
    this.firstName = 'Ali',
    this.initials = 'AK',
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSizes.height(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting,\n$firstName',
                style: AppTextStyles.font22Bold.copyWith(
                  letterSpacing: -0.5,
                  height: 1.2,
                ),
              ),
            ],
          ),

          // Right side: Avatar & Logout (optional for testing)
          Row(
            children: [
              if (onLogout != null)
                IconButton(
                  onPressed: onLogout,
                  icon: Icon(
                    Icons.logout_rounded,
                    color: AppColors.muted,
                    size: AppSizes.font(20),
                  ),
                ),
              SizedBox(width: AppSizes.width(8)),
              Container(
                width: AppSizes.width(34),
                height: AppSizes.width(34),
                decoration: BoxDecoration(
                  color: AppColors.surface2, // #1F1F1F
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.amber,
                    width: AppSizes.width(2),
                  ),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: AppTextStyles.font15Medium.copyWith(
                      fontWeight: FontWeight.w700, // Bold
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
