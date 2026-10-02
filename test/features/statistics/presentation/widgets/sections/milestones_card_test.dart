import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/statistics/domain/entities/milestone.dart';
import 'package:flutter_glucosa/features/statistics/presentation/widgets/components/milestone_badge.dart';
import 'package:flutter_glucosa/features/statistics/presentation/widgets/components/milestones_gallery_sheet.dart';
import 'package:flutter_glucosa/features/statistics/presentation/widgets/sections/milestones_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget(List<Milestone> milestones) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: MilestonesCard(milestones: milestones),
        ),
      ),
    );
  }

  group('MilestonesCard', () {
    testWidgets('renders preview items and opens gallery on tap', (
      tester,
    ) async {
      final milestones = MilestoneType.values.map((type) {
        return Milestone(
          type: type,
          isUnlocked:
              type == MilestoneType.firstReading ||
              type == MilestoneType.streak7,
          progress: type == MilestoneType.firstReading
              ? 1.0
              : (type == MilestoneType.streak7 ? 1.0 : 0.2),
        );
      }).toList();

      await tester.pumpWidget(buildTestWidget(milestones));
      await tester.pumpAndSettle();

      expect(find.byType(MilestonesCard), findsOneWidget);
      expect(find.text('Milestones'), findsOneWidget);
      expect(find.text('2 / 15'), findsOneWidget);

      // Verify preview badges (up to 4)
      expect(find.byType(MilestoneBadge), findsNWidgets(4));

      // Tap card header to open full gallery sheet
      await tester.tap(find.text('Milestones'));
      await tester.pumpAndSettle();

      expect(find.byType(MilestonesGallerySheet), findsOneWidget);
      expect(find.text('Achievements Gallery'), findsOneWidget);
    });
  });
}
