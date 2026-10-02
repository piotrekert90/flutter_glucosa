import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/statistics/domain/entities/milestone.dart';
import 'package:flutter_glucosa/features/statistics/presentation/widgets/components/milestone_badge.dart';
import 'package:flutter_glucosa/features/statistics/presentation/widgets/components/milestones_gallery_sheet.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget(List<Milestone> milestones) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => MilestonesGallerySheet.show(context, milestones),
            child: const Text('Open Gallery'),
          ),
        ),
      ),
    );
  }

  group('MilestonesGallerySheet', () {
    testWidgets('renders all milestone categories and badges', (tester) async {
      final milestones = MilestoneType.values.map((type) {
        return Milestone(
          type: type,
          isUnlocked: type == MilestoneType.firstReading,
          progress: type == MilestoneType.firstReading ? 1.0 : 0.0,
        );
      }).toList();

      await tester.pumpWidget(buildTestWidget(milestones));
      await tester.pumpAndSettle();

      // Tap button to open sheet
      await tester.tap(find.text('Open Gallery'));
      await tester.pumpAndSettle();

      expect(find.byType(MilestonesGallerySheet), findsOneWidget);
      expect(find.text('Achievements Gallery'), findsOneWidget);
      expect(find.text('1 of 15 unlocked'), findsOneWidget);

      // Verify category headers
      expect(find.text('Clinical Goals'), findsOneWidget);
      expect(find.text('Streaks & Consistency'), findsOneWidget);

      // Verify badges rendered
      expect(find.byType(MilestoneBadge), findsWidgets);

      // Close sheet
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.byType(MilestonesGallerySheet), findsNothing);
    });
  });
}
