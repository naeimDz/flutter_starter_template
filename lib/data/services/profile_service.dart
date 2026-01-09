import 'dart:io';
import 'package:flutter_starter_template/core/utils/result.dart';
import 'package:flutter_starter_template/data/models/user_model.dart';
import 'package:flutter_starter_template/data/repositories/auth/auth_repository.dart';
import 'package:flutter_starter_template/data/services/storage_service.dart';

/// Service for managing user profile (separate from authentication).
class ProfileService {
  final AuthRepository _authRepo;
  final StorageService _storage;

  ProfileService({
    required AuthRepository authRepository,
    required StorageService storage,
  })  : _authRepo = authRepository,
        _storage = storage;

  /// Get current user profile.
  Future<Result<UserModel>> getProfile() async {
    return await _authRepo.getCurrentUser();
  }

  /// Update user profile (name, avatar).
  Future<Result<void>> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    try {
      final currentUserResult = await _authRepo.getCurrentUser();
      if (currentUserResult.isFailure) {
        return Result.failure(currentUserResult.error!);
      }

      final currentUser = currentUserResult.data;
      if (currentUser == null) {
        return Result.failure('No user logged in');
      }

      final updatedUser = currentUser.copyWith(
        name: name ?? currentUser.name,
        avatarUrl: avatarUrl ?? currentUser.avatarUrl,
      );

      // For now, just store locally
      // In production, this would call API
      if (updatedUser.name != null) {
        await _storage.setString('user_name', updatedUser.name!);
      }
      if (updatedUser.avatarUrl != null) {
        await _storage.setString('user_avatar', updatedUser.avatarUrl!);
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to update profile: $e');
    }
  }

  /// Upload avatar image.
  Future<Result<String>> uploadAvatar(File image) async {
    try {
      // Validate file size (max 5MB)
      final bytes = await image.length();
      if (bytes > 5 * 1024 * 1024) {
        return Result.failure('Image too large (max 5MB)');
      }

      // Validate file type
      final extension = image.path.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png'].contains(extension)) {
        return Result.failure('Invalid format (use JPG/PNG)');
      }

      // TODO: In production, upload to cloud storage (Firebase Storage, S3, etc.)
      // For now, return local path as placeholder
      final avatarUrl = image.path;

      return Result.success(avatarUrl);
    } catch (e) {
      return Result.failure('Failed to upload avatar: $e');
    }
  }

  /// Remove avatar.
  Future<Result<void>> removeAvatar() async {
    try {
      await _storage.remove('user_avatar');
      return Result.success(null);
    } catch (e) {
      return Result.failure('Failed to remove avatar: $e');
    }
  }
}
