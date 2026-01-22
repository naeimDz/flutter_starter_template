import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_starter_template/core/constants/app_colors.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';

/// Reusable Skeleton widget to build shimmer loading states.
class Skeleton extends StatelessWidget {
  final double? height;
  final double? width;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const Skeleton({
    super.key,
    this.height,
    this.width,
    this.borderRadius = AppSizes.radiusSm,
    this.margin,
  });

  /// Factory for a rectangular skeleton
  const Skeleton.rectangle({
    super.key,
    this.height,
    this.width,
    this.borderRadius = AppSizes.radiusSm,
    this.margin,
  });

  /// Factory for a circular skeleton
  const Skeleton.circle({
    super.key,
    double? size,
    this.margin,
  })  : height = size,
        width = size,
        borderRadius = 999;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define colors based on theme
    final baseColor = isDark
        ? (AppColors.neutral[800] ?? Colors.grey[800]!)
        : (AppColors.neutral[200] ?? Colors.grey[300]!);
    final highlightColor = isDark
        ? (AppColors.neutral[700] ?? Colors.grey[700]!)
        : (AppColors.neutral[100] ?? Colors.grey[100]!);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Helper extension to easily add shimmer to any widget
extension ShimmerExtension on Widget {
  Widget withShimmer({bool enabled = true}) {
    if (!enabled) return this;
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: this,
    );
  }
}
