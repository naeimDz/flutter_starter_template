/// Static string constants for the application.
///
/// For translatable strings, use easy_localization instead.
/// This file is for non-translatable strings like API keys, app identifiers, etc.
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'Flutter Starter Template';
  static const String appTagline = 'Build amazing apps faster';

  // Storage Keys
  static const String keyThemeMode = 'theme_mode';
  static const String keyLocale = 'locale';
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyOnboardingComplete = 'onboarding_complete';

  // Error Messages (fallback when localization fails)
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'Network error. Please check your connection.';
  static const String errorTimeout = 'Request timed out. Please try again.';
  static const String errorUnauthorized =
      'Session expired. Please login again.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorServer = 'Server error. Please try again later.';

  // Validation Messages
  static const String validationRequired = 'This field is required';
  static const String validationEmail = 'Please enter a valid email';
  static const String validationPassword =
      'Password must be at least 8 characters';
  static const String validationPasswordMatch = 'Passwords do not match';
  static const String validationPhone = 'Please enter a valid phone number';

  // Date Formats
  static const String dateFormatShort = 'MMM d, y';
  static const String dateFormatLong = 'MMMM d, y';
  static const String dateFormatFull = 'EEEE, MMMM d, y';
  static const String timeFormat = 'h:mm a';
  static const String dateTimeFormat = 'MMM d, y h:mm a';

  // Placeholder Text
  static const String placeholderEmail = 'Enter your email';
  static const String placeholderPassword = 'Enter your password';
  static const String placeholderSearch = 'Search...';
}
