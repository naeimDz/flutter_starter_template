import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_starter_template/core/constants/app_strings.dart';

/// Provider for managing app locale/language.
///
/// Works with easy_localization package for seamless integration.
class LocaleProvider with ChangeNotifier {
  final SharedPreferences prefs;

  LocaleProvider({required this.prefs});

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
  ];

  /// Get saved locale or default.
  Locale getSavedLocale() {
    final localeCode = prefs.getString(AppStrings.keyLocale);
    if (localeCode != null) {
      return Locale(localeCode);
    }
    return supportedLocales.first;
  }

  /// Change app locale.
  Future<void> setLocale(BuildContext context, Locale locale) async {
    await prefs.setString(AppStrings.keyLocale, locale.languageCode);
    if (context.mounted) {
      await context.setLocale(locale);
    }
    notifyListeners();
  }

  /// Get locale display name.
  String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return locale.languageCode;
    }
  }

  /// Check if current locale is RTL.
  bool isRtl(BuildContext context) {
    return context.locale.languageCode == 'ar';
  }
}
