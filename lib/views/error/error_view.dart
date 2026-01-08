import 'package:flutter/material.dart';
import 'package:flutter_starter_template/core/constants/app_colors.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';
import 'package:flutter_starter_template/shared/widgets/custom_button.dart';

/// Error view for displaying errors with retry option.
class ErrorView extends StatelessWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ErrorView({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSizes.paddingScreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              Container(
                padding: const EdgeInsets.all(AppSizes.spacing24),
                decoration: BoxDecoration(
                  color: AppColors.errorLight.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSizes.spacing32),

              // Title
              Text(
                title ?? 'Oops! Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing12),

              // Message
              Text(
                message ?? 'An unexpected error occurred. Please try again.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.spacing32),

              // Retry Button
              if (onRetry != null)
                CustomButton(
                  text: 'Try Again',
                  onPressed: onRetry!,
                  width: 200,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 404 Not Found view.
class NotFoundView extends StatelessWidget {
  final VoidCallback? onGoHome;

  const NotFoundView({super.key, this.onGoHome});

  @override
  Widget build(BuildContext context) {
    return ErrorView(
      icon: Icons.search_off,
      title: 'Page Not Found',
      message: 'The page you are looking for does not exist.',
      onRetry: onGoHome,
    );
  }
}
