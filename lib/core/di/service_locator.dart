import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_starter_template/core/config/app_config.dart';
import 'package:flutter_starter_template/data/services/api_service.dart';
import 'package:flutter_starter_template/data/services/storage_service.dart';
import 'package:flutter_starter_template/data/repositories/user_repository.dart';
import 'package:flutter_starter_template/data/repositories/auth/auth_repository.dart';
import 'package:flutter_starter_template/data/repositories/auth/mock_auth_repository.dart';
import 'package:flutter_starter_template/data/repositories/auth/firebase_auth_repository.dart';
import 'package:flutter_starter_template/data/repositories/settings/settings_repository.dart';
import 'package:flutter_starter_template/data/repositories/settings/local_settings_repository.dart';
import 'package:flutter_starter_template/data/services/settings/appearance_settings_service.dart';
import 'package:flutter_starter_template/data/services/settings/notification_settings_service.dart';
import 'package:flutter_starter_template/data/services/profile_service.dart';
import 'package:flutter_starter_template/controllers/home_controller.dart';
import 'package:flutter_starter_template/controllers/auth_controller.dart';
import 'package:flutter_starter_template/controllers/appearance_settings_controller.dart';
import 'package:flutter_starter_template/controllers/notification_settings_controller.dart';
import 'package:flutter_starter_template/controllers/profile_controller.dart';

/// Service Locator using get_it for dependency injection.
final GetIt sl = GetIt.instance;

/// Initialize all dependencies.
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

  // Authentication Repository (Flexible Auth)
  // Swaps implementation based on config
  if (AppConfig.enableFirebase) {
    sl.registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(),
    );
  } else {
    sl.registerLazySingleton<AuthRepository>(
      () => MockAuthRepository(),
    );
  }

  // Other Repositories
  sl.registerLazySingleton<UserRepository>(
    () => UserRepository(apiService: sl<ApiService>()),
  );

  // Settings Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => LocalSettingsRepository(storage: sl<StorageService>()),
  );

  // Settings Services
  sl.registerLazySingleton<AppearanceSettingsService>(
    () => AppearanceSettingsService(repository: sl<SettingsRepository>()),
  );

  sl.registerLazySingleton<NotificationSettingsService>(
    () => NotificationSettingsService(repository: sl<SettingsRepository>()),
  );

  sl.registerLazySingleton<ProfileService>(
    () => ProfileService(
      authRepository: sl<AuthRepository>(),
      storage: sl<StorageService>(),
    ),
  );

  // Controllers (Factory for fresh state)
  sl.registerFactory<HomeController>(
    () => HomeController(userRepository: sl<UserRepository>()),
  );

  sl.registerFactory<AuthController>(
    () => AuthController(authRepository: sl<AuthRepository>()),
  );

  sl.registerFactory<AppearanceSettingsController>(
    () =>
        AppearanceSettingsController(service: sl<AppearanceSettingsService>()),
  );

  sl.registerFactory<NotificationSettingsController>(
    () => NotificationSettingsController(
        service: sl<NotificationSettingsService>()),
  );

  sl.registerFactory<ProfileController>(
    () => ProfileController(service: sl<ProfileService>()),
  );
}

/// Reset all registered instances.
Future<void> resetServiceLocator() async {
  await sl.reset();
}
