import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_starter_template/data/services/api_service.dart';
import 'package:flutter_starter_template/data/services/storage_service.dart';
import 'package:flutter_starter_template/data/repositories/user_repository.dart';
import 'package:flutter_starter_template/controllers/home_controller.dart';

/// Service Locator using get_it for dependency injection.
///
/// This provides a clean way to manage dependencies without
/// passing them through widget constructors.
///
/// Usage:
/// ```dart
/// final apiService = sl<ApiService>();
/// ```
final GetIt sl = GetIt.instance;

/// Initialize all dependencies.
/// Call this in main() before runApp().
Future<void> setupServiceLocator() async {
  // External Dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // Services (Singletons)
  sl.registerLazySingleton<StorageService>(
    () => StorageService(prefs: sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<ApiService>(
    () => ApiService(storageService: sl<StorageService>()),
  );

  // Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepository(apiService: sl<ApiService>()),
  );

  // Controllers (Factory - new instance each time)
  sl.registerFactory<HomeController>(
    () => HomeController(userRepository: sl<UserRepository>()),
  );
}

/// Reset all registered instances.
/// Useful for testing or logout scenarios.
Future<void> resetServiceLocator() async {
  await sl.reset();
}
