import 'package:flutter/material.dart';
import 'package:flutter_starter_template/views/home/home_view.dart';
import 'package:flutter_starter_template/views/splash/splash_view.dart';
import 'package:flutter_starter_template/views/error/error_view.dart';
import 'package:flutter_starter_template/views/auth/login_view.dart';
import 'package:flutter_starter_template/views/auth/register_view.dart';
import 'package:flutter_starter_template/views/settings/settings_view.dart';
import 'package:flutter_starter_template/views/settings/profile_edit_view.dart';

/// Application routes configuration.
///
/// Centralized routing using Navigator 1.0 with named routes.
class AppRoutes {
  AppRoutes._();

  /// Global navigator key for navigation without context.
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // Route Names
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password'; // Placeholder
  static const String settings = '/settings';
  static const String profileEdit = '/profile/edit';
  static const String error = '/error';

  // For backward compatibility
  static const String initial = splash;

  /// Generate route based on settings.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _buildRoute(
          settings,
          const SplashView(),
        );

      case home:
        return _buildRoute(
          settings,
          const HomeView(),
        );

      case login:
        return _buildRoute(
          settings,
          const LoginView(),
        );

      case register:
        return _buildRoute(
          settings,
          const RegisterView(),
        );

      case AppRoutes.settings:
        return _buildRoute(
          settings,
          const SettingsView(),
        );

      case AppRoutes.profileEdit:
        return _buildRoute(
          settings,
          const ProfileEditView(),
        );

      case error:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          settings,
          ErrorView(
            title: args?['title'] as String?,
            message: args?['message'] as String?,
            onRetry: args?['onRetry'] as VoidCallback?,
          ),
        );

      default:
        return _buildRoute(
          settings,
          NotFoundView(
            onGoHome: () {
              navigatorKey.currentState?.pushNamedAndRemoveUntil(
                home,
                (route) => false,
              );
            },
          ),
        );
    }
  }

  /// Build a MaterialPageRoute with consistent transition.
  static Route<dynamic> _buildRoute(
    RouteSettings settings,
    Widget page, {
    bool fullscreenDialog = false,
  }) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }

  /// Navigate to a named route.
  static Future<T?> navigateTo<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Replace current route with new route.
  static Future<T?> replaceTo<T>(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed<T, dynamic>(
      routeName,
      arguments: arguments,
    );
  }

  /// Navigate to route and remove all previous routes.
  static Future<T?> navigateAndRemoveAll<T>(String routeName,
      {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Go back to previous route.
  static void goBack<T>([T? result]) {
    navigatorKey.currentState!.pop<T>(result);
  }

  /// Check if can go back.
  static bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }
}
