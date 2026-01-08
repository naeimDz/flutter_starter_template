import 'package:flutter/material.dart';
import 'package:flutter_starter_template/core/constants/app_colors.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';
import 'package:flutter_starter_template/core/routes/routes.dart';

/// Dialog helper utilities for common dialog patterns.
class DialogHelper {
  DialogHelper._();

  /// Show a simple alert dialog.
  static Future<void> showAlert({
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onPressed,
  }) async {
    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onPressed?.call();
            },
            child: Text(buttonText ?? 'OK'),
          ),
        ],
      ),
    );
  }

  /// Show a confirmation dialog with cancel and confirm buttons.
  static Future<bool> showConfirm({
    required String title,
    required String message,
    String? cancelText,
    String? confirmText,
    bool isDangerous = false,
  }) async {
    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancelText ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: isDangerous
                ? TextButton.styleFrom(foregroundColor: AppColors.error)
                : null,
            child: Text(confirmText ?? 'Confirm'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Show a loading dialog.
  static void showLoading({String? message}) {
    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: AppSizes.spacing16),
              Expanded(
                child: Text(message ?? 'Loading...'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Hide the loading dialog.
  static void hideLoading() {
    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return;

    Navigator.of(context).pop();
  }

  /// Show a success dialog.
  static Future<void> showSuccess({
    String? title,
    required String message,
    VoidCallback? onDismiss,
  }) async {
    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            const SizedBox(width: AppSizes.spacing8),
            Text(title ?? 'Success'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show an error dialog.
  static Future<void> showError({
    String? title,
    required String message,
    VoidCallback? onRetry,
  }) async {
    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: AppColors.error),
            const SizedBox(width: AppSizes.spacing8),
            Text(title ?? 'Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  /// Show a bottom sheet.
  static Future<T?> showBottomSheet<T>({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
  }) async {
    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return null;

    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.radiusLg),
        ),
      ),
      builder: (context) => child,
    );
  }

  /// Show a custom dialog.
  static Future<T?> showCustomDialog<T>({
    required Widget child,
    bool barrierDismissible = true,
  }) async {
    final context = AppRoutes.navigatorKey.currentContext;
    if (context == null) return null;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => child,
    );
  }
}
