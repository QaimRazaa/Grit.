import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';
import 'package:grit/utils/constants/text_styles.dart';
import 'package:grit/utils/device/responsive_size.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final double? height;
  final double? width;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final VoidCallback? onSuffixTap;
  final EdgeInsetsGeometry? prefixPadding;
  final EdgeInsetsGeometry? suffixPadding;
  final TextStyle? hintTextStyle;
  final String? labelText;
  final TextStyle? labelStyle;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final List<String>? autofillHints;
  final VoidCallback? onEditingComplete;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.height,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.contentPadding,
    this.onSuffixTap,
    this.width,
    this.prefixPadding,
    this.hintTextStyle,
    this.labelText,
    this.labelStyle,
    this.suffixPadding,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: labelStyle ??
                AppTextStyles.font13RegularMuted.copyWith(
                  fontSize: AppSizes.font(GritSizes.fontSize13),
                ),
          ),
          SizedBox(height: AppSizes.height(GritSizes.gap6)),
        ],
        SizedBox(
          height: height,
          width: width,
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            maxLines: maxLines,
            minLines: minLines,
            enabled: enabled,
            readOnly: readOnly,
            cursorColor: AppColors.amber,
            onTap: onTap,
            inputFormatters: inputFormatters,
            focusNode: focusNode,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            autofillHints: autofillHints,
            onEditingComplete: onEditingComplete,
            style: AppTextStyles.font15Regular,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              errorStyle: AppTextStyles.font12RegularRed.copyWith(
                fontSize: AppSizes.font(GritSizes.fontSize12),
                height: 1.2,
              ),
              errorMaxLines: 1,
              isDense: true,
              isCollapsed: false,
              hintText: hintText,
              hintStyle: hintTextStyle ??
                  AppTextStyles.font15Regular.copyWith(
                    color: AppColors.muted,
                  ),
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: prefixPadding ??
                          EdgeInsets.only(
                            left: AppSizes.width(12),
                            right: AppSizes.width(8),
                          ),
                      child: prefixIcon,
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixTap,
                      child: Padding(
                        padding: suffixPadding ??
                            EdgeInsets.only(right: AppSizes.width(12)),
                        child: suffixIcon,
                      ),
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              filled: true,
              fillColor: fillColor ?? AppColors.surface,
              contentPadding: contentPadding ??
                  EdgeInsets.symmetric(
                    horizontal: AppSizes.width(16),
                    vertical: AppSizes.height(14),
                  ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppSizes.radius(GritSizes.radius12),
                ),
                borderSide: BorderSide(
                  color: borderColor ?? AppColors.borderDefault,
                  width: GritSizes.borderWidth1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppSizes.radius(GritSizes.radius12),
                ),
                borderSide: BorderSide(
                  color: borderColor ?? AppColors.borderDefault,
                  width: GritSizes.borderWidth1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppSizes.radius(GritSizes.radius12),
                ),
                borderSide: BorderSide(
                  color: focusedBorderColor ?? AppColors.amber,
                  width: GritSizes.borderWidth1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppSizes.radius(GritSizes.radius12),
                ),
                borderSide: BorderSide(
                  color: AppColors.red,
                  width: GritSizes.borderWidth1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppSizes.radius(GritSizes.radius12),
                ),
                borderSide: BorderSide(
                  color: AppColors.red,
                  width: GritSizes.borderWidth1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  borderRadius ?? AppSizes.radius(GritSizes.radius12),
                ),
                borderSide: BorderSide(
                  color: borderColor ?? AppColors.borderDefault,
                  width: GritSizes.borderWidth1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
