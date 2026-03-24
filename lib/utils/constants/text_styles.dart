import 'package:flutter/material.dart';
import 'package:grit/utils/constants/colors.dart';
import 'package:grit/utils/constants/sizes.dart';

class AppTextStyles {
  // Font Weights
  static const FontWeight _bold = FontWeight.w700;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _regular = FontWeight.w400;

  // Bold
  static const TextStyle font48Bold = TextStyle(
    fontSize: GritSizes.fontSize48,
    fontWeight: _bold,
    color: AppColors.white,
    fontFamily: 'Inter',
  );
  static const TextStyle font32Bold = TextStyle(
    fontSize: GritSizes.fontSize32,
    fontWeight: _bold,
    color: AppColors.white,
    fontFamily: 'Inter',
  );
  static const TextStyle font24Bold = TextStyle(
    fontSize: GritSizes.fontSize24,
    fontWeight: _bold,
    color: AppColors.white,
    fontFamily: 'Inter',
  );
  static const TextStyle font22Bold = TextStyle(
    fontSize: GritSizes.fontSize22,
    fontWeight: _bold,
    color: AppColors.white,
    fontFamily: 'Inter',
  );
  static const TextStyle font18Bold = TextStyle(
    fontSize: GritSizes.fontSize18,
    fontWeight: _bold,
    color: AppColors.white,
    fontFamily: 'Inter',
  );

  // Medium
  static const TextStyle font15Medium = TextStyle(
    fontSize: GritSizes.fontSize15,
    fontWeight: _medium,
    color: AppColors.white,
    fontFamily: 'Inter',
  );
  static const TextStyle font13Medium = TextStyle(
    fontSize: GritSizes.fontSize13,
    fontWeight: _medium,
    color: AppColors.white,
    fontFamily: 'Inter',
  );
  static const TextStyle font11Medium = TextStyle(
    fontSize: GritSizes.fontSize11,
    fontWeight: _medium,
    color: AppColors.muted,
    fontFamily: 'Inter',
    textBaseline: TextBaseline.alphabetic,
  );

  // Regular
  static const TextStyle font15Regular = TextStyle(
    fontSize: GritSizes.fontSize15,
    fontWeight: _regular,
    color: AppColors.white,
    fontFamily: 'Inter',
  );
  static const TextStyle font14Regular = TextStyle(
    fontSize: GritSizes.fontSize14,
    fontWeight: _regular,
    color: AppColors.white,
    fontFamily: 'Inter',
  );
  static const TextStyle font14RegularMuted = TextStyle(
    fontSize: GritSizes.fontSize14,
    fontWeight: _regular,
    color: AppColors.muted,
    fontFamily: 'Inter',
  );
  static const TextStyle font13Regular = TextStyle(
    fontSize: GritSizes.fontSize13,
    fontWeight: _regular,
    color: AppColors.white,
    fontFamily: 'Inter',
  );
  static const TextStyle font13RegularMuted = TextStyle(
    fontSize: GritSizes.fontSize13,
    fontWeight: _regular,
    color: AppColors.muted,
    fontFamily: 'Inter',
  );
  static const TextStyle font13RegularAmber = TextStyle(
    fontSize: GritSizes.fontSize13,
    fontWeight: _regular,
    color: AppColors.amber,
    fontFamily: 'Inter',
  );
  static const TextStyle font12Regular = TextStyle(
    fontSize: GritSizes.fontSize12,
    fontWeight: _regular,
    color: AppColors.white,
    fontFamily: 'Inter',
  );
  static const TextStyle font12RegularMuted = TextStyle(
    fontSize: GritSizes.fontSize12,
    fontWeight: _regular,
    color: AppColors.muted,
    fontFamily: 'Inter',
  );
  static const TextStyle font12RegularRed = TextStyle(
    fontSize: GritSizes.fontSize12,
    fontWeight: _regular,
    color: AppColors.red,
    fontFamily: 'Inter',
  );
  static const TextStyle font11RegularDim = TextStyle(
    fontSize: GritSizes.fontSize11,
    fontWeight: _regular,
    color: AppColors.dim,
    fontFamily: 'Inter',
  );

  AppTextStyles._();
}
