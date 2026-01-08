import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_starter_template/core/config/app_config.dart';

/// Log levels for the application logger.
enum LogLevel { debug, info, warning, error }

/// Custom logger with colored output and configurable log levels.
///
/// Usage:
/// ```dart
/// AppLogger.d('Debug message');
/// AppLogger.i('Info message');
/// AppLogger.w('Warning message');
/// AppLogger.e('Error message', error: e, stackTrace: s);
/// ```
class AppLogger {
  AppLogger._();

  static const String _tag = 'FlutterApp';

  // ANSI color codes for terminal output
  static const String _reset = '\x1B[0m';
  static const String _blue = '\x1B[34m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _red = '\x1B[31m';

  /// Log a debug message
  static void d(String message, {String? tag}) {
    _log(LogLevel.debug, message, tag: tag);
  }

  /// Log an info message
  static void i(String message, {String? tag}) {
    _log(LogLevel.info, message, tag: tag);
  }

  /// Log a warning message
  static void w(String message, {String? tag}) {
    _log(LogLevel.warning, message, tag: tag);
  }

  /// Log an error message
  static void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message,
        tag: tag, error: error, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Skip logging in production unless it's an error
    if (AppConfig.isProd && level != LogLevel.error) {
      return;
    }

    final logTag = tag ?? _tag;
    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    final levelStr = _getLevelString(level);
    final color = _getColor(level);

    final buffer = StringBuffer();
    buffer.write('$color[$timestamp][$logTag][$levelStr] ');
    buffer.write(message);
    buffer.write(_reset);

    if (error != null) {
      buffer.write('\n${_red}Error: $error$_reset');
    }

    if (stackTrace != null) {
      buffer.write('\n${_red}StackTrace: $stackTrace$_reset');
    }

    if (kDebugMode) {
      // Use print in debug mode for better IDE integration
      // ignore: avoid_print
      print(buffer.toString());
    } else {
      // Use developer.log in release mode
      developer.log(
        message,
        name: logTag,
        level: _getLogLevelValue(level),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static String _getLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARN';
      case LogLevel.error:
        return 'ERROR';
    }
  }

  static String _getColor(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return _blue;
      case LogLevel.info:
        return _green;
      case LogLevel.warning:
        return _yellow;
      case LogLevel.error:
        return _red;
    }
  }

  static int _getLogLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}
