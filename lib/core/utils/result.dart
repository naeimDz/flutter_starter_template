/// Generic Result class to handle success and failure states.
///
/// This allows repositories to return data or errors in a unified way,
/// independent of the data source (API, Local DB, Firebase).
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result._({this.data, this.error, required this.isSuccess});

  bool get isFailure => !isSuccess;

  factory Result.success(T data) {
    return Result._(data: data, isSuccess: true);
  }

  factory Result.failure(String error) {
    return Result._(error: error, isSuccess: false);
  }
}
