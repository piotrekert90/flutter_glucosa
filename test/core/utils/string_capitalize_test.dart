import 'package:flutter_riverpod_boilerplate/core/utils/string_capitalize.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CapitalizeX', () {
    test('capitalizes first letter of non-empty string', () {
      expect('hello'.capitalizeFirst(), 'Hello');
      expect('flutter'.capitalizeFirst(), 'Flutter');
      expect('A'.capitalizeFirst(), 'A');
    });

    test('returns empty string unchanged', () {
      expect(''.capitalizeFirst(), '');
    });
  });
}
