/// Centralized API endpoint definitions.
///
/// All API endpoints should be defined here for easy maintenance.
class ApiEndpoints {
  // Base paths
  static const String api = '/api';
  static const String v1 = '$api/v1';

  // Authentication
  static const String auth = '$v1/auth';
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String logout = '$auth/logout';
  static const String refreshToken = '$auth/refresh';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';

  // User
  static const String users = '$v1/users';
  static const String profile = '$users/me';
  static const String updateProfile = '$users/me';

  // Helper to build dynamic endpoints
  static String userById(String id) => '$users/$id';

  // Example: Posts
  static const String posts = '$v1/posts';
  static String postById(String id) => '$posts/$id';
  static String postComments(String postId) => '$posts/$postId/comments';
}
