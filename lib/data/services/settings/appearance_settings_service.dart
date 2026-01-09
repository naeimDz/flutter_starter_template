import 'package:flutter/material.dart';
import 'package:flutter_starter_template/core/utils/result.dart';
import 'package:flutter_starter_template/data/repositories/settings/settings_repository.dart';

/// Service for managing appearance-related settings (theme, language).
class AppearanceSettingsService {
  final SettingsRepository _repo;

  AppearanceSettingsService({required SettingsRepository repository})
      : _repo = repository;

  static const String _domain = 'appearance';
  static const String _keyThemeMode = 'theme_mode';

  /// Get current theme mode.
  Future<Result<ThemeMode>> getThemeMode() async {
    try {
      final result = await _repo.getSettings(_domain);
      if (result.isFailure) return Result.failure(result.error!);

      final mode = result.data?[_keyThemeMode] as String?;
      return Result.success(_parseThemeMode(mode));
    } catch (e) {
      return Result.failure('Failed to load theme mode: $e');
    }
  }

  /// Set theme mode.
  Future<Result<void>> setThemeMode(ThemeMode mode) async {
    try {
      final currentSettings = await _repo.getSettings(_domain);
      final data = currentSettings.data ?? {};
      data[_keyThemeMode] = _serializeThemeMode(mode);

      return await _repo.saveSettings(_domain, data);
    } catch (e) {
      return Result.failure('Failed to save theme mode: $e');
    }
  }

  ThemeMode _parseThemeMode(String? mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _serializeThemeMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
