import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter_template/core/config/app_config.dart';
import 'package:flutter_starter_template/core/di/service_locator.dart';
import 'package:flutter_starter_template/core/routes/routes.dart';
import 'package:flutter_starter_template/core/theme/app_theme.dart';
import 'package:flutter_starter_template/providers/locale_provider.dart';
import 'package:flutter_starter_template/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Easy Localization
    await EasyLocalization.ensureInitialized();

    // Initialize Firebase (if enabled)
    if (AppConfig.enableFirebase) {
      await Firebase.initializeApp();
    }

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
  } catch (e, stackTrace) {
    debugPrint('App Initialization Error: $e');
    debugPrint('Stack Trace: $stackTrace');

    // Run a minimal error app if initialization fails
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'Failed to initialize app',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(e.toString(), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
