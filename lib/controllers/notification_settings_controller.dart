import 'package:flutter_starter_template/controllers/base_controller.dart';
import 'package:flutter_starter_template/data/services/settings/notification_settings_service.dart';

/// Thin controller for notification settings.
class NotificationSettingsController extends BaseController {
  final NotificationSettingsService _service;

  NotificationSettingsController({
    required NotificationSettingsService service,
  }) : _service = service;

  NotificationPreferences _preferences = const NotificationPreferences();
  NotificationPreferences get preferences => _preferences;

  Future<void> loadPreferences() async {
    final result = await _service.getPreferences();
    if (result.isSuccess && result.data != null) {
      _preferences = result.data!;
      notifyListeners();
    }
  }

  Future<void> updatePreferences(NotificationPreferences prefs) async {
    _preferences = prefs;
    notifyListeners();

    await _service.savePreferences(prefs);
  }

  Future<void> togglePush(bool value) async {
    await updatePreferences(_preferences.copyWith(pushEnabled: value));
  }

  Future<void> toggleEmail(bool value) async {
    await updatePreferences(_preferences.copyWith(emailEnabled: value));
  }

  Future<void> toggleMarketing(bool value) async {
    await updatePreferences(_preferences.copyWith(marketingEnabled: value));
  }
}
