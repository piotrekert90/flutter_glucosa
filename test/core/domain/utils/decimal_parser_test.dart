import 'package:flutter_glucosa/core/domain/utils/decimal_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DecimalParser', () {
    test('parses dot-separated decimals', () {
      expect(DecimalParser.parse('5.5'), 5.5);
    });

    test('parses comma-separated decimals identically', () {
      expect(DecimalParser.parse('5,5'), 5.5);
    });

    test('trims surrounding whitespace', () {
      expect(DecimalParser.parse('  7.2  '), 7.2);
    });

    test('parses integers and negative values', () {
      expect(DecimalParser.parse('120'), 120.0);
      expect(DecimalParser.parse('-3,25'), -3.25);
    });

    test('returns null for empty or invalid input', () {
      expect(DecimalParser.parse(''), isNull);
      expect(DecimalParser.parse('   '), isNull);
      expect(DecimalParser.parse('abc'), isNull);
      expect(DecimalParser.parse('12.3.4'), isNull);
    });
  });
}
