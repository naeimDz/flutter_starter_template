import 'package:flutter_starter_template/controllers/base_controller.dart';
import 'package:flutter_starter_template/data/models/user_model.dart';
import 'package:flutter_starter_template/data/repositories/auth/auth_repository.dart';

class AuthController extends BaseController {
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepository})
      : _authRepository = authRepository;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  /// Initialize: Check for current user
  Future<void> checkAuthStatus() async {
    await executeAsync(() async {
      final result = await _authRepository.getCurrentUser();
      if (result.isSuccess) {
        _currentUser = result.data;
      } else {
        _currentUser = null;
      }
    });
  }

  Future<bool> login(String email, String password) async {
    final result = await executeAsync<bool>(() async {
      final result = await _authRepository.login(email, password);
      if (result.isSuccess) {
        _currentUser = result.data;
        return true;
      } else {
        throw Exception(result.error);
      }
    });
    return result ?? false;
  }

  Future<bool> register(String name, String email, String password) async {
    final result = await executeAsync<bool>(() async {
      final result = await _authRepository.register(name, email, password);
      if (result.isSuccess) {
        _currentUser = result.data;
        return true;
      } else {
        throw Exception(result.error);
      }
    });
    return result ?? false;
  }

  Future<void> logout() async {
    await executeAsync(() async {
      await _authRepository.logout();
      _currentUser = null;
    });
  }
}
