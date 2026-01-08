/// Application environment configuration.
///
/// Use `--dart-define=ENV=prod` to set environment at build time.
/// Example: `flutter run --dart-define=ENV=dev`
enum Environment { dev, staging, prod }

class AppConfig {
  static const String _envKey =
      String.fromEnvironment('ENV', defaultValue: 'dev');

  /// Current environment
  static Environment get environment {
    switch (_envKey) {
      case 'prod':
        return Environment.prod;
      case 'staging':
        return Environment.staging;
      default:
        return Environment.dev;
    }
  }

  /// Whether the app is running in development mode
  static bool get isDev => environment == Environment.dev;

  /// Whether the app is running in production mode
  static bool get isProd => environment == Environment.prod;

  /// Base API URL based on environment
  static String get baseUrl {
    switch (environment) {
      case Environment.prod:
        return 'https://api.yourapp.com';
      case Environment.staging:
        return 'https://staging-api.yourapp.com';
      case Environment.dev:
        return 'https://dev-api.yourapp.com';
    }
  }

  /// API timeout in seconds
  static const int apiTimeout = 30;

  /// Enable/disable logging based on environment
  static bool get enableLogging => !isProd;

  /// App name
  static const String appName = 'Flutter Starter Template';

  /// App version (should match pubspec.yaml)
  static const String appVersion = '1.0.0';
}
