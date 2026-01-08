import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter_template/core/di/service_locator.dart';
import 'package:flutter_starter_template/core/routes/routes.dart';
import 'package:flutter_starter_template/core/theme/app_theme.dart';
import 'package:flutter_starter_template/providers/locale_provider.dart';
import 'package:flutter_starter_template/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Easy Localization
  await EasyLocalization.ensureInitialized();

  // Setup Dependency Injection
  await setupServiceLocator();

  // Get SharedPreferences instance (already registered in service locator)
  final prefs = sl<SharedPreferences>();

  runApp(
    EasyLocalization(
      supportedLocales: LocaleProvider.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          // SharedPreferences
          Provider<SharedPreferences>.value(value: prefs),

          // Theme Provider
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(prefs: prefs),
          ),

          // Locale Provider
          ChangeNotifierProvider<LocaleProvider>(
            create: (_) => LocaleProvider(prefs: prefs),
          ),

          // Add more global providers here
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      // Debug Banner
      debugShowCheckedModeBanner: false,

      // App Title
      title: 'Flutter Starter Template',

      // Theme Configuration
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.getThemeMode(),

      // Localization Configuration
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,

      // Routing Configuration
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      navigatorKey: AppRoutes.navigatorKey,
    );
  }
}
