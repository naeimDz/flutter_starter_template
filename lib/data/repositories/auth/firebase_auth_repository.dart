import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_starter_template/core/utils/result.dart';
import 'package:flutter_starter_template/data/models/user_model.dart';
import 'package:flutter_starter_template/data/repositories/auth/auth_repository.dart';

/// Firebase Implementation of AuthRepository.
///
/// Uses `firebase_auth` package.
/// Requires 'google-services.json' (Android) and 'GoogleService-Info.plist' (iOS).
class FirebaseAuthRepository implements AuthRepository {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  @override
  Stream<UserModel?> get userStream {
    return _firebaseAuth.authStateChanges().map(_mapFirebaseUser);
  }

  UserModel? _mapFirebaseUser(auth.User? firebaseUser) {
    if (firebaseUser == null) return null;
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? '',
      avatarUrl: firebaseUser.photoURL,
    );
  }

  @override
  Future<Result<UserModel>> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _mapFirebaseUser(credential.user);
      if (user != null) {
        return Result.success(user);
      }
      return Result.failure('User not found');
    } on auth.FirebaseAuthException catch (e) {
      return Result.failure(e.message ?? 'Login failed');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<UserModel>> register(
      String name, String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        await credential.user!.reload();
      }

      final user = _mapFirebaseUser(_firebaseAuth.currentUser);
      if (user != null) {
        return Result.success(user);
      }
      return Result.failure('Registration failed');
    } on auth.FirebaseAuthException catch (e) {
      return Result.failure(e.message ?? 'Registration failed');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<UserModel>> getCurrentUser() async {
    final user = _mapFirebaseUser(_firebaseAuth.currentUser);
    if (user != null) {
      return Result.success(user);
    }
    return Result.failure('No user logged in');
  }
}
