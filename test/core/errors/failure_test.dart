import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod_boilerplate/core/errors/failure.dart';

void main() {
  group('Failure classes', () {
    test('DatabaseFailure holds message correctly', () {
      const failure = DatabaseFailure('DB error');
      expect(failure.message, 'DB error');
    });

    test('NotFoundFailure holds message correctly', () {
      const failure = NotFoundFailure('Not found');
      expect(failure.message, 'Not found');
    });

    test('NetworkFailure holds message correctly', () {
      const failure = NetworkFailure('Network error');
      expect(failure.message, 'Network error');
    });

    test('UnauthorizedFailure holds message correctly', () {
      const failure = UnauthorizedFailure('Unauthorized');
      expect(failure.message, 'Unauthorized');
    });

    test('ValidationFailure holds message and field errors correctly', () {
      const failure = ValidationFailure(
        'Validation failed',
        fieldErrors: {'email': 'Invalid email'},
      );
      expect(failure.message, 'Validation failed');
      expect(failure.fieldErrors['email'], 'Invalid email');
    });
  });

  group('FailureUserMessage extension', () {
    test('DatabaseFailure returns message as userMessage', () {
      const failure = DatabaseFailure('Isar unique constraint violated');
      expect(failure.userMessage, 'Isar unique constraint violated');
    });
  });
}
