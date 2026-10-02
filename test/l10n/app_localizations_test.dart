import 'package:flutter/widgets.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocalizations locales', () {
    test('supports ten locales', () {
      final codes = AppLocalizations.supportedLocales
          .map((l) => l.languageCode)
          .toSet();
      expect(
        codes,
        {'de', 'en', 'es', 'fr', 'it', 'ja', 'ko', 'nl', 'pl', 'pt'},
      );
    });

    test('formats plural and parameterized messages in every locale', () {
      for (final locale in AppLocalizations.supportedLocales) {
        final l10n = lookupAppLocalizations(locale);

        // Plural messages must not throw for 0/1/many.
        for (final count in [0, 1, 5]) {
          expect(() => l10n.exportMatchingRecords(count), returnsNormally);
          expect(() => l10n.csvImportValidRows(count), returnsNormally);
          expect(() => l10n.csvImportSuccess(count), returnsNormally);
          expect(() => l10n.streakDays(count), returnsNormally);
          expect(() => l10n.readingsCountPill(count), returnsNormally);
        }

        // Parameterized messages must interpolate without throwing.
        expect(
          () => l10n.onboardingStepOf(3, 9),
          returnsNormally,
        );
        expect(
          () => l10n.healthSyncTitle('Health Connect'),
          returnsNormally,
        );
        expect(
          () => l10n.healthSyncSuccess(2, 4),
          returnsNormally,
        );
        expect(
          () => l10n.milestonesUnlocked(3, 10),
          returnsNormally,
        );
        expect(
          () => l10n.calendarDaySemantics('Sep 20', 2),
          returnsNormally,
        );
      }
    });
  });
}
