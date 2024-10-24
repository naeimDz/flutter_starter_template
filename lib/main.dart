import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Easy Localization
  await EasyLocalization.ensureInitialized();

  // Initialize Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar')
      ], // Add more locales as needed
      path: 'assets/translations', // Folder for localization files
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
      /*child: MultiProvider(
        providers: const [
          // Add your global providers here
        ],
        child: const MyApp(),
      ),*/
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.deepPurple),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates:
          context.localizationDelegates, // Localization delegates
      supportedLocales: context.supportedLocales, // Supported locales
      locale: context.locale, // Current locale
      home: const HomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}
