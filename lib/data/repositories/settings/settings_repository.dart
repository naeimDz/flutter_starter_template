import 'package:flutter_starter_template/core/utils/result.dart';

/// Abstract repository for settings persistence.
///
/// Both Local and Remote implementations MUST support these methods
/// with identical signatures to ensure swappability.
abstract class SettingsRepository {
  /// Get settings for a specific domain (e.g., 'appearance', 'notifications').
  Future<Result<Map<String, dynamic>>> getSettings(String domain);

  /// Save settings for a specific domain.
  Future<Result<void>> saveSettings(
    String domain,
    Map<String, dynamic> data,
  );

  /// Clear settings for a specific domain.
  Future<Result<void>> clearSettings(String domain);

  /// Clear all settings (use with caution).
  Future<Result<void>> clearAll();
}
