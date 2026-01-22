import 'package:flutter/material.dart';
import 'package:flutter_starter_template/core/constants/app_colors.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';

enum ButtonType { primary, secondary, outline, text }

/// Premium Custom Button with support for various styles, icons, and loading states.
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final ButtonType type;
  final IconData? icon;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.type = ButtonType.primary,
    this.icon,
    this.width,
    this.height,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: _buildButton(context, isDark: isDark),
    );
  }

  Widget _buildButton(BuildContext context, {required bool isDark}) {
    final style = _getButtonStyle(context, isDark);
    final child = _buildChild(context);

    switch (type) {
      case ButtonType.outline:
        return OutlinedButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: style,
          child: child,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: style,
          child: child,
        );
      case ButtonType.secondary:
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: (isLoading || isDisabled) ? null : onPressed,
          style: style,
          child: child,
        );
    }
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: type == ButtonType.outline || type == ButtonType.text
              ? Theme.of(context).primaryColor
              : Colors.white,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22),
          const SizedBox(width: AppSizes.spacing8),
          Text(text),
        ],
      );
    }

    return Text(text);
  }

  ButtonStyle? _getButtonStyle(BuildContext context, bool isDark) {
    final theme = Theme.of(context);

    switch (type) {
      case ButtonType.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: foregroundColor ?? theme.primaryColor,
          side: BorderSide(color: foregroundColor ?? theme.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          textStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );
      case ButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: foregroundColor ?? theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          textStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );
      case ButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ??
              (isDark ? AppColors.neutral[800] : AppColors.neutral[200]),
          foregroundColor:
              foregroundColor ?? (isDark ? Colors.white : Colors.black87),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          textStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );
      case ButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.primaryColor,
          foregroundColor: foregroundColor ?? Colors.white,
          elevation: AppSizes.cardElevation,
          shadowColor: (backgroundColor ?? theme.primaryColor).withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
          ),
          textStyle: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        );
    }
  }
}
