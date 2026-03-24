import 'dart:math';
import 'package:flutter/material.dart';

class AppSizes {
  static late double screenWidth;
  static late double screenHeight;
  static late double blockWidth;
  static late double blockHeight;
  static late EdgeInsets safeArea;
  static bool initialized = false;

  // Add lock to prevent race conditions
  static bool _isInitializing = false;

  static void initFromMediaQuery(MediaQueryData mediaQuery) {
    // Prevent multiple simultaneous initializations
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      // Validate MediaQuery data before using it
      screenWidth = mediaQuery.size.width;
      screenHeight = mediaQuery.size.height;
      safeArea = mediaQuery.padding;

      final usableWidth = max(
        screenWidth - safeArea.left - safeArea.right,
        1.0,
      );
      final usableHeight = max(
        screenHeight - safeArea.top - safeArea.bottom,
        1.0,
      );

      blockWidth = usableWidth / 100;
      blockHeight = usableHeight / 100;

      // Extra validation
      if (blockWidth.isNaN ||
          blockHeight.isNaN ||
          blockWidth <= 0 ||
          blockHeight <= 0) {
        _isInitializing = false;
        return;
      }

      initialized = true;
    } catch (e) {
      initialized = false;
    } finally {
      _isInitializing = false;
    }
  }

  static void reset() {
    initialized = false;
    _isInitializing = false;
  }

  // Enhanced validation
  static const double _designWidth = 390.0;
  static const double _designHeight = 844.0;

  static bool get _isValid =>
      initialized &&
      !_isInitializing &&
      !screenWidth.isNaN &&
      !screenHeight.isNaN &&
      !blockWidth.isNaN &&
      !blockHeight.isNaN &&
      screenWidth > 0 &&
      screenHeight > 0 &&
      blockWidth > 0 &&
      blockHeight > 0;

  static double width(double pixels) {
    if (!_isValid) {
      return 0;
    }
    return (pixels / _designWidth) * screenWidth;
  }

  static double height(double pixels) {
    if (!_isValid) {
      return 0;
    }
    return (pixels / _designHeight) * screenHeight;
  }

  static double radius(double pixels) {
    if (!_isValid) return 0;
    return (pixels / _designWidth) * screenWidth;
  }

  static double icon(double pixels) {
    if (!_isValid) return 0;
    return (pixels / _designWidth) * screenWidth;
  }

  static double font(double size) {
    if (!_isValid) return size; // Safe fallback
    final diagonal = sqrt(
      screenWidth * screenWidth + screenHeight * screenHeight,
    );
    final calculated = (size * diagonal) / 900;
    return calculated.isNaN ? size : calculated;
  }

  static EdgeInsets paddingAll(double pixels) {
    if (!_isValid) return EdgeInsets.zero;
    return EdgeInsets.all(width(pixels));
  }

  static EdgeInsets paddingSymmetric({double h = 0, double v = 0}) {
    if (!_isValid) return EdgeInsets.zero;
    return EdgeInsets.symmetric(
      horizontal: width(h),
      vertical: height(v),
    );
  }

  static EdgeInsets paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    if (!_isValid) return EdgeInsets.zero;
    return EdgeInsets.only(
      left: width(left),
      top: height(top),
      right: width(right),
      bottom: height(bottom),
    );
  }

  static bool get isMobile => _isValid ? screenWidth < 600 : true;
  static bool get isTablet =>
      _isValid ? (screenWidth >= 600 && screenWidth < 1024) : false;
  static bool get isDesktop => _isValid ? screenWidth >= 1024 : false;
  static bool get isWideScreen => _isValid ? screenWidth > 600 : false;

  static double responsiveFont(double base, {double? tablet, double? desktop}) {
    if (!_isValid) return base;
    if (isDesktop) return font(desktop ?? base * 1.4);
    if (isTablet) return font(tablet ?? base * 1.2);
    return font(base);
  }
}
