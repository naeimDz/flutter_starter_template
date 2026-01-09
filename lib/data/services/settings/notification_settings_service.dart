import 'package:flutter_starter_template/core/utils/result.dart';
import 'package:flutter_starter_template/data/repositories/settings/settings_repository.dart';

/// Notification preferences model.
class NotificationPreferences {
  final bool pushEnabled;
  final bool emailEnabled;
  final bool marketingEnabled;

  const NotificationPreferences({
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.marketingEnabled = false,
  });

  Map<String, dynamic> toJson() => {
        'push_enabled': pushEnabled,
        'email_enabled': emailEnabled,
        'marketing_enabled': marketingEnabled,
      };

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      pushEnabled: json['push_enabled'] as bool? ?? true,
      emailEnabled: json['email_enabled'] as bool? ?? true,
      marketingEnabled: json['marketing_enabled'] as bool? ?? false,
    );
  }

  NotificationPreferences copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? marketingEnabled,
  }) {
    return NotificationPreferences(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      marketingEnabled: marketingEnabled ?? this.marketingEnabled,
    );
  }
}

/// Service for managing notification settings.
class NotificationSettingsService {
  final SettingsRepository _repo;

  NotificationSettingsService({required SettingsRepository repository})
      : _repo = repository;

  static const String _domain = 'notifications';

  /// Get notification preferences.
  Future<Result<NotificationPreferences>> getPreferences() async {
    try {
      final result = await _repo.getSettings(_domain);
      if (result.isFailure) return Result.failure(result.error!);

      if (result.data == null || result.data!.isEmpty) {
        return Result.success(const NotificationPreferences());
      }

      return Result.success(NotificationPreferences.fromJson(result.data!));
    } catch (e) {
      return Result.failure('Failed to load notification preferences: $e');
    }
  }

  /// Save notification preferences.
  Future<Result<void>> savePreferences(NotificationPreferences prefs) async {
    try {
      return await _repo.saveSettings(_domain, prefs.toJson());
    } catch (e) {
      return Result.failure('Failed to save notification preferences: $e');
    }
  }
}
