import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/weight_unit.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_glucosa/features/weight/presentation/widgets/weight_reading_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

final _testReading = WeightReading(
  id: 1,
  readingKg: 75.5,
  createdAt: DateTime(2026, 10, 2, 7, 30),
  notes: 'Morning weigh-in',
);

void main() {
  late MockUserProfileRepository mockUserRepo;

  setUp(() {
    mockUserRepo = MockUserProfileRepository();
    when(
      () => mockUserRepo.watch(),
    ).thenAnswer((_) => Stream.value(UserProfile.defaults()));
    when(
      () => mockUserRepo.get(),
    ).thenAnswer((_) async => UserProfile.defaults());
  });

  Widget createWidget({
    required WeightReading reading,
    VoidCallback? onTap,
    WeightUnit unit = WeightUnit.kilograms,
  }) {
    when(() => mockUserRepo.watch()).thenAnswer(
      (_) => Stream.value(
        UserProfile.defaults().copyWith(preferredWeightUnit: unit),
      ),
    );

    return ProviderScope(
      overrides: [
        userProfileRepositoryProvider.overrideWithValue(mockUserRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: WeightReadingCard(reading: reading, onTap: onTap),
        ),
      ),
    );
  }

  group('WeightReadingCard', () {
    testWidgets('renders reading value, unit and note', (tester) async {
      await tester.pumpWidget(createWidget(reading: _testReading));
      await tester.pumpAndSettle();

      expect(find.text('75.5'), findsOneWidget);
      expect(find.text('kg'), findsOneWidget);
      expect(find.text('Morning weigh-in'), findsOneWidget);
    });

    testWidgets('renders converted lbs when preferred unit is pounds', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidget(reading: _testReading, unit: WeightUnit.pounds),
      );
      await tester.pumpAndSettle();

      // 75.5 kg converts to ~166.4 lbs
      expect(find.text('166.4'), findsOneWidget);
      expect(find.text('lbs'), findsOneWidget);
    });

    testWidgets('invokes onTap callback when card is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createWidget(
          reading: _testReading,
          onTap: () {
            tapped = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Card));
      expect(tapped, isTrue);
    });
  });
}
