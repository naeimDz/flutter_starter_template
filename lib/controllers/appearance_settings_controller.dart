import 'package:flutter/material.dart';
import 'package:flutter_starter_template/controllers/base_controller.dart';
import 'package:flutter_starter_template/data/services/settings/appearance_settings_service.dart';

/// Thin controller for appearance settings (theme only).
class AppearanceSettingsController extends BaseController {
  final AppearanceSettingsService _service;

  AppearanceSettingsController({
    required AppearanceSettingsService service,
  }) : _service = service;

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadThemeMode() async {
    final result = await _service.getThemeMode();
    if (result.isSuccess && result.data != null) {
      _themeMode = result.data!;
      notifyListeners();
    } else {
      // Fallback on error
      _themeMode = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    await _service.setThemeMode(mode);
  }
}
