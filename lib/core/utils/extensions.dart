import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// String extensions for common operations.
extension StringExtension on String {
  /// Capitalize the first letter of the string.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize the first letter of each word.
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Check if string is a valid email.
  bool get isEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Check if string is a valid phone number.
  bool get isPhone {
    final phoneRegex = RegExp(r'^\+?[\d\s-]{10,}$');
    return phoneRegex.hasMatch(this);
  }

  /// Check if string is a valid URL.
  bool get isUrl {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    return urlRegex.hasMatch(this);
  }

  /// Check if string contains only numbers.
  bool get isNumeric => RegExp(r'^\d+$').hasMatch(this);

  /// Remove all whitespace from string.
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Truncate string to specified length with ellipsis.
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Convert string to nullable int.
  int? toIntOrNull() => int.tryParse(this);

  /// Convert string to nullable double.
  double? toDoubleOrNull() => double.tryParse(this);
}

/// DateTime extensions for formatting and manipulation.
extension DateTimeExtension on DateTime {
  /// Format date as 'Jan 1, 2024'.
  String get formatShort => DateFormat.yMMMd().format(this);

  /// Format date as 'January 1, 2024'.
  String get formatLong => DateFormat.yMMMMd().format(this);

  /// Format date as 'Monday, January 1, 2024'.
  String get formatFull => DateFormat.yMMMMEEEEd().format(this);

  /// Format time as '1:30 PM'.
  String get formatTime => DateFormat.jm().format(this);

  /// Format date and time as 'Jan 1, 2024 1:30 PM'.
  String get formatDateTime => '${formatShort} ${formatTime}';

  /// Format as relative time (e.g., '2 hours ago', 'in 3 days').
  String get timeAgo {
    final difference = DateTime.now().difference(this);

    if (difference.isNegative) {
      // Future date
      final absDiff = difference.abs();
      if (absDiff.inDays > 0) return 'in ${absDiff.inDays} days';
      if (absDiff.inHours > 0) return 'in ${absDiff.inHours} hours';
      if (absDiff.inMinutes > 0) return 'in ${absDiff.inMinutes} minutes';
      return 'in a moment';
    }

    if (difference.inDays > 365)
      return '${(difference.inDays / 365).floor()} years ago';
    if (difference.inDays > 30)
      return '${(difference.inDays / 30).floor()} months ago';
    if (difference.inDays > 0) return '${difference.inDays} days ago';
    if (difference.inHours > 0) return '${difference.inHours} hours ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes} minutes ago';
    return 'just now';
  }

  /// Check if date is today.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Check if date is tomorrow.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Get start of day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day (23:59:59).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
}

/// BuildContext extensions for quick access to theme and media query.
extension BuildContextExtension on BuildContext {
  /// Get current theme.
  ThemeData get theme => Theme.of(this);

  /// Get current color scheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get current text theme.
  TextTheme get textTheme => theme.textTheme;

  /// Get media query data.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size.
  Size get screenSize => mediaQuery.size;

  /// Get screen width.
  double get screenWidth => screenSize.width;

  /// Get screen height.
  double get screenHeight => screenSize.height;

  /// Get safe area padding.
  EdgeInsets get padding => mediaQuery.padding;

  /// Get view insets (keyboard, etc.).
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Check if keyboard is visible.
  bool get isKeyboardVisible => viewInsets.bottom > 0;

  /// Check if dark mode is enabled.
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Get current orientation.
  Orientation get orientation => mediaQuery.orientation;

  /// Check if device is in landscape mode.
  bool get isLandscape => orientation == Orientation.landscape;

  /// Check if device is in portrait mode.
  bool get isPortrait => orientation == Orientation.portrait;

  /// Check if screen is mobile size (< 600).
  bool get isMobile => screenWidth < 600;

  /// Check if screen is tablet size (600-1024).
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// Check if screen is desktop size (>= 1024).
  bool get isDesktop => screenWidth >= 1024;

  /// Show a snackbar with message.
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Hide current snackbar.
  void hideSnackBar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }
}

/// Nullable extensions.
extension NullableExtension<T> on T? {
  /// Return value if not null, otherwise return fallback.
  T orElse(T fallback) => this ?? fallback;

  /// Apply function if not null.
  R? let<R>(R Function(T) transform) =>
      this != null ? transform(this as T) : null;
}

/// List extensions.
extension ListExtension<T> on List<T> {
  /// Get first element or null if empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last element or null if empty.
  T? get lastOrNull => isEmpty ? null : last;

  /// Get element at index or null if out of bounds.
  T? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
