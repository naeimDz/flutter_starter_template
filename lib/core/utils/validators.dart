/// Form field validators for common validation scenarios.
///
/// Usage:
/// ```dart
/// TextFormField(
///   validator: Validators.compose([
///     Validators.required(),
///     Validators.email(),
///   ]),
/// )
/// ```
class Validators {
  Validators._();

  /// Validate that field is not empty.
  static String? Function(String?) required({String? message}) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'This field is required';
      }
      return null;
    };
  }

  /// Validate email format.
  static String? Function(String?) email({String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty)
        return null; // Let required() handle empty

      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );

      if (!emailRegex.hasMatch(value)) {
        return message ?? 'Please enter a valid email';
      }
      return null;
    };
  }

  /// Validate minimum length.
  static String? Function(String?) minLength(int length, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (value.length < length) {
        return message ?? 'Must be at least $length characters';
      }
      return null;
    };
  }

  /// Validate maximum length.
  static String? Function(String?) maxLength(int length, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (value.length > length) {
        return message ?? 'Must be at most $length characters';
      }
      return null;
    };
  }

  /// Validate password strength.
  /// Requires: min 8 chars, 1 uppercase, 1 lowercase, 1 number.
  static String? Function(String?) password({String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (value.length < 8) {
        return message ?? 'Password must be at least 8 characters';
      }

      if (!RegExp(r'[A-Z]').hasMatch(value)) {
        return message ?? 'Password must contain at least one uppercase letter';
      }

      if (!RegExp(r'[a-z]').hasMatch(value)) {
        return message ?? 'Password must contain at least one lowercase letter';
      }

      if (!RegExp(r'[0-9]').hasMatch(value)) {
        return message ?? 'Password must contain at least one number';
      }

      return null;
    };
  }

  /// Validate that value matches another value.
  static String? Function(String?) match(String? other, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (value != other) {
        return message ?? 'Values do not match';
      }
      return null;
    };
  }

  /// Validate phone number format.
  static String? Function(String?) phone({String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      // Remove common separators for validation
      final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

      // Accept numbers with optional + prefix, 10-15 digits
      if (!RegExp(r'^\+?\d{10,15}$').hasMatch(cleaned)) {
        return message ?? 'Please enter a valid phone number';
      }
      return null;
    };
  }

  /// Validate URL format.
  static String? Function(String?) url({String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      final urlRegex = RegExp(
        r'^(https?:\/\/)?'
        r'([\da-z\.-]+)\.'
        r'([a-z\.]{2,6})'
        r'([\/\w \.-]*)*\/?$',
        caseSensitive: false,
      );

      if (!urlRegex.hasMatch(value)) {
        return message ?? 'Please enter a valid URL';
      }
      return null;
    };
  }

  /// Validate numeric value.
  static String? Function(String?) numeric({String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (double.tryParse(value) == null) {
        return message ?? 'Please enter a valid number';
      }
      return null;
    };
  }

  /// Validate numeric value is within range.
  static String? Function(String?) range(num min, num max, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      final number = num.tryParse(value);
      if (number == null) {
        return 'Please enter a valid number';
      }

      if (number < min || number > max) {
        return message ?? 'Value must be between $min and $max';
      }
      return null;
    };
  }

  /// Validate with custom regex pattern.
  static String? Function(String?) pattern(RegExp regex, {String? message}) {
    return (String? value) {
      if (value == null || value.isEmpty) return null;

      if (!regex.hasMatch(value)) {
        return message ?? 'Invalid format';
      }
      return null;
    };
  }

  /// Compose multiple validators.
  /// Returns the first error message, or null if all pass.
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
