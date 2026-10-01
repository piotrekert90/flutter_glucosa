import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/hba1c_unit.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/hba1c/domain/entities/hba1c_reading.dart';
import 'package:flutter_glucosa/features/hba1c/presentation/widgets/hba1c_reading_card.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

final _testReading = HbA1cReading(
  id: 1,
  readingPercentage: 6.2,
  createdAt: DateTime(2026, 10, 2, 7, 30),
  notes: 'Quarterly checkup',
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
    required HbA1cReading reading,
    VoidCallback? onTap,
    HbA1cUnit unit = HbA1cUnit.percentage,
  }) {
    when(() => mockUserRepo.watch()).thenAnswer(
      (_) => Stream.value(
        UserProfile.defaults().copyWith(preferredHbA1cUnit: unit),
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
          body: HbA1cReadingCard(reading: reading, onTap: onTap),
        ),
      ),
    );
  }

  group('HbA1cReadingCard', () {
    testWidgets('renders reading percentage, unit, status and note', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget(reading: _testReading));
      await tester.pumpAndSettle();

      expect(find.text('6.2'), findsOneWidget);
      expect(find.text('%'), findsOneWidget);
      expect(find.text('Elevated (5.7-6.4%)'), findsOneWidget);
      expect(find.text('Quarterly checkup'), findsOneWidget);
    });

    testWidgets('renders converted mmol/mol when preferred unit is mmol/mol', (
      tester,
    ) async {
      await tester.pumpWidget(
        createWidget(reading: _testReading, unit: HbA1cUnit.mmolMol),
      );
      await tester.pumpAndSettle();

      // 6.2% HbA1c converts to ~44 mmol/mol
      expect(find.text('44'), findsOneWidget);
      expect(find.text('mmol/mol'), findsOneWidget);
    });

    testWidgets('renders high status badge when HbA1c >= 6.5%', (tester) async {
      final highReading = _testReading.copyWith(readingPercentage: 7.2);
      await tester.pumpWidget(createWidget(reading: highReading));
      await tester.pumpAndSettle();

      expect(find.text('High (≥6.5%)'), findsOneWidget);
    });

    testWidgets('renders normal status badge when HbA1c < 5.7%', (
      tester,
    ) async {
      final normalReading = _testReading.copyWith(readingPercentage: 5.4);
      await tester.pumpWidget(createWidget(reading: normalReading));
      await tester.pumpAndSettle();

      expect(find.text('Normal (<5.7%)'), findsOneWidget);
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
