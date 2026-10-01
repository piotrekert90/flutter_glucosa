import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/presentation/shared/format.dart';

void main() {
  group('formatTodoDate', () {
    test('formats DateTime into yyyy-MM-dd HH:mm pattern', () {
      final date = DateTime(2026, 9, 18, 14, 30);
      expect(formatTodoDate(date), '2026-09-18 14:30');
    });

    test(
      'pads single-digit month, day, hour, and minute with leading zeros',
      () {
        final date = DateTime(2026, 1, 5, 9, 7);
        expect(formatTodoDate(date), '2026-01-05 09:07');
      },
    );
  });
}
