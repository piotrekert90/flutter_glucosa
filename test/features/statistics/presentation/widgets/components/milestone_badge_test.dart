import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/statistics/domain/entities/milestone.dart';
import 'package:flutter_glucosa/features/statistics/presentation/widgets/components/milestone_badge.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget(Milestone milestone) {
    return MaterialApp(
      theme: AppTheme.lightTheme.copyWith(platform: TargetPlatform.android),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(child: MilestoneBadge(milestone: milestone)),
      ),
    );
  }

  group('MilestoneBadge', () {
    testWidgets(
      'renders unlocked milestone badge and opens detail dialog on tap',
      (tester) async {
        final milestone = Milestone(
          type: MilestoneType.firstReading,
          isUnlocked: true,
          progress: 1.0,
          unlockedDate: DateTime(2026, 10, 1),
        );

        await tester.pumpWidget(buildTestWidget(milestone));
        await tester.pumpAndSettle();

        expect(find.byType(MilestoneBadge), findsOneWidget);
        expect(find.byIcon(Icons.water_drop_outlined), findsOneWidget);

        // Tap badge to open dialog
        await tester.tap(find.byType(MilestoneBadge));
        await tester.pumpAndSettle();

        expect(find.text('First Reading'), findsWidgets);
        expect(find.text('Unlocked on Oct 1, 2026'), findsOneWidget);
        expect(find.text('Close'), findsOneWidget);

        // Tap close button
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        expect(find.text('Close'), findsNothing);
      },
    );

    testWidgets(
      'renders locked milestone badge with progress indicator and dialog',
      (tester) async {
        const milestone = Milestone(
          type: MilestoneType.streak7,
          isUnlocked: false,
          progress: 0.57, // ~4/7 days
        );

        await tester.pumpWidget(buildTestWidget(milestone));
        await tester.pumpAndSettle();

        expect(find.byType(MilestoneBadge), findsOneWidget);
        expect(
          find.byIcon(Icons.local_fire_department_outlined),
          findsOneWidget,
        );
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Tap badge to open dialog
        await tester.tap(find.byType(MilestoneBadge));
        await tester.pumpAndSettle();

        expect(find.text('7-Day Streak'), findsWidgets);
        expect(find.text('57% completed'), findsOneWidget);
        expect(find.byType(LinearProgressIndicator), findsOneWidget);

        // Close dialog
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();
        expect(find.text('Close'), findsNothing);
      },
    );
  });
}
