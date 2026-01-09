import 'dart:convert';
import 'package:flutter_starter_template/core/utils/result.dart';
import 'package:flutter_starter_template/data/repositories/settings/settings_repository.dart';
import 'package:flutter_starter_template/data/services/storage_service.dart';

/// Local implementation of SettingsRepository using SharedPreferences.
class LocalSettingsRepository implements SettingsRepository {
  final StorageService _storage;

  LocalSettingsRepository({required StorageService storage})
      : _storage = storage;

  static const String _keyPrefix = 'settings_';

  String _getDomainKey(String domain) => '$_keyPrefix$domain';

  @override
  Future<Result<Map<String, dynamic>>> getSettings(String domain) async {
    try {
      final key = _getDomainKey(domain);
      final jsonString = _storage.getString(key);

      if (jsonString == null) {
        return Result.success({});
      }

      final data = json.decode(jsonString) as Map<String, dynamic>;
      return Result.success(data);
    } catch (e) {
      return Result.failure('Failed to load settings for $domain: $e');
    }
  }

  @override
  Future<Result<void>> saveSettings(
    String domain,
    Map<String, dynamic> data,
  ) async {
    try {
      final key = _getDomainKey(domain);
      final jsonString = json.encode(data);
      await _storage.setString(key, jsonString);
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to save settings for $domain: $e');
    }
  }

  @override
  Future<Result<void>> clearSettings(String domain) async {
    try {
      final key = _getDomainKey(domain);
      await _storage.remove(key);
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to clear settings for $domain: $e');
    }
  }

  @override
  Future<Result<void>> clearAll() async {
    try {
      // Get all keys and remove those starting with our prefix
      final allKeys = _storage.prefs.getKeys();
      for (final key in allKeys) {
        if (key.startsWith(_keyPrefix)) {
          await _storage.remove(key);
        }
      }
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to clear all settings: $e');
    }
  }
}
