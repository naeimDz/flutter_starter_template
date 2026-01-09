import 'package:flutter_starter_template/core/utils/result.dart';
import 'package:flutter_starter_template/data/models/user_model.dart';

/// Abstract contract for Authentication.
///
/// This abstraction allows swapping the underlying implementation
/// (Mock, Firebase, REST API) without affecting the UI or Controllers.
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Result<UserModel>> login(String email, String password);

  /// Register a new account
  Future<Result<UserModel>> register(
      String name, String email, String password);

  /// Sign out the current user
  Future<Result<void>> logout();

  /// Get the currently logged-in user (if any)
  Future<Result<UserModel>> getCurrentUser();

  /// Stream of user changes (for real-time auth state listening)
  Stream<UserModel?> get userStream;
}
