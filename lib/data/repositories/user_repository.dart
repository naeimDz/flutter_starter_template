import 'package:flutter_starter_template/core/config/api_endpoints.dart';
import 'package:flutter_starter_template/data/models/user_model.dart';
import 'package:flutter_starter_template/data/services/api_service.dart';

/// Repository for user-related data operations.
///
/// Abstracts data source (API, local DB, cache) from controllers.
class UserRepository {
  final ApiService apiService;

  UserRepository({required this.apiService});

  /// Get current user profile.
  Future<ApiResult<UserModel>> getProfile() async {
    return await apiService.get<UserModel>(
      ApiEndpoints.profile,
      fromJson: (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Get user by ID.
  Future<ApiResult<UserModel>> getUserById(String id) async {
    return await apiService.get<UserModel>(
      ApiEndpoints.userById(id),
      fromJson: (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Update user profile.
  Future<ApiResult<UserModel>> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;

    return await apiService.patch<UserModel>(
      ApiEndpoints.updateProfile,
      data: data,
      fromJson: (data) => UserModel.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Login with email and password.
  Future<ApiResult<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    return await apiService.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  /// Register new user.
  Future<ApiResult<Map<String, dynamic>>> register({
    required String email,
    required String password,
    String? name,
  }) async {
    return await apiService.post<Map<String, dynamic>>(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        if (name != null) 'name': name,
      },
    );
  }

  /// Logout.
  Future<ApiResult<void>> logout() async {
    return await apiService.post<void>(ApiEndpoints.logout);
  }

  /// Request password reset.
  Future<ApiResult<void>> forgotPassword(String email) async {
    return await apiService.post<void>(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }

  /// Reset password with token.
  Future<ApiResult<void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return await apiService.post<void>(
      ApiEndpoints.resetPassword,
      data: {
        'token': token,
        'password': newPassword,
      },
    );
  }
}
