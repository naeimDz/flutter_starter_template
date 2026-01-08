import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_starter_template/core/constants/app_strings.dart';

/// Type-safe wrapper for SharedPreferences.
///
/// Provides convenient methods for common storage operations.
class StorageService {
  final SharedPreferences prefs;

  StorageService({required this.prefs});

  // ==================== Generic Methods ====================

  /// Get string value.
  String? getString(String key) => prefs.getString(key);

  /// Set string value.
  Future<bool> setString(String key, String value) =>
      prefs.setString(key, value);

  /// Get int value.
  int? getInt(String key) => prefs.getInt(key);

  /// Set int value.
  Future<bool> setInt(String key, int value) => prefs.setInt(key, value);

  /// Get double value.
  double? getDouble(String key) => prefs.getDouble(key);

  /// Set double value.
  Future<bool> setDouble(String key, double value) =>
      prefs.setDouble(key, value);

  /// Get bool value.
  bool? getBool(String key) => prefs.getBool(key);

  /// Set bool value.
  Future<bool> setBool(String key, bool value) => prefs.setBool(key, value);

  /// Get string list.
  List<String>? getStringList(String key) => prefs.getStringList(key);

  /// Set string list.
  Future<bool> setStringList(String key, List<String> value) =>
      prefs.setStringList(key, value);

  /// Remove a key.
  Future<bool> remove(String key) => prefs.remove(key);

  /// Check if key exists.
  bool containsKey(String key) => prefs.containsKey(key);

  /// Clear all data.
  Future<bool> clear() => prefs.clear();

  // ==================== Auth Token Methods ====================

  /// Get access token.
  Future<String?> getAccessToken() async {
    return getString(AppStrings.keyAccessToken);
  }

  /// Set access token.
  Future<void> setAccessToken(String token) async {
    await setString(AppStrings.keyAccessToken, token);
  }

  /// Get refresh token.
  Future<String?> getRefreshToken() async {
    return getString(AppStrings.keyRefreshToken);
  }

  /// Set refresh token.
  Future<void> setRefreshToken(String token) async {
    await setString(AppStrings.keyRefreshToken, token);
  }

  /// Clear auth tokens.
  Future<void> clearTokens() async {
    await remove(AppStrings.keyAccessToken);
    await remove(AppStrings.keyRefreshToken);
  }

  /// Check if user is logged in (has access token).
  bool get isLoggedIn => containsKey(AppStrings.keyAccessToken);

  // ==================== User Methods ====================

  /// Get user ID.
  String? getUserId() => getString(AppStrings.keyUserId);

  /// Set user ID.
  Future<void> setUserId(String id) async {
    await setString(AppStrings.keyUserId, id);
  }

  /// Clear user data.
  Future<void> clearUserData() async {
    await remove(AppStrings.keyUserId);
    await clearTokens();
  }

  // ==================== App Settings ====================

  /// Check if onboarding is complete.
  bool get isOnboardingComplete =>
      getBool(AppStrings.keyOnboardingComplete) ?? false;

  /// Set onboarding complete.
  Future<void> setOnboardingComplete(bool value) async {
    await setBool(AppStrings.keyOnboardingComplete, value);
  }

  /// Get saved locale.
  String? getLocale() => getString(AppStrings.keyLocale);

  /// Set locale.
  Future<void> setLocale(String locale) async {
    await setString(AppStrings.keyLocale, locale);
  }
}
