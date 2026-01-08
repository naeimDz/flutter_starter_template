import 'package:flutter/material.dart';

/// Base controller for MVC pattern.
///
/// Provides common functionality:
/// - Loading state management
/// - Error handling
/// - Lifecycle methods
///
/// Extend this class for screen-specific controllers.
abstract class BaseController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDisposed = false;

  /// Whether the controller is currently loading data.
  bool get isLoading => _isLoading;

  /// Current error message, if any.
  String? get errorMessage => _errorMessage;

  /// Whether the controller has an error.
  bool get hasError => _errorMessage != null;

  /// Whether the controller has been disposed.
  bool get isDisposed => _isDisposed;

  /// Set loading state and notify listeners.
  @protected
  void setLoading(bool loading) {
    if (_isDisposed) return;
    _isLoading = loading;
    notifyListeners();
  }

  /// Set error message and notify listeners.
  @protected
  void setError(String? message) {
    if (_isDisposed) return;
    _errorMessage = message;
    notifyListeners();
  }

  /// Clear error message.
  void clearError() {
    setError(null);
  }

  /// Execute an async operation with loading state management.
  ///
  /// Automatically sets loading to true before execution
  /// and false after completion. Handles errors gracefully.
  @protected
  Future<T?> executeAsync<T>(
    Future<T> Function() operation, {
    void Function(T result)? onSuccess,
    void Function(String error)? onError,
  }) async {
    if (_isDisposed) return null;

    setLoading(true);
    clearError();

    try {
      final result = await operation();
      if (!_isDisposed) {
        onSuccess?.call(result);
      }
      return result;
    } catch (e) {
      if (!_isDisposed) {
        final errorMessage = e.toString();
        setError(errorMessage);
        onError?.call(errorMessage);
      }
      return null;
    } finally {
      if (!_isDisposed) {
        setLoading(false);
      }
    }
  }

  /// Initialize the controller.
  /// Override this method to perform initialization logic.
  @mustCallSuper
  Future<void> init() async {}

  /// Safe notify listeners that checks if disposed.
  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
