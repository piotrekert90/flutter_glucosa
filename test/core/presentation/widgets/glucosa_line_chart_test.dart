import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_chart_theme.dart';
import 'package:flutter_glucosa/core/presentation/widgets/glucosa_line_chart.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _spots = [FlSpot(0, 110), FlSpot(1, 150), FlSpot(2, 130)];

void main() {
  group('AppChartTheme', () {
    test('exposes grid, gradient and limit tokens', () {
      const scheme = ColorScheme.light();

      expect(
        AppChartTheme.gridLineColor(scheme),
        equals(scheme.outlineVariant.withValues(alpha: 0.35)),
      );
      expect(AppChartTheme.lineGradient(Colors.blue).colors, hasLength(2));
      expect(AppChartTheme.areaGradient(Colors.blue).colors, hasLength(2));
      expect(AppChartTheme.dashPattern, equals([4, 4]));
    });
  });

  group('GlucosaLineChart', () {
    testWidgets('renders LineChart with series data and limit lines', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: GlucosaLineChart(
              series: [ChartLineSeries(spots: _spots, color: Colors.blue)],
              xLabels: ['08:00', '12:00', '18:00'],
              limitLines: [
                ChartLimitLine(y: 70, color: Colors.green),
                ChartLimitLine(y: 180, color: Colors.green),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chart = tester.widget<LineChart>(find.byType(LineChart));
      expect(chart.data.lineBarsData, hasLength(1));
      expect(chart.data.lineBarsData.first.spots, equals(_spots));
      expect(chart.data.extraLinesData.horizontalLines, hasLength(2));
      expect(chart.data.lineTouchData.enabled, isTrue);
    });

    testWidgets('renders two series without area fill overlap', (tester) async {
      const secondary = [FlSpot(0, 80), FlSpot(1, 85), FlSpot(2, 82)];

      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: GlucosaLineChart(
              series: [
                ChartLineSeries(spots: _spots, color: Colors.red),
                ChartLineSeries(spots: secondary, color: Colors.blue),
              ],
              xLabels: ['08:00', '12:00', '18:00'],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chart = tester.widget<LineChart>(find.byType(LineChart));
      expect(chart.data.lineBarsData, hasLength(2));
      for (final bar in chart.data.lineBarsData) {
        expect(bar.belowBarData.show, isFalse);
      }
    });

    testWidgets('renders nothing when all series are empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: GlucosaLineChart(series: [], xLabels: []),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LineChart), findsNothing);
    });

    testWidgets('renders single point without crashing', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: GlucosaLineChart(
              series: [
                ChartLineSeries(spots: [FlSpot(0, 120)], color: Colors.blue),
              ],
              xLabels: ['08:00'],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LineChart), findsOneWidget);
    });
  });
}
