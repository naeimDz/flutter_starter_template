import 'package:flutter/material.dart';

/// Consistent spacing and sizing system.
///
/// Usage: `AppSizes.paddingMd` or `AppSizes.radiusSm`
class AppSizes {
  AppSizes._();

  // Spacing Scale
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing56 = 56.0;
  static const double spacing64 = 64.0;

  // Semantic Spacing
  static const double paddingXs = spacing4;
  static const double paddingSm = spacing8;
  static const double paddingMd = spacing16;
  static const double paddingLg = spacing24;
  static const double paddingXl = spacing32;

  static const double marginXs = spacing4;
  static const double marginSm = spacing8;
  static const double marginMd = spacing16;
  static const double marginLg = spacing24;
  static const double marginXl = spacing32;

  static const double gapXs = spacing4;
  static const double gapSm = spacing8;
  static const double gapMd = spacing16;
  static const double gapLg = spacing24;

  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // Icon Sizes
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Button Heights
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 44.0;
  static const double buttonHeightLg = 52.0;

  // Input Heights
  static const double inputHeightSm = 40.0;
  static const double inputHeightMd = 48.0;
  static const double inputHeightLg = 56.0;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 112.0;

  // Bottom Navigation
  static const double bottomNavHeight = 64.0;

  // Card
  static const double cardElevation = 2.0;
  static const double cardElevationHigh = 8.0;

  // Divider
  static const double dividerThickness = 1.0;

  // Animation Durations (milliseconds)
  static const int animationFast = 150;
  static const int animationNormal = 300;
  static const int animationSlow = 500;

  // Animation Durations as Duration
  static const Duration durationFast = Duration(milliseconds: animationFast);
  static const Duration durationNormal =
      Duration(milliseconds: animationNormal);
  static const Duration durationSlow = Duration(milliseconds: animationSlow);

  // Screen Breakpoints
  static const double breakpointMobile = 480.0;
  static const double breakpointTablet = 768.0;
  static const double breakpointDesktop = 1024.0;
  static const double breakpointWide = 1280.0;

  // Max Content Width
  static const double maxContentWidth = 600.0;
  static const double maxContentWidthWide = 1200.0;

  // EdgeInsets Helpers
  static const EdgeInsets paddingAllXs = EdgeInsets.all(paddingXs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(paddingSm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(paddingMd);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(paddingLg);

  static const EdgeInsets paddingHorizontalMd =
      EdgeInsets.symmetric(horizontal: paddingMd);
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: paddingMd);

  static const EdgeInsets paddingScreen = EdgeInsets.symmetric(
    horizontal: paddingMd,
    vertical: paddingMd,
  );

  // BorderRadius Helpers
  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
}
