import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:integration_test/integration_test.dart';

import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/blood_pressure/data/providers/blood_pressure_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_glucosa/features/cholesterol/data/providers/cholesterol_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/hba1c/data/providers/hba1c_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/hba1c/domain/entities/hba1c_reading.dart';
import 'package:flutter_glucosa/features/ketones/data/providers/ketone_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/ketones/domain/entities/ketone_reading.dart';
import 'package:flutter_glucosa/features/reminders/domain/entities/reminder.dart';
import 'package:flutter_glucosa/features/reminders/data/providers/reminder_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/weight/data/providers/weight_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';

import '../../test/helpers/fake_blood_pressure_reading_repository.dart';
import '../../test/helpers/fake_cholesterol_reading_repository.dart';
import '../../test/helpers/fake_glucose_reading_repository.dart';
import '../../test/helpers/fake_hba1c_reading_repository.dart';
import '../../test/helpers/fake_ketone_reading_repository.dart';
import '../../test/helpers/fake_reminder_repository.dart';
import '../../test/helpers/fake_user_profile_repository.dart';
import '../../test/helpers/fake_weight_reading_repository.dart';

/// Supported localization languages for screenshot generation matching App Store / Play Store.
const List<String> supportedScreenshotLocales = <String>[
  'en',
  'de',
  'ja',
  'fr',
  'es',
  'pl',
  'pt',
  'nl',
  'it',
  'ko',
];

/// Resolves the device screenshot output directory prefix from `--dart-define`.
String getScreenshotPrefix() {
  const device = String.fromEnvironment(
    'SCREENSHOT_DEVICE',
    defaultValue: 'android/phone',
  );
  return device.isNotEmpty ? '$device/' : '';
}

/// Resolves the effective locales to test against.
List<String> getEffectiveLocales() {
  const localeFilter = String.fromEnvironment(
    'SCREENSHOT_LOCALE',
    defaultValue: '',
  );
  if (localeFilter.isNotEmpty &&
      supportedScreenshotLocales.contains(localeFilter)) {
    return [localeFilter];
  }
  return supportedScreenshotLocales;
}

/// Container holding mock repositories seeded for screenshot testing.
class ScreenshotMockData {
  /// User profile repository.
  final FakeUserProfileRepository userProfileRepo;

  /// Blood glucose readings repository.
  final FakeGlucoseReadingRepository glucoseRepo;

  /// Reminders repository.
  final FakeReminderRepository reminderRepo;

  /// Blood pressure readings repository.
  final FakeBloodPressureReadingRepository bloodPressureRepo;

  /// Cholesterol readings repository.
  final FakeCholesterolReadingRepository cholesterolRepo;

  /// HbA1c readings repository.
  final FakeHbA1cReadingRepository hba1cRepo;

  /// Ketone readings repository.
  final FakeKetoneReadingRepository ketoneRepo;

  /// Weight readings repository.
  final FakeWeightReadingRepository weightRepo;

  /// Creates a [ScreenshotMockData] bundle.
  ScreenshotMockData({
    required this.userProfileRepo,
    required this.glucoseRepo,
    required this.reminderRepo,
    required this.bloodPressureRepo,
    required this.cholesterolRepo,
    required this.hba1cRepo,
    required this.ketoneRepo,
    required this.weightRepo,
  });

  /// Disposes all underlying stream controllers.
  void dispose() {
    userProfileRepo.dispose();
    glucoseRepo.dispose();
    reminderRepo.dispose();
    bloodPressureRepo.dispose();
    cholesterolRepo.dispose();
    hba1cRepo.dispose();
    ketoneRepo.dispose();
    weightRepo.dispose();
  }

  /// Converts the repositories to a list of Riverpod overrides.
  List<Override> toOverrides() {
    return [
      userProfileRepositoryProvider.overrideWithValue(userProfileRepo),
      glucoseReadingRepositoryProvider.overrideWithValue(glucoseRepo),
      reminderRepositoryProvider.overrideWithValue(reminderRepo),
      bloodPressureReadingRepositoryProvider.overrideWithValue(
        bloodPressureRepo,
      ),
      cholesterolReadingRepositoryProvider.overrideWithValue(cholesterolRepo),
      hbA1cReadingRepositoryProvider.overrideWithValue(hba1cRepo),
      ketoneReadingRepositoryProvider.overrideWithValue(ketoneRepo),
      weightReadingRepositoryProvider.overrideWithValue(weightRepo),
    ];
  }
}

/// Generates a realistic 90-entry glucose history across June, July, August, and September 2026.
List<GlucoseReading> generate90MockGlucoseReadings([String localeCode = 'en']) {
  final readings = <GlucoseReading>[];
  int nextId = 1;

  void addReading(DateTime dt, int mgDl, MealContext context, [String? note]) {
    readings.add(
      GlucoseReading(
        id: nextId++,
        readingMgDl: mgDl,
        mealContext: context,
        createdAt: dt,
        notes: note,
      ),
    );
  }

  // September 2026 (Today & Yesterday)
  // Day 2 (Today): Latest reading at 09:41
  addReading(
    DateTime(2026, 9, 2, 9, 41),
    112,
    MealContext.fasting,
    getMockRunNote(localeCode),
  );
  addReading(DateTime(2026, 9, 2, 7, 30), 95, MealContext.fasting);

  // Day 1 (Yesterday)
  addReading(DateTime(2026, 9, 1, 21, 30), 120, MealContext.bedtime);
  addReading(DateTime(2026, 9, 1, 18, 30), 135, MealContext.afterDinner);
  addReading(DateTime(2026, 9, 1, 12, 45), 118, MealContext.afterLunch);
  addReading(DateTime(2026, 9, 1, 8, 0), 98, MealContext.fasting);

  // August 2026 - matching month distribution
  // Day 31
  addReading(DateTime(2026, 8, 31, 8, 30), 102, MealContext.fasting);
  // Day 30
  addReading(DateTime(2026, 8, 30, 8, 15), 98, MealContext.fasting);
  // Day 29
  addReading(DateTime(2026, 8, 29, 8, 20), 110, MealContext.fasting);
  // Day 28
  addReading(DateTime(2026, 8, 28, 8, 10), 105, MealContext.fasting);
  // Day 27: Elevated post-meal reading
  addReading(DateTime(2026, 8, 27, 13, 30), 185, MealContext.afterLunch);
  addReading(DateTime(2026, 8, 27, 8, 30), 108, MealContext.fasting);
  // Day 26: 2 readings with note
  addReading(
    DateTime(2026, 8, 26, 20, 15),
    124,
    MealContext.bedtime,
    getMockRunNote(localeCode),
  );
  addReading(DateTime(2026, 8, 26, 8, 0), 96, MealContext.fasting);
  // Day 25: 4 readings
  addReading(DateTime(2026, 8, 25, 21, 20), 126, MealContext.bedtime);
  addReading(DateTime(2026, 8, 25, 17, 30), 142, MealContext.afterDinner);
  addReading(DateTime(2026, 8, 25, 12, 45), 138, MealContext.afterLunch);
  addReading(DateTime(2026, 8, 25, 8, 15), 101, MealContext.fasting);
  // Day 24: 2 readings
  addReading(DateTime(2026, 8, 24, 20, 45), 115, MealContext.bedtime);
  addReading(DateTime(2026, 8, 24, 8, 15), 94, MealContext.fasting);
  // Day 23
  addReading(DateTime(2026, 8, 23, 8, 45), 106, MealContext.fasting);
  // Day 22: 2 readings
  addReading(DateTime(2026, 8, 22, 19, 30), 128, MealContext.afterDinner);
  addReading(DateTime(2026, 8, 22, 8, 0), 99, MealContext.fasting);
  // Day 21
  addReading(DateTime(2026, 8, 21, 8, 15), 103, MealContext.fasting);
  // Day 20: 2 readings
  addReading(DateTime(2026, 8, 20, 21, 0), 116, MealContext.bedtime);
  addReading(DateTime(2026, 8, 20, 8, 30), 97, MealContext.fasting);
  // Day 19
  addReading(DateTime(2026, 8, 19, 8, 20), 109, MealContext.fasting);
  // Day 18: 3 readings
  addReading(DateTime(2026, 8, 18, 20, 0), 122, MealContext.bedtime);
  addReading(DateTime(2026, 8, 18, 13, 30), 134, MealContext.afterLunch);
  addReading(DateTime(2026, 8, 18, 8, 0), 100, MealContext.fasting);
  // Day 17
  addReading(DateTime(2026, 8, 17, 8, 30), 95, MealContext.fasting);
  // Day 16
  addReading(DateTime(2026, 8, 16, 8, 15), 98, MealContext.fasting);
  // Day 15
  addReading(DateTime(2026, 8, 15, 8, 45), 112, MealContext.fasting);
  // Day 14: 2 readings
  addReading(DateTime(2026, 8, 14, 19, 45), 125, MealContext.afterDinner);
  addReading(DateTime(2026, 8, 14, 8, 15), 97, MealContext.fasting);
  // Day 13: 2 readings
  addReading(DateTime(2026, 8, 13, 20, 30), 130, MealContext.bedtime);
  addReading(DateTime(2026, 8, 13, 8, 0), 104, MealContext.fasting);
  // Day 12
  addReading(DateTime(2026, 8, 12, 8, 15), 102, MealContext.fasting);
  // Day 11
  addReading(DateTime(2026, 8, 11, 8, 20), 114, MealContext.fasting);
  // Day 10
  addReading(DateTime(2026, 8, 10, 8, 10), 108, MealContext.fasting);
  // Day 9
  addReading(DateTime(2026, 8, 9, 8, 30), 111, MealContext.fasting);
  // Day 8
  addReading(DateTime(2026, 8, 8, 8, 15), 96, MealContext.fasting);
  // Day 7
  addReading(DateTime(2026, 8, 7, 8, 30), 99, MealContext.fasting);
  // Day 6
  addReading(DateTime(2026, 8, 6, 8, 15), 118, MealContext.fasting);
  // Day 5
  addReading(DateTime(2026, 8, 5, 8, 30), 120, MealContext.fasting);
  // Day 4
  addReading(DateTime(2026, 8, 4, 8, 10), 125, MealContext.fasting);
  // Day 3
  addReading(DateTime(2026, 8, 3, 8, 20), 129, MealContext.fasting);
  // Day 2
  addReading(DateTime(2026, 8, 2, 8, 15), 131, MealContext.fasting);
  // Day 1
  addReading(DateTime(2026, 8, 1, 8, 30), 135, MealContext.fasting);

  // July & June history (gradual improvement from 145 down to 110 mg/dL)
  for (int d = 1; d <= 48; d++) {
    final date = DateTime(2026, 8, 1, 8, 0).subtract(Duration(days: d));
    final base = 110.0 + (145.0 - 110.0) * d / 48.0;
    final fluctuation = ((d * 7) % 7 - 3) * 2;
    final value = (base + fluctuation).round();
    addReading(
      date,
      value,
      d % 4 == 0 ? MealContext.afterDinner : MealContext.fasting,
      d % 12 == 0 ? getMockRunNote(localeCode) : null,
    );
  }

  // Ensure entries are strictly sorted newest first
  readings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return readings;
}

/// Creates a complete set of mock repositories populated with realistic demo records.
ScreenshotMockData createScreenshotMockData([String localeCode = 'en']) {
  final glucoseReadings = generate90MockGlucoseReadings(localeCode);

  final userProfile = UserProfile(
    name: 'Alex Vance',
    diabetesType: DiabetesType.type2,
    preferredGlucoseUnit: GlucoseUnit.mgDl,
    preferredHbA1cUnit: HbA1cUnit.percentage,
    preferredWeightUnit: WeightUnit.kilograms,
    targetRange: const GlucoseTargetRange.ada(),
    isOnboardingCompleted: true,
    isNotificationsEnabled: true,
    themeMode: UserThemeMode.system,
    isBiometricLockEnabled: false,
    firstDayOfWeek: FirstDayOfWeek.monday,
    isHealthSyncEnabled: true,
    lastHealthSyncAt: DateTime(2026, 9, 2, 9, 30),
  );

  final reminders = [
    const Reminder(
      id: 1,
      label: 'Morning Fasting Check',
      metricType: MetricType.glucose,
      hourOfDay: 8,
      minute: 0,
      isActive: true,
    ),
    const Reminder(
      id: 2,
      label: 'Post-Lunch Check',
      metricType: MetricType.glucose,
      hourOfDay: 14,
      minute: 0,
      isActive: true,
    ),
    const Reminder(
      id: 3,
      label: 'Evening Blood Pressure',
      metricType: MetricType.bloodPressure,
      hourOfDay: 20,
      minute: 0,
      isActive: true,
    ),
  ];

  final bpReadings = [
    BloodPressureReading(
      id: 1,
      systolicMmHg: 122,
      diastolicMmHg: 78,
      createdAt: DateTime(2026, 9, 2, 8, 30),
    ),
    BloodPressureReading(
      id: 2,
      systolicMmHg: 125,
      diastolicMmHg: 80,
      createdAt: DateTime(2026, 9, 1, 8, 30),
    ),
  ];

  final hba1cReadings = [
    HbA1cReading(
      id: 1,
      readingPercentage: 6.4,
      createdAt: DateTime(2026, 8, 15, 10, 0),
    ),
    HbA1cReading(
      id: 2,
      readingPercentage: 6.8,
      createdAt: DateTime(2026, 5, 20, 10, 0),
    ),
  ];

  final ketoneReadings = [
    KetoneReading(
      id: 1,
      readingMmolL: 0.4,
      createdAt: DateTime(2026, 9, 2, 8, 30),
    ),
  ];

  final cholesterolReadings = [
    CholesterolReading(
      id: 1,
      totalMgDl: 185,
      ldlMgDl: 105,
      hdlMgDl: 52,
      createdAt: DateTime(2026, 7, 10, 9, 0),
    ),
  ];

  final weightReadings = [
    WeightReading(
      id: 1,
      readingKg: 78.5,
      createdAt: DateTime(2026, 9, 2, 8, 0),
    ),
    WeightReading(
      id: 2,
      readingKg: 79.0,
      createdAt: DateTime(2026, 8, 25, 8, 0),
    ),
  ];

  return ScreenshotMockData(
    userProfileRepo: FakeUserProfileRepository(initialProfile: userProfile),
    glucoseRepo: FakeGlucoseReadingRepository(initialReadings: glucoseReadings),
    reminderRepo: FakeReminderRepository()..emit(reminders),
    bloodPressureRepo: FakeBloodPressureReadingRepository()..emit(bpReadings),
    cholesterolRepo: FakeCholesterolReadingRepository()
      ..emit(cholesterolReadings),
    hba1cRepo: FakeHbA1cReadingRepository()..emit(hba1cReadings),
    ketoneRepo: FakeKetoneReadingRepository()..emit(ketoneReadings),
    weightRepo: FakeWeightReadingRepository()..emit(weightReadings),
  );
}

/// Prepares the test binding for headless screenshot execution.
Future<ScreenshotMockData> initScreenshotEnvironment(
  IntegrationTestWidgetsFlutterBinding binding, [
  String localeCode = 'en',
]) async {
  await binding.convertFlutterSurfaceToImage();
  return createScreenshotMockData(localeCode);
}

/// Wraps a [child] widget in a fully configured [MaterialApp] with [ScreenshotDeviceFrame].
Widget buildScreenshotAppWrapper({
  required Widget child,
  required Locale locale,
  required bool isDark,
  ScreenshotMockData? mockData,
  List<Override> overrides = const [],
  PreferredSizeWidget? appBar,
  bool includeSystemBars = true,
  bool showNotificationIcon = false,
}) {
  final effectiveOverrides = <Override>[
    if (mockData != null) ...mockData.toOverrides(),
    ...overrides,
  ];

  final content = Scaffold(
    appBar: appBar,
    body: SafeArea(child: child),
  );

  return ProviderScope(
    overrides: effectiveOverrides,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: includeSystemBars
          ? ScreenshotDeviceFrame(
              isDark: isDark,
              showNotificationIcon: showNotificationIcon,
              child: content,
            )
          : content,
    ),
  );
}

/// Device frame that emulates a realistic mobile status bar and bottom gesture navigation pill.
class ScreenshotDeviceFrame extends StatelessWidget {
  /// The underlying page content.
  final Widget child;

  /// Whether the frame is rendered in dark mode.
  final bool isDark;

  /// Whether to display a notification indicator on the status bar.
  final bool showNotificationIcon;

  /// Optional background color override for the status bar overlay.
  final Color? statusBarColor;

  /// Optional background color override for the navigation bar overlay.
  final Color? navigationBarColor;

  /// Creates a [ScreenshotDeviceFrame].
  const ScreenshotDeviceFrame({
    super.key,
    required this.child,
    required this.isDark,
    this.showNotificationIcon = false,
    this.statusBarColor,
    this.navigationBarColor,
  });

  @override
  Widget build(BuildContext context) {
    final fgColor = isDark ? Colors.white : const Color(0xFF1E1E1E);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: const EdgeInsets.only(top: 36.0, bottom: 20.0),
        viewPadding: const EdgeInsets.only(top: 36.0, bottom: 20.0),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // App Content
          child,

          // Mock System Status Bar (Overlay)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 36.0,
            child: IgnorePointer(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  color: statusBarColor ?? Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left side: Time + Notification icon
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '09:41',
                            style: TextStyle(
                              color: fgColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.2,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          if (showNotificationIcon) ...[
                            const SizedBox(width: 6.0),
                            SizedBox(
                              width: 17.0,
                              height: 17.0,
                              child: Image.asset(
                                'assets/icon/app_icon_foreground.png',
                                width: 17.0,
                                height: 17.0,
                                color: fgColor.withValues(alpha: 0.9),
                                colorBlendMode: BlendMode.srcIn,
                                errorBuilder: (context, error, stackTrace) =>
                                    const SizedBox(width: 17.0, height: 17.0),
                              ),
                            ),
                          ],
                        ],
                      ),
                      // Right side: Signal, Wi-Fi, Horizontal Battery
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.signal_cellular_alt,
                            color: fgColor,
                            size: 15.0,
                          ),
                          const SizedBox(width: 6.0),
                          Icon(Icons.wifi, color: fgColor, size: 15.0),
                          const SizedBox(width: 8.0),
                          // Horizontal battery icon
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: fgColor,
                                    width: 1.2,
                                  ),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                padding: const EdgeInsets.all(1.5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: fgColor,
                                    borderRadius: BorderRadius.circular(1.0),
                                  ),
                                ),
                              ),
                              Container(
                                width: 1.5,
                                height: 4.0,
                                decoration: BoxDecoration(
                                  color: fgColor.withValues(alpha: 0.8),
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(1.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Mock Bottom Gesture Navigation Bar (Overlay)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 20.0,
            child: IgnorePointer(
              child: Container(
                color: navigationBarColor ?? Colors.transparent,
                alignment: Alignment.center,
                child: Container(
                  width: 134.0,
                  height: 4.5,
                  decoration: BoxDecoration(
                    color: fgColor.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders a Material 3 bottom sheet container with proper background color,
/// elevation, and top rounded corners to emulate modal bottom sheets in tests.
class ScreenshotBottomSheetContainer extends StatelessWidget {
  /// The child content rendered within the bottom sheet.
  final Widget child;

  /// Creates a [ScreenshotBottomSheetContainer].
  const ScreenshotBottomSheetContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      elevation: 2.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

/// Returns a realistic running/medical note tailored to [localeCode] for screenshot demonstrations.
String getMockRunNote(String localeCode) {
  switch (localeCode) {
    case 'pl':
      return 'Pomiar glukozy na czczo po porannym biegu wokół jeziora (5 km). Samopoczucie bardzo dobre!';
    case 'de':
      return 'Nüchtern-Glukosemessung nach dem morgendlichen Lauf um den See (5 km). Ausgezeichnetes Wohlbefinden!';
    case 'fr':
      return 'Mesure de glycémie à jeun après le jogging matinal autour du lac (5 km). Excellente forme !';
    case 'es':
      return 'Medición de glucosa en ayunas después de correr alrededor del lago (5 km). ¡Sensación genial!';
    case 'pt':
      return 'Medição de glicemia em jejum após a corrida matinal ao redor do lago (5 km). Ótima disposição!';
    case 'it':
      return 'Misurazione della glicemia a digiuno dopo la corsa mattutina intorno al lago (5 km). Ottima forma!';
    case 'nl':
      return 'Nuchtere glucosemeting na de ochtendloop rond het meer (5 km). Voel me geweldig!';
    case 'ja':
      return '湖畔の朝ランニング（5km）後の空腹時血糖値測定。体調はとても良好です！';
    case 'ko':
      return '호수 주변 아침 달리기(5km) 후 공복 혈당 측정. 컨디션 최고입니다!';
    case 'en':
    default:
      return 'Fasting glucose check after morning run around the lake (5 km). Feeling great!';
  }
}
