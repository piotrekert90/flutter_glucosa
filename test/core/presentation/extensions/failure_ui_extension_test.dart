import 'package:flutter_riverpod_boilerplate/core/errors/failure.dart';
import 'package:flutter_riverpod_boilerplate/core/presentation/extensions/failure_ui_extension.dart';
import 'package:flutter_riverpod_boilerplate/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalizedFailureUserMessage extension', () {
    final l10n = AppLocalizationsEn();

    test('maps NotFoundFailure to l10n.errorNotFound', () {
      const Failure failure = NotFoundFailure('missing');
      expect(failure.toUserMessage(l10n), l10n.errorNotFound);
    });

    test('maps DatabaseFailure to l10n.errorDatabase', () {
      const Failure failure = DatabaseFailure('db error');
      expect(failure.toUserMessage(l10n), l10n.errorDatabase);
    });

    test('maps NetworkFailure to l10n.errorNetwork', () {
      const Failure failure = NetworkFailure('network error');
      expect(failure.toUserMessage(l10n), l10n.errorNetwork);
    });

    test('maps UnauthorizedFailure to l10n.errorUnauthorized', () {
      const Failure failure = UnauthorizedFailure('session expired');
      expect(failure.toUserMessage(l10n), l10n.errorUnauthorized);
    });

    test('maps ValidationFailure to l10n.errorValidation', () {
      const Failure failure = ValidationFailure('validation error');
      expect(failure.toUserMessage(l10n), l10n.errorValidation);
    });
  });
}
