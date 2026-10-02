import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/presentation/extensions/failure_ui_extension.dart';
import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/utils/crash_reporter.dart';
import '../../../../core/integrations/biometrics/biometric_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../onboarding/presentation/extensions/diabetes_type_l10n.dart';
import '../../../calendar/presentation/extensions/first_day_of_week_ui_extension.dart';
import '../providers/user_profile_notifier.dart';
import '../widgets/components/custom_settings_tile.dart';
import '../widgets/components/custom_settings_toggle.dart';
import '../widgets/components/edit_name_dialog.dart';
import '../widgets/components/health_sync_section.dart';
import '../widgets/components/section_header.dart';
import '../widgets/components/selection_dialog.dart';
import '../widgets/components/target_range_dialog.dart';
import '../widgets/components/theme_selection_dialog.dart';
import '../widgets/components/wipe_data_dialog.dart';

/// Presentation widget rendering the user profile and application settings screen.
///
/// Displays clinical preferences (units, target ranges, diabetes type), appearance,
/// notification switches, utility tools, and application info backed by [userProfileProvider].
class SettingsScreen extends ConsumerWidget {
  /// Creates a settings screen widget instance.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.settingsTitle ?? 'Settings')),
      body: profileAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => AppErrorView(
          message: error is Failure && l10n != null
              ? error.toUserMessage(l10n)
              : error.toString(),
          retryLabel: l10n?.tryAgain ?? 'Try again',
          onRetry: () => ref.invalidate(userProfileProvider),
        ),
        data: (profile) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                SectionHeader(label: l10n?.userProfile ?? 'Profile'),
                CustomSettingsTile(
                  icon: Icons.person_outline,
                  title: l10n?.name ?? 'Name',
                  valueText: profile.name.isNotEmpty
                      ? profile.name
                      : (l10n?.notSet ?? 'Not set'),
                  onTap: () => _showEditNameDialog(context, ref, profile.name),
                ),
                CustomSettingsTile(
                  icon: Icons.medical_services_outlined,
                  title: l10n?.diabetesType ?? 'Diabetes Type',
                  valueText: profile.diabetesType.label(l10n),
                  onTap: () => _showDiabetesTypePicker(
                    context,
                    ref,
                    profile.diabetesType,
                  ),
                ),
                const SizedBox(height: 12),
                SectionHeader(label: l10n?.units ?? 'Units'),
                CustomSettingsTile(
                  icon: Icons.speed_outlined,
                  title: l10n?.glucoseUnit ?? 'Glucose Unit',
                  valueText: profile.preferredGlucoseUnit.displayName,
                  onTap: () => _showGlucoseUnitPicker(
                    context,
                    ref,
                    profile.preferredGlucoseUnit,
                  ),
                ),
                CustomSettingsTile(
                  icon: Icons.percent_outlined,
                  title: l10n?.hba1cUnit ?? 'HbA1c Unit',
                  valueText: profile.preferredHbA1cUnit.displayName,
                  onTap: () => _showHbA1cUnitPicker(
                    context,
                    ref,
                    profile.preferredHbA1cUnit,
                  ),
                ),
                CustomSettingsTile(
                  icon: Icons.monitor_weight_outlined,
                  title: l10n?.weightUnit ?? 'Weight Unit',
                  valueText: profile.preferredWeightUnit.displayName,
                  onTap: () => _showWeightUnitPicker(
                    context,
                    ref,
                    profile.preferredWeightUnit,
                  ),
                ),
                const SizedBox(height: 12),
                SectionHeader(label: l10n?.targetRange ?? 'Target Range'),
                CustomSettingsTile(
                  icon: Icons.track_changes_outlined,
                  title: l10n?.targetRange ?? 'Target Range',
                  valueText: _targetRangeLabel(
                    profile.targetRange,
                    profile.preferredGlucoseUnit,
                  ),
                  onTap: () => _showTargetRangeDialog(
                    context,
                    ref,
                    profile.targetRange,
                    profile.preferredGlucoseUnit,
                  ),
                ),
                const SizedBox(height: 12),
                SectionHeader(label: l10n?.appearance ?? 'Appearance'),
                CustomSettingsTile(
                  icon: Icons.palette_outlined,
                  title: l10n?.theme ?? 'Theme',
                  valueText: _themeLabel(l10n, profile.themeMode),
                  onTap: () =>
                      _showThemePicker(context, ref, profile.themeMode),
                ),
                CustomSettingsTile(
                  icon: Icons.calendar_today_outlined,
                  title: l10n?.firstDayOfWeek ?? 'First Day of Week',
                  valueText: profile.firstDayOfWeek.label(l10n),
                  onTap: () => _showFirstDayOfWeekPicker(
                    context,
                    ref,
                    profile.firstDayOfWeek,
                  ),
                ),
                const SizedBox(height: 12),
                CustomSettingsToggle(
                  icon: Icons.notifications_outlined,
                  title: l10n?.notifications ?? 'Notifications',
                  subtitle:
                      l10n?.receivePushNotifications ??
                      'Receive push notifications',
                  value: profile.isNotificationsEnabled,
                  onChanged: (value) async {
                    final (success, failure) = await ref
                        .read(userProfileProvider.notifier)
                        .updateNotificationsEnabled(value);
                    if (!success && context.mounted) {
                      AppSnackBar.show(
                        context,
                        message: failure != null && l10n != null
                            ? failure.toUserMessage(l10n)
                            : (l10n?.failedToUpdatePreferences ??
                                  'Failed to update preferences'),
                        type: SnackBarType.error,
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                SectionHeader(
                  label: l10n?.securitySection ?? 'Security & Privacy',
                ),
                CustomSettingsToggle(
                  icon: Icons.fingerprint,
                  title: l10n?.biometricSettingTitle ?? 'Biometric Lock',
                  subtitle:
                      l10n?.biometricSettingSubtitle ??
                      'Require Face ID, Touch ID, or fingerprint to open the app',
                  value: profile.isBiometricLockEnabled,
                  onChanged: (value) =>
                      _toggleBiometricLock(context, ref, value),
                ),
                CustomSettingsTile(
                  icon: Icons.delete_forever_outlined,
                  title: l10n?.wipeDataTitle ?? 'Wipe All Data',
                  subtitle:
                      l10n?.wipeDataDescription ??
                      'Permanently delete all health records, reminders, and preferences from this device.',
                  onTap: () => _handleWipeData(context, ref),
                ),
                const SizedBox(height: 12),
                SectionHeader(label: l10n?.healthSyncSection ?? 'Health Sync'),
                HealthSyncSection(profile: profile),
                const SizedBox(height: 12),
                SectionHeader(label: l10n?.tools ?? 'Tools'),
                CustomSettingsTile(
                  icon: Icons.alarm_outlined,
                  title: l10n?.reminders ?? 'Reminders',
                  onTap: () => context.push('/reminders'),
                ),
                const SizedBox(height: 12),
                CustomSettingsTile(
                  icon: Icons.file_upload_outlined,
                  title: l10n?.exportData ?? 'Export Data',
                  subtitle:
                      l10n?.exportSubtitle ??
                      'Export measurements to CSV format',
                  onTap: () => context.push('/export'),
                ),
                const SizedBox(height: 12),
                CustomSettingsTile(
                  icon: Icons.calculate_outlined,
                  title: l10n?.hba1cCalculator ?? 'HbA1c Calculator',
                  subtitle:
                      l10n?.hba1cCalculatorSubtitle ??
                      'Calculate estimated HbA1c from average glucose',
                  onTap: () => context.push('/hba1c-calculator'),
                ),
                const SizedBox(height: 12),
                SectionHeader(label: l10n?.about ?? 'About'),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.data?.version ?? '1.0.0';
                    return CustomSettingsTile(
                      icon: Icons.info_outline,
                      title: l10n?.version ?? 'Version',
                      valueText: 'v$version',
                      showChevron: false,
                    );
                  },
                ),
                CustomSettingsTile(
                  icon: Icons.policy_outlined,
                  title: l10n?.privacyPolicy ?? 'Privacy Policy',
                  onTap: () => context.go('/settings/privacy-policy'),
                ),
                CustomSettingsTile(
                  icon: Icons.code_rounded,
                  title: l10n?.licenses ?? 'Licenses',
                  onTap: () => context.go('/settings/licenses'),
                ),
                CustomSettingsTile(
                  icon: Icons.star_outline_rounded,
                  title: l10n?.rateApp ?? 'Rate App',
                  onTap: () => _rateApp(context),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _targetRangeLabel(GlucoseTargetRange range, GlucoseUnit unit) {
    final presetName = range.preset.displayName;
    if (unit == GlucoseUnit.mmolL) {
      final minMmol = GlucoseConverter.mgDlToMmolL(
        range.minMgDl,
      ).toStringAsFixed(1);
      final maxMmol = GlucoseConverter.mgDlToMmolL(
        range.maxMgDl,
      ).toStringAsFixed(1);
      return '$minMmol–$maxMmol mmol/L ($presetName)';
    }
    return '${range.minMgDl}–${range.maxMgDl} mg/dL ($presetName)';
  }

  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    EditNameDialog.show(
      context,
      currentName: currentName,
      onSaved: (newName) async {
        final (success, failure) = await ref
            .read(userProfileProvider.notifier)
            .updateName(newName);
        if (!success && context.mounted) {
          final l10n = AppLocalizations.of(context);
          AppSnackBar.show(
            context,
            message: failure != null && l10n != null
                ? failure.toUserMessage(l10n)
                : (l10n?.failedToUpdatePreferences ??
                      'Failed to update preferences'),
            type: SnackBarType.error,
          );
        }
      },
    );
  }

  void _showDiabetesTypePicker(
    BuildContext context,
    WidgetRef ref,
    DiabetesType currentType,
  ) {
    final l10n = AppLocalizations.of(context);
    SelectionDialog.show<DiabetesType>(
      context,
      title: l10n?.selectDiabetesType ?? 'Select Diabetes Type',
      currentValue: currentType,
      items: DiabetesType.values,
      itemLabel: (type) => type.label(l10n),
      onSelected: (selected) async {
        final (success, failure) = await ref
            .read(userProfileProvider.notifier)
            .updateDiabetesType(selected);
        if (!success && context.mounted) {
          AppSnackBar.show(
            context,
            message: failure != null && l10n != null
                ? failure.toUserMessage(l10n)
                : (l10n?.failedToUpdatePreferences ??
                      'Failed to update preferences'),
            type: SnackBarType.error,
          );
        }
      },
    );
  }

  void _showGlucoseUnitPicker(
    BuildContext context,
    WidgetRef ref,
    GlucoseUnit currentUnit,
  ) {
    final l10n = AppLocalizations.of(context);
    SelectionDialog.show<GlucoseUnit>(
      context,
      title: l10n?.selectGlucoseUnit ?? 'Select Glucose Unit',
      currentValue: currentUnit,
      items: GlucoseUnit.values,
      itemLabel: (unit) => unit.displayName,
      itemSubtitle: (unit) => unit == GlucoseUnit.mgDl
          ? 'Milligrams per deciliter'
          : 'Millimoles per liter',
      onSelected: (selected) async {
        final (success, failure) = await ref
            .read(userProfileProvider.notifier)
            .updateGlucoseUnit(selected);
        if (!success && context.mounted) {
          AppSnackBar.show(
            context,
            message: failure != null && l10n != null
                ? failure.toUserMessage(l10n)
                : (l10n?.failedToUpdatePreferences ??
                      'Failed to update preferences'),
            type: SnackBarType.error,
          );
        }
      },
    );
  }

  void _showHbA1cUnitPicker(
    BuildContext context,
    WidgetRef ref,
    HbA1cUnit currentUnit,
  ) {
    final l10n = AppLocalizations.of(context);
    SelectionDialog.show<HbA1cUnit>(
      context,
      title: l10n?.selectHbA1cUnit ?? 'Select HbA1c Unit',
      currentValue: currentUnit,
      items: HbA1cUnit.values,
      itemLabel: (unit) => unit.displayName,
      itemSubtitle: (unit) =>
          unit == HbA1cUnit.percentage ? 'NGSP (%)' : 'IFCC (mmol/mol)',
      onSelected: (selected) async {
        final (success, failure) = await ref
            .read(userProfileProvider.notifier)
            .updateHbA1cUnit(selected);
        if (!success && context.mounted) {
          AppSnackBar.show(
            context,
            message: failure != null && l10n != null
                ? failure.toUserMessage(l10n)
                : (l10n?.failedToUpdatePreferences ??
                      'Failed to update preferences'),
            type: SnackBarType.error,
          );
        }
      },
    );
  }

  void _showWeightUnitPicker(
    BuildContext context,
    WidgetRef ref,
    WeightUnit currentUnit,
  ) {
    final l10n = AppLocalizations.of(context);
    SelectionDialog.show<WeightUnit>(
      context,
      title: l10n?.selectWeightUnit ?? 'Select Weight Unit',
      currentValue: currentUnit,
      items: WeightUnit.values,
      itemLabel: (unit) => unit.displayName,
      itemSubtitle: (unit) =>
          unit == WeightUnit.kilograms ? 'Kilograms (kg)' : 'Pounds (lbs)',
      onSelected: (selected) async {
        final (success, failure) = await ref
            .read(userProfileProvider.notifier)
            .updateWeightUnit(selected);
        if (!success && context.mounted) {
          AppSnackBar.show(
            context,
            message: failure != null && l10n != null
                ? failure.toUserMessage(l10n)
                : (l10n?.failedToUpdatePreferences ??
                      'Failed to update preferences'),
            type: SnackBarType.error,
          );
        }
      },
    );
  }

  void _showTargetRangeDialog(
    BuildContext context,
    WidgetRef ref,
    GlucoseTargetRange currentRange,
    GlucoseUnit preferredUnit,
  ) {
    TargetRangeDialog.show(
      context,
      currentRange: currentRange,
      preferredUnit: preferredUnit,
      onSaved: (newRange) async {
        final (success, failure) = await ref
            .read(userProfileProvider.notifier)
            .updateTargetRange(newRange);
        if (!success && context.mounted) {
          final l10n = AppLocalizations.of(context);
          AppSnackBar.show(
            context,
            message: failure != null && l10n != null
                ? failure.toUserMessage(l10n)
                : (l10n?.failedToUpdatePreferences ??
                      'Failed to update preferences'),
            type: SnackBarType.error,
          );
        }
      },
    );
  }

  Future<void> _rateApp(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final packageName = packageInfo.packageName;
      final marketUri = Uri.parse('market://details?id=$packageName');
      final webUri = Uri.parse(
        'https://play.google.com/store/apps/details?id=$packageName',
      );

      final launched = await launchUrl(
        marketUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        final webLaunched = await launchUrl(
          webUri,
          mode: LaunchMode.externalApplication,
        );
        if (!webLaunched && context.mounted) {
          AppSnackBar.show(
            context,
            message: l10n?.couldNotOpenStore ?? 'Could not open app store',
            type: SnackBarType.error,
          );
        }
      }
    } catch (error, stack) {
      AppCrashReporter.recordError(
        error,
        stack,
        reason: 'Failed to launch app store review URL',
        fatal: false,
      );
      if (context.mounted) {
        AppSnackBar.show(
          context,
          message: l10n?.couldNotOpenStore ?? 'Could not open app store',
          type: SnackBarType.error,
        );
      }
    }
  }

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    UserThemeMode current,
  ) {
    ThemeSelectionDialog.show(
      context,
      currentMode: current,
      onSelected: (mode) async {
        final (success, failure) = await ref
            .read(userProfileProvider.notifier)
            .updateThemeMode(mode);
        if (!success && context.mounted) {
          final l10n = AppLocalizations.of(context);
          AppSnackBar.show(
            context,
            message: failure != null && l10n != null
                ? failure.toUserMessage(l10n)
                : (l10n?.failedToUpdateThemeMode ??
                      'Failed to update theme mode'),
            type: SnackBarType.error,
          );
        }
      },
    );
  }

  String _themeLabel(AppLocalizations? l10n, UserThemeMode mode) {
    return switch (mode) {
      UserThemeMode.light => l10n?.themeLight ?? 'Light',
      UserThemeMode.dark => l10n?.themeDark ?? 'Dark Mode',
      UserThemeMode.system => l10n?.themeSystem ?? 'System',
    };
  }

  void _showFirstDayOfWeekPicker(
    BuildContext context,
    WidgetRef ref,
    FirstDayOfWeek current,
  ) {
    final l10n = AppLocalizations.of(context);
    SelectionDialog.show<FirstDayOfWeek>(
      context,
      title: l10n?.selectFirstDayOfWeek ?? 'Select First Day of Week',
      currentValue: current,
      items: FirstDayOfWeek.values,
      itemLabel: (item) => item.label(l10n),
      onSelected: (selected) async {
        final (success, failure) = await ref
            .read(userProfileProvider.notifier)
            .updateFirstDayOfWeek(selected);
        if (!success && context.mounted) {
          AppSnackBar.show(
            context,
            message: failure != null && l10n != null
                ? failure.toUserMessage(l10n)
                : (l10n?.failedToUpdatePreferences ??
                      'Failed to update preferences'),
            type: SnackBarType.error,
          );
        }
      },
    );
  }

  Future<void> _toggleBiometricLock(
    BuildContext context,
    WidgetRef ref,
    bool enable,
  ) async {
    final l10n = AppLocalizations.of(context);
    if (enable) {
      final canAuth = await BiometricService.instance.canAuthenticate();
      if (!canAuth) {
        if (context.mounted) {
          AppSnackBar.show(
            context,
            message:
                l10n?.biometricNotAvailable ??
                'Biometric authentication is not available on this device',
            type: SnackBarType.error,
          );
        }
        return;
      }

      final result = await BiometricService.instance.authenticate(
        localizedReason:
            l10n?.biometricReason ??
            'Unlock Glucosa to access your blood glucose records',
        authMessages: l10n != null
            ? BiometricService.createAuthMessages(l10n)
            : const [],
      );

      if (result != BiometricAuthResult.success) {
        if (context.mounted && result != BiometricAuthResult.canceled) {
          final errorMsg = result == BiometricAuthResult.lockedOut
              ? (l10n?.biometricLockedOut ?? 'Biometrics temporarily locked.')
              : (l10n?.biometricNotAvailable ??
                    'Biometric authentication failed');
          AppSnackBar.show(
            context,
            message: errorMsg,
            type: SnackBarType.error,
          );
        }
        return;
      }
    }

    final (success, failure) = await ref
        .read(userProfileProvider.notifier)
        .updateBiometricLockEnabled(enable);
    if (!success && context.mounted) {
      AppSnackBar.show(
        context,
        message: failure != null && l10n != null
            ? failure.toUserMessage(l10n)
            : (l10n?.failedToUpdatePreferences ??
                  'Failed to update preferences'),
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _handleWipeData(BuildContext context, WidgetRef ref) async {
    final confirmed = await WipeDataDialog.show(context);
    if (confirmed == true && context.mounted) {
      final (success, failure) = await ref
          .read(userProfileProvider.notifier)
          .wipeAllData();
      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        if (success) {
          AppSnackBar.show(
            context,
            message:
                l10n?.wipeDataSuccess ??
                'All data has been wiped successfully.',
            type: SnackBarType.success,
          );
        } else {
          AppSnackBar.show(
            context,
            message: failure != null && l10n != null
                ? failure.toUserMessage(l10n)
                : 'Failed to wipe data',
            type: SnackBarType.error,
          );
        }
      }
    }
  }
}
