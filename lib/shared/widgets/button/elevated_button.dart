import 'package:flutter/material.dart';
import 'package:grit/utils/device/responsive_size.dart';

import '../../../utils/constants/text_styles.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Gradient? gradient;
  final Color textColor;
  final double? fontSize;
  final VoidCallback? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double? borderWidth;
  final Widget? icon;
  final Widget? child;

  const CustomElevatedButton({
    super.key,
    required this.text,
    this.backgroundColor,
    this.gradient,
    required this.textColor,
    required this.onPressed,
    this.fontSize,
    this.borderRadius = 25,
    this.padding,
    this.width,
    this.height,
    this.borderColor,
    this.borderWidth,
    this.icon,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null ? AppSizes.width(width!) : null,
      height: height != null ? AppSizes.height(height!) : null,
      decoration: BoxDecoration(
        gradient: gradient,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.width(borderRadius)),
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth ?? 1,
              )
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.width(borderRadius)),
          ),
          padding: padding ??
              EdgeInsets.symmetric(
                vertical: AppSizes.height(1.5),
                horizontal: AppSizes.width(4),
              ),
        ),
        child: child ?? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(width: AppSizes.width(2)),
            ],
            Text(
              text,
              style: AppTextStyles.font14Regular.copyWith(
                color: textColor,
                fontSize: fontSize ?? AppSizes.font(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
