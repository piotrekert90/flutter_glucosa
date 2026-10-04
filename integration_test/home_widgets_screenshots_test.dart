@Tags(['screenshot'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'helpers/screenshot_test_helper.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final effectiveLocales = getEffectiveLocales();
  final prefix = getScreenshotPrefix();

  setUpAll(() async {
    await binding.convertFlutterSurfaceToImage();
  });

  group('07_home_widgets Screenshot Generator', () {
    for (final localeCode in effectiveLocales) {
      for (final isDark in [false, true]) {
        final themeLabel = isDark ? 'dark' : 'light';
        final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
        final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
        final locale = Locale(localeCode);

        // 07_home_widgets / 01_widget_2x1
        testWidgets(
          'Capture 07_home_widgets/01_widget_2x1 [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                theme: theme,
                themeMode: themeMode,
                home: ScreenshotDeviceFrame(
                  isDark: isDark,
                  child: Scaffold(
                    body: WidgetPreviewCanvas(
                      isDark: isDark,
                      child: HomeWidget2x1View(
                        glucoseValue: 112,
                        unit: 'mg/dL',
                        trendText: 'In Range',
                        isDark: isDark,
                      ),
                    ),
                  ),
                ),
              ),
            );

            await tester.pumpAndSettle();

            await binding.takeScreenshot(
              '$prefix$localeCode/07_home_widgets/01_widget_2x1_$themeLabel',
            );
          },
          tags: 'screenshot',
        );

        // 07_home_widgets / 02_widget_full
        testWidgets(
          'Capture 07_home_widgets/02_widget_full [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                theme: theme,
                themeMode: themeMode,
                home: ScreenshotDeviceFrame(
                  isDark: isDark,
                  child: Scaffold(
                    body: WidgetPreviewCanvas(
                      isDark: isDark,
                      child: HomeWidgetFullView(
                        glucoseValue: 112,
                        unit: 'mg/dL',
                        trendText: '-4 mg/dL',
                        statusText: 'In Range (70–180)',
                        lastEntryText: 'Today, 09:41',
                        estimatedHbA1c: '6.4%',
                        isDark: isDark,
                      ),
                    ),
                  ),
                ),
              ),
            );

            await tester.pumpAndSettle();

            await binding.takeScreenshot(
              '$prefix$localeCode/07_home_widgets/02_widget_full_$themeLabel',
            );
          },
          tags: 'screenshot',
        );
      }
    }
  });
}

/// Canvas wrapper to present home widgets on an Android home screen layout.
class WidgetPreviewCanvas extends StatelessWidget {
  final Widget child;
  final bool isDark;

  const WidgetPreviewCanvas({
    super.key,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFF0284C7);

    return DecoratedBox(
      decoration: BoxDecoration(color: bgColor),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: child),
          Positioned(
            left: 16,
            right: 16,
            bottom: 36,
            child: _HomeDock(isDark: isDark),
          ),
        ],
      ),
    );
  }
}

/// Bottom dock with 4 app icons mimicking an Android home screen dock.
class _HomeDock extends StatelessWidget {
  final bool isDark;

  const _HomeDock({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.28)
            : Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _DockIcon(
            icon: Icons.call,
            bgColor: Color(0xFF34A853),
            iconColor: Colors.white,
          ),
          _DockIcon(
            icon: Icons.chat_bubble,
            bgColor: Color(0xFF4285F4),
            iconColor: Colors.white,
          ),
          _DockIcon(
            icon: Icons.language,
            bgColor: Color(0xFFEA4335),
            iconColor: Colors.white,
          ),
          _DockIcon(
            icon: Icons.photo_camera,
            bgColor: Color(0xFFFBBC05),
            iconColor: Color(0xFF202124),
          ),
        ],
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const _DockIcon({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: iconColor, size: 26),
    );
  }
}

/// Visual representation of the compact 2x1 Glucosa home widget.
class HomeWidget2x1View extends StatelessWidget {
  final int glucoseValue;
  final String unit;
  final String trendText;
  final bool isDark;

  const HomeWidget2x1View({
    super.key,
    required this.glucoseValue,
    required this.unit,
    required this.trendText,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cardBg = isDark ? const Color(0xFF1E2128) : const Color(0xFFFFFFFF);
    final borderColor = isDark
        ? const Color(0xFF2E333D)
        : const Color(0xFFE2E4E9);
    final textHeader = isDark
        ? const Color(0xFFC4C7D0)
        : const Color(0xFF44474F);
    const valueGreen = Color(0xFF2E7D32);
    final buttonBg = isDark ? const Color(0xFF2A3140) : const Color(0xFFE8F0FE);
    final buttonIconColor = isDark
        ? const Color(0xFFA8C7FA)
        : const Color(0xFF005BDE);

    return Container(
      width: 336,
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Glucosa • ${l10n.widgetToday}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: textHeader,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$glucoseValue',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: valueGreen,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      unit,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: textHeader,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        trendText,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: valueGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: buttonBg, shape: BoxShape.circle),
            child: Icon(Icons.add, color: buttonIconColor, size: 20),
          ),
        ],
      ),
    );
  }
}

/// Visual representation of the full 3x2 / 4x2 Glucosa home widget.
class HomeWidgetFullView extends StatelessWidget {
  final int glucoseValue;
  final String unit;
  final String trendText;
  final String statusText;
  final String lastEntryText;
  final String estimatedHbA1c;
  final bool isDark;

  const HomeWidgetFullView({
    super.key,
    required this.glucoseValue,
    required this.unit,
    required this.trendText,
    required this.statusText,
    required this.lastEntryText,
    required this.estimatedHbA1c,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cardBg = isDark ? const Color(0xFF1E2128) : const Color(0xFFFFFFFF);
    final borderColor = isDark
        ? const Color(0xFF2E333D)
        : const Color(0xFFE2E4E9);
    final textHeader = isDark
        ? const Color(0xFFC4C7D0)
        : const Color(0xFF44474F);
    const valueGreen = Color(0xFF2E7D32);
    final buttonBg = isDark ? const Color(0xFF2A3140) : const Color(0xFFE8F0FE);
    final buttonIconColor = isDark
        ? const Color(0xFFA8C7FA)
        : const Color(0xFF005BDE);

    return Container(
      width: 348,
      height: 168,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Glucosa • ${l10n.widgetToday}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: textHeader,
                        letterSpacing: 0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$glucoseValue',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: valueGreen,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          unit,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: textHeader,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      lastEntryText,
                      style: TextStyle(
                        fontSize: 11,
                        color: textHeader.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: buttonBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add, color: buttonIconColor, size: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    trendText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: valueGreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2A3140).withValues(alpha: 0.5)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  statusText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: valueGreen,
                  ),
                ),
                Text(
                  'HbA1c: $estimatedHbA1c',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: textHeader,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
