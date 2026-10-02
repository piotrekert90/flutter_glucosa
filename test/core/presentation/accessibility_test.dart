import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_glucosa/core/presentation/widgets/app_empty_view.dart';
import 'package:flutter_glucosa/features/hba1c/presentation/screens/hba1c_calculator_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';

import '../../helpers/fake_user_profile_repository.dart';

void main() {
  group('Accessibility Guidelines Audit', () {
    late FakeUserProfileRepository fakeProfileRepo;

    setUp(() {
      fakeProfileRepo = FakeUserProfileRepository();
    });

    tearDown(() {
      fakeProfileRepo.dispose();
    });

    testWidgets(
      'SettingsScreen meets labeled and tap target accessibility guidelines',
      (tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
            ],
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: SettingsScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));

        handle.dispose();
      },
    );

    testWidgets(
      'HbA1cCalculatorScreen input fields meet labeled accessibility guideline',
      (tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
            ],
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: HbA1cCalculatorScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

        handle.dispose();
      },
    );

    testWidgets('AppEmptyView meets text contrast guideline', (tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmptyView(
              icon: Icons.inbox_outlined,
              title: 'Empty State Title',
              description:
                  'This is an accessible description text with high contrast.',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(tester, meetsGuideline(textContrastGuideline));

      handle.dispose();
    });
  });
}
