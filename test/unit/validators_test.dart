import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_template/core/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('Required validator returns error message for null/empty', () {
      final validator = Validators.required(message: 'Required');
      expect(validator(null), 'Required');
      expect(validator(''), 'Required');
      expect(validator('  '), 'Required');
      expect(validator('text'), null);
    });

    test('Email validator returns error for invalid emails', () {
      final validator = Validators.email(message: 'Invalid');
      expect(validator('invalid-email'), 'Invalid');
      expect(validator('test@example'), 'Invalid');
      expect(validator('test@example.com'), null);
    });

    test('MinLength validator returns error for short strings', () {
      final validator = Validators.minLength(5, message: 'Too short');
      expect(validator('abc'), 'Too short');
      expect(validator('abcde'), null);
    });

    test('Compose combining multiple validators', () {
      final validator = Validators.compose([
        Validators.required(message: 'Required'),
        Validators.email(message: 'Invalid'),
      ]);

      expect(validator(null), 'Required');
      expect(validator('not-an-email'), 'Invalid');
      expect(validator('test@example.com'), null);
    });
  });
}
