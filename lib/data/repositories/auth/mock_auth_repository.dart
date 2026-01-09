import 'dart:async';

import 'package:flutter_starter_template/core/utils/result.dart';
import 'package:flutter_starter_template/data/models/user_model.dart';
import 'package:flutter_starter_template/data/repositories/auth/auth_repository.dart';

/// Mock implementation of AuthRepository.
///
/// Used for development and testing. Simulates network delays and returns dummy data.
/// Works "out-of-the-box" without any backend configuration.
class MockAuthRepository implements AuthRepository {
  final _userStreamController = StreamController<UserModel?>.broadcast();
  UserModel? _currentUser;

  MockAuthRepository() {
    // Simulate checking for a logged-in user on startup
    Future.delayed(const Duration(milliseconds: 500), () {
      // Uncomment to simulate a persisted user
      // _currentUser = const UserModel(id: '1', email: 'user@example.com', name: 'Demo User');
      _userStreamController.add(_currentUser);
    });
  }

  @override
  Stream<UserModel?> get userStream => _userStreamController.stream;

  @override
  Future<Result<UserModel>> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network

    if (email == 'error@example.com') {
      return Result.failure('Invalid credentials');
    }

    _currentUser = UserModel(
      id: 'mock_123',
      email: email,
      name: 'Mock User',
      avatarUrl: 'https://i.pravatar.cc/300',
    );
    _userStreamController.add(_currentUser);
    return Result.success(_currentUser!);
  }

  @override
  Future<Result<UserModel>> register(
      String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email.contains('taken')) {
      return Result.failure('Email already in use');
    }

    _currentUser = UserModel(
      id: 'mock_456',
      email: email,
      name: name,
    );
    _userStreamController.add(_currentUser);
    return Result.success(_currentUser!);
  }

  @override
  Future<Result<void>> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    _userStreamController.add(null);
    return Result.success(null);
  }

  @override
  Future<Result<UserModel>> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_currentUser != null) {
      return Result.success(_currentUser!);
    }
    return Result.failure('No user logged in');
  }

  void dispose() {
    _userStreamController.close();
  }
}
