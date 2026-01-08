import 'package:dio/dio.dart';
import 'package:flutter_starter_template/core/config/app_config.dart';
import 'package:flutter_starter_template/core/utils/logger.dart';
import 'package:flutter_starter_template/data/services/storage_service.dart';

/// Result wrapper for API responses.
class ApiResult<T> {
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResult({this.data, this.error, this.statusCode});

  bool get isSuccess => error == null && data != null;
  bool get isError => error != null;
}

/// HTTP API service using Dio.
///
/// Features:
/// - Automatic auth token injection
/// - Request/response logging
/// - Error handling with meaningful messages
/// - Retry support
class ApiService {
  late final Dio _dio;
  final StorageService storageService;

  ApiService({required this.storageService}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: Duration(seconds: AppConfig.apiTimeout),
        receiveTimeout: Duration(seconds: AppConfig.apiTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await storageService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Log request
          if (AppConfig.enableLogging) {
            AppLogger.i(
              '→ ${options.method} ${options.path}',
              tag: 'API',
            );
            if (options.data != null) {
              AppLogger.d('Request Data: ${options.data}', tag: 'API');
            }
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response
          if (AppConfig.enableLogging) {
            AppLogger.i(
              '← ${response.statusCode} ${response.requestOptions.path}',
              tag: 'API',
            );
          }

          return handler.next(response);
        },
        onError: (error, handler) async {
          // Log error
          AppLogger.e(
            '✗ ${error.response?.statusCode ?? 'N/A'} ${error.requestOptions.path}',
            tag: 'API',
            error: error.message,
          );

          // Handle 401 - Token refresh
          if (error.response?.statusCode == 401) {
            // TODO: Implement token refresh logic
            // final refreshed = await _refreshToken();
            // if (refreshed) {
            //   return handler.resolve(await _retry(error.requestOptions));
            // }
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// Parse error message from DioException.
  String _parseError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'Network error. Please check your connection.';
      case DioExceptionType.badResponse:
        final data = error.response?.data;
        if (data is Map<String, dynamic>) {
          return data['message'] ?? data['error'] ?? 'Server error occurred.';
        }
        return 'Server error occurred.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// GET request.
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      final data =
          fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResult(data: data, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult(
          error: _parseError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }

  /// POST request.
  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      final result =
          fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResult(data: result, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult(
          error: _parseError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }

  /// PUT request.
  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      final result =
          fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResult(data: result, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult(
          error: _parseError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }

  /// PATCH request.
  Future<ApiResult<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      final result =
          fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResult(data: result, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult(
          error: _parseError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }

  /// DELETE request.
  Future<ApiResult<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response =
          await _dio.delete(path, queryParameters: queryParameters);
      final data =
          fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResult(data: data, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult(
          error: _parseError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }

  /// Upload file with multipart form data.
  Future<ApiResult<T>> uploadFile<T>(
    String path, {
    required String filePath,
    required String fieldName,
    Map<String, dynamic>? extraData,
    T Function(dynamic)? fromJson,
    void Function(int, int)? onProgress,
  }) async {
    try {
      final formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(filePath),
        if (extraData != null) ...extraData,
      });

      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onProgress,
      );

      final data =
          fromJson != null ? fromJson(response.data) : response.data as T;
      return ApiResult(data: data, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResult(
          error: _parseError(e), statusCode: e.response?.statusCode);
    } catch (e) {
      return ApiResult(error: e.toString());
    }
  }
}
