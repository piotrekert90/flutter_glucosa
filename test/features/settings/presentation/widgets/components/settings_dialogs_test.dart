import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/features/settings/presentation/widgets/components/edit_name_dialog.dart';
import 'package:flutter_glucosa/features/settings/presentation/widgets/components/selection_dialog.dart';
import 'package:flutter_glucosa/features/settings/presentation/widgets/components/target_range_dialog.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';

Widget _buildTestApp(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('EditNameDialog', () {
    testWidgets('renders initial name and saves updated value', (tester) async {
      String? savedName;

      await tester.pumpWidget(
        _buildTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => EditNameDialog.show(
                context,
                currentName: 'John',
                onSaved: (val) => savedName = val,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Edit Name'), findsOneWidget);
      expect(find.text('John'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '  Jane Doe  ');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(savedName, 'Jane Doe');
      expect(find.text('Edit Name'), findsNothing);
    });

    testWidgets('cancels without saving', (tester) async {
      String? savedName;

      await tester.pumpWidget(
        _buildTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => EditNameDialog.show(
                context,
                currentName: 'John',
                onSaved: (val) => savedName = val,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(savedName, isNull);
      expect(find.text('Edit Name'), findsNothing);
    });
  });

  group('SelectionDialog', () {
    testWidgets('renders options and selects an option', (tester) async {
      GlucoseUnit? selectedUnit;

      await tester.pumpWidget(
        _buildTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => SelectionDialog.show<GlucoseUnit>(
                context,
                title: 'Select Unit',
                currentValue: GlucoseUnit.mgDl,
                items: GlucoseUnit.values,
                itemLabel: (u) => u.displayName,
                onSelected: (val) => selectedUnit = val,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Select Unit'), findsOneWidget);
      expect(find.text('mg/dL'), findsOneWidget);
      expect(find.text('mmol/L'), findsOneWidget);

      await tester.tap(find.text('mmol/L'));
      await tester.pumpAndSettle();

      expect(selectedUnit, GlucoseUnit.mmolL);
      expect(find.text('Select Unit'), findsNothing);
    });
  });

  group('TargetRangeDialog', () {
    testWidgets('selects predefined preset and saves', (tester) async {
      GlucoseTargetRange? savedRange;

      await tester.pumpWidget(
        _buildTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => TargetRangeDialog.show(
                context,
                currentRange: const GlucoseTargetRange.ada(),
                preferredUnit: GlucoseUnit.mgDl,
                onSaved: (val) => savedRange = val,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Target Glucose Range'), findsOneWidget);

      // Select AACE
      await tester.tap(find.text('AACE (110–140 mg/dL)'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(savedRange?.preset, GlucoseRangePreset.aace);
      expect(savedRange?.minMgDl, 110);
      expect(savedRange?.maxMgDl, 140);
    });

    testWidgets('allows custom target range with validation', (tester) async {
      GlucoseTargetRange? savedRange;

      await tester.pumpWidget(
        _buildTestApp(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => TargetRangeDialog.show(
                context,
                currentRange: const GlucoseTargetRange.ada(),
                preferredUnit: GlucoseUnit.mgDl,
                onSaved: (val) => savedRange = val,
              ),
              child: const Text('Open'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Tap Custom
      await tester.tap(find.text('Custom'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(2));

      // Enter invalid: min >= max
      await tester.enterText(find.byType(TextField).first, '150');
      await tester.enterText(find.byType(TextField).last, '100');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(
        find.text('Minimum must be less than maximum and greater than zero'),
        findsOneWidget,
      );
      expect(savedRange, isNull);

      // Enter valid: min=85, max=160
      await tester.enterText(find.byType(TextField).first, '85');
      await tester.enterText(find.byType(TextField).last, '160');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(savedRange?.preset, GlucoseRangePreset.custom);
      expect(savedRange?.minMgDl, 85);
      expect(savedRange?.maxMgDl, 160);
    });
  });
}
