import 'package:flutter/material.dart';
import 'package:flutter_starter_template/core/constants/app_sizes.dart';

/// Empty state widget for showing when there's no content.
///
/// Displays an icon, title, description, and optional action button.
class EmptyState extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? description;
  final String? actionText;
  final VoidCallback? onAction;
  final double? iconSize;

  const EmptyState({
    super.key,
    this.icon,
    required this.title,
    this.description,
    this.actionText,
    this.onAction,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSizes.paddingScreen,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            if (icon != null) ...[
              Icon(
                icon,
                size: iconSize ?? 80,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withOpacity(0.5),
              ),
              const SizedBox(height: AppSizes.spacing24),
            ],

            // Title
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),

            // Description
            if (description != null) ...[
              const SizedBox(height: AppSizes.spacing8),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action Button
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppSizes.spacing24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// No data empty state.
  factory EmptyState.noData({
    String? title,
    String? description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.inbox_outlined,
      title: title ?? 'No Data',
      description: description ?? 'There is no data to display.',
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// No search results empty state.
  factory EmptyState.noResults({
    String? title,
    String? description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.search_off,
      title: title ?? 'No Results',
      description: description ?? 'No results found for your search.',
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// No internet empty state.
  factory EmptyState.noInternet({
    String? title,
    String? description,
    VoidCallback? onRetry,
  }) {
    return EmptyState(
      icon: Icons.wifi_off,
      title: title ?? 'No Internet',
      description: description ?? 'Please check your internet connection.',
      actionText: 'Retry',
      onAction: onRetry,
    );
  }

  /// No favorites empty state.
  factory EmptyState.noFavorites({
    String? title,
    String? description,
  }) {
    return EmptyState(
      icon: Icons.favorite_border,
      title: title ?? 'No Favorites',
      description: description ?? 'Items you favorite will appear here.',
    );
  }

  /// No notifications empty state.
  factory EmptyState.noNotifications({
    String? title,
    String? description,
  }) {
    return EmptyState(
      icon: Icons.notifications_none,
      title: title ?? 'No Notifications',
      description: description ?? 'You\'re all caught up!',
    );
  }
}
