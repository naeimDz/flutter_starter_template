import 'package:flutter_starter_template/controllers/base_controller.dart';
import 'package:flutter_starter_template/data/models/user_model.dart';
import 'package:flutter_starter_template/data/repositories/user_repository.dart';

/// Controller for the Home screen.
///
/// Manages:
/// - User data loading
/// - Screen state and interactions
class HomeController extends BaseController {
  final UserRepository userRepository;

  HomeController({required this.userRepository});

  UserModel? _user;
  int _counter = 0;

  /// Current user.
  UserModel? get user => _user;

  /// Counter value for demo.
  int get counter => _counter;

  /// Whether user data is loaded.
  bool get hasUser => _user != null;

  @override
  Future<void> init() async {
    await super.init();
    // Load initial data if needed
    // await loadUser();
  }

  /// Load current user profile.
  Future<void> loadUser() async {
    await executeAsync(
      () async {
        final result = await userRepository.getProfile();
        if (result.isSuccess) {
          _user = result.data;
        } else {
          throw Exception(result.error);
        }
      },
      onSuccess: (_) {
        // User loaded successfully
      },
      onError: (error) {
        // Handle error
      },
    );
  }

  /// Refresh user data.
  Future<void> refreshUser() async {
    await loadUser();
  }

  /// Increment counter (demo method).
  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  /// Decrement counter (demo method).
  void decrementCounter() {
    if (_counter > 0) {
      _counter--;
      notifyListeners();
    }
  }

  /// Reset counter (demo method).
  void resetCounter() {
    _counter = 0;
    notifyListeners();
  }

  /// Clear user data.
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
