import 'package:flutter_riverpod_boilerplate/features/settings/domain/entities/user_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserPreferences', () {
    test(
      'defaults() creates preferences with system theme and notifications enabled',
      () {
        final prefs = UserPreferences.defaults();

        expect(prefs.themeMode, UserThemeMode.system);
        expect(prefs.isNotificationsEnabled, isTrue);
      },
    );

    test(
      'copyWith updates specified fields and preserves unprovided fields',
      () {
        final initial = UserPreferences.defaults();

        final updatedTheme = initial.copyWith(themeMode: UserThemeMode.dark);
        expect(updatedTheme.themeMode, UserThemeMode.dark);
        expect(updatedTheme.isNotificationsEnabled, isTrue);

        final updatedNotifications = initial.copyWith(
          isNotificationsEnabled: false,
        );
        expect(updatedNotifications.themeMode, UserThemeMode.system);
        expect(updatedNotifications.isNotificationsEnabled, isFalse);

        final updatedBoth = initial.copyWith(
          themeMode: UserThemeMode.light,
          isNotificationsEnabled: false,
        );
        expect(updatedBoth.themeMode, UserThemeMode.light);
        expect(updatedBoth.isNotificationsEnabled, isFalse);
      },
    );

    test('supports value equality and hashCode consistency', () {
      const prefs1 = UserPreferences(
        themeMode: UserThemeMode.dark,
        isNotificationsEnabled: true,
      );
      const prefs2 = UserPreferences(
        themeMode: UserThemeMode.dark,
        isNotificationsEnabled: true,
      );
      const prefs3 = UserPreferences(
        themeMode: UserThemeMode.light,
        isNotificationsEnabled: true,
      );

      expect(prefs1, equals(prefs2));
      expect(prefs1.hashCode, equals(prefs2.hashCode));

      expect(prefs1, isNot(equals(prefs3)));
      expect(prefs1, isNot(equals('other_type')));
    });

    test('UserThemeMode enum contains expected values', () {
      expect(
        UserThemeMode.values,
        containsAll([
          UserThemeMode.light,
          UserThemeMode.dark,
          UserThemeMode.system,
        ]),
      );
    });
  });
}
