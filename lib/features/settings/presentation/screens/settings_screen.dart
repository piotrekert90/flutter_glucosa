import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/router/app_routes.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/presentation/extensions/failure_ui_extension.dart';
import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/app_top_bar.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppTopBar(title: l10n.settingsTitle),
      body: profileAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => AppErrorView(
          message: error is Failure
              ? error.toUserMessage(l10n)
              : error.toString(),
          retryLabel: l10n.tryAgain,
          onRetry: () => ref.invalidate(userProfileProvider),
        ),
        data: (profile) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                SectionHeader(label: l10n.userProfile),
                CustomSettingsTile(
                  icon: Icons.person_outline,
                  title: l10n.name,
                  valueText: profile.name.isNotEmpty
                      ? profile.name
                      : l10n.notSet,
                  onTap: () => _showEditNameDialog(context, ref, profile.name),
                ),
                CustomSettingsTile(
                  icon: Icons.medical_services_outlined,
                  title: l10n.diabetesType,
                  valueText: profile.diabetesType.label(l10n),
                  onTap: () => _showDiabetesTypePicker(
                    context,
                    ref,
                    profile.diabetesType,
                  ),
                ),
                const SizedBox(height: 12),
                SectionHeader(label: l10n.units),
                CustomSettingsTile(
                  icon: Icons.speed_outlined,
                  title: l10n.glucoseUnit,
                  valueText: profile.preferredGlucoseUnit.displayName,
                  onTap: () => _showGlucoseUnitPicker(
                    context,
                    ref,
                    profile.preferredGlucoseUnit,
                  ),
                ),
                CustomSettingsTile(
                  icon: Icons.percent_outlined,
                  title: l10n.hba1cUnit,
                  valueText: profile.preferredHbA1cUnit.displayName,
                  onTap: () => _showHbA1cUnitPicker(
                    context,
                    ref,
                    profile.preferredHbA1cUnit,
                  ),
                ),
                CustomSettingsTile(
                  icon: Icons.monitor_weight_outlined,
                  title: l10n.weightUnit,
                  valueText: profile.preferredWeightUnit.displayName,
                  onTap: () => _showWeightUnitPicker(
                    context,
                    ref,
                    profile.preferredWeightUnit,
                  ),
                ),
                const SizedBox(height: 12),
                SectionHeader(label: l10n.targetRange),
                CustomSettingsTile(
                  icon: Icons.track_changes_outlined,
                  title: l10n.targetRange,
                  valueText: _targetRangeLabel(
                    l10n,
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
                SectionHeader(label: l10n.appearance),
                CustomSettingsTile(
                  icon: Icons.palette_outlined,
                  title: l10n.theme,
                  valueText: _themeLabel(l10n, profile.themeMode),
                  onTap: () =>
                      _showThemePicker(context, ref, profile.themeMode),
                ),
                CustomSettingsTile(
                  icon: Icons.calendar_today_outlined,
                  title: l10n.firstDayOfWeek,
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
                  title: l10n.notifications,
                  subtitle: l10n.receivePushNotifications,
                  value: profile.isNotificationsEnabled,
                  onChanged: (value) async {
                    final (success, failure) = await ref
                        .read(userProfileProvider.notifier)
                        .updateNotificationsEnabled(value);
                    if (!success && context.mounted) {
                      AppSnackBar.show(
                        context,
                        message: failure != null
                            ? failure.toUserMessage(l10n)
                            : l10n.failedToUpdatePreferences,
                        type: SnackBarType.error,
                      );
                    }
                  },
                ),
                const SizedBox(height: 12),
                SectionHeader(label: l10n.securitySection),
                CustomSettingsToggle(
                  icon: Icons.fingerprint,
                  title: l10n.biometricSettingTitle,
                  subtitle: l10n.biometricSettingSubtitle,
                  value: profile.isBiometricLockEnabled,
                  onChanged: (value) =>
                      _toggleBiometricLock(context, ref, value),
                ),
                CustomSettingsTile(
                  icon: Icons.delete_forever_outlined,
                  title: l10n.wipeDataTitle,
                  subtitle: l10n.wipeDataDescription,
                  isError: true,
                  onTap: () => _handleWipeData(context, ref),
                ),
                const SizedBox(height: 12),
                SectionHeader(label: l10n.healthSyncSection),
                HealthSyncSection(profile: profile),
                const SizedBox(height: 12),
                SectionHeader(label: l10n.tools),
                CustomSettingsTile(
                  icon: Icons.alarm_outlined,
                  title: l10n.reminders,
                  onTap: () => context.push(AppRoute.reminders.path),
                ),
                const SizedBox(height: 12),
                CustomSettingsTile(
                  icon: Icons.file_upload_outlined,
                  title: l10n.exportData,
                  subtitle: l10n.exportSubtitle,
                  onTap: () => context.push(AppRoute.export.path),
                ),
                const SizedBox(height: 12),
                CustomSettingsTile(
                  icon: Icons.calculate_outlined,
                  title: l10n.hba1cCalculator,
                  subtitle: l10n.hba1cCalculatorSubtitle,
                  onTap: () => context.push(AppRoute.hba1cCalculator.path),
                ),
                const SizedBox(height: 12),
                SectionHeader(label: l10n.about),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }
                    final version = snapshot.data?.version ?? '1.0.0';
                    return CustomSettingsTile(
                      icon: Icons.info_outline,
                      title: l10n.version,
                      valueText: l10n.appVersionLabel(version),
                      showChevron: false,
                    );
                  },
                ),
                CustomSettingsTile(
                  icon: Icons.policy_outlined,
                  title: l10n.privacyPolicy,
                  onTap: () => context.go(
                    '${AppRoute.settings.path}/${AppRoute.privacyPolicy.path}',
                  ),
                ),
                CustomSettingsTile(
                  icon: Icons.code_rounded,
                  title: l10n.licenses,
                  onTap: () => context.go(
                    '${AppRoute.settings.path}/${AppRoute.licenses.path}',
                  ),
                ),
                // Rate-app is Android-only until an App Store listing is wired.
                if (!Platform.isIOS)
                  CustomSettingsTile(
                    icon: Icons.star_outline_rounded,
                    title: l10n.rateApp,
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

  String _targetRangeLabel(
    AppLocalizations l10n,
    GlucoseTargetRange range,
    GlucoseUnit unit,
  ) {
    final presetName = range.preset.displayName;
    if (unit == GlucoseUnit.mmolL) {
      final minMmol = GlucoseConverter.mgDlToMmolL(
        range.minMgDl,
      ).toStringAsFixed(1);
      final maxMmol = GlucoseConverter.mgDlToMmolL(
        range.maxMgDl,
      ).toStringAsFixed(1);
      return l10n.targetRangeValue(
        minMmol,
        maxMmol,
        unit.displayName,
        presetName,
      );
    }
    return l10n.targetRangeValue(
      range.minMgDl.toString(),
      range.maxMgDl.toString(),
      unit.displayName,
      presetName,
    );
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
          final l10n = AppLocalizations.of(context)!;
          AppSnackBar.show(
            context,
            message: failure != null
                ? failure.toUserMessage(l10n)
                : l10n.failedToUpdatePreferences,
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
    final l10n = AppLocalizations.of(context)!;
    SelectionDialog.show<DiabetesType>(
      context,
      title: l10n.selectDiabetesType,
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
            message: failure != null
                ? failure.toUserMessage(l10n)
                : l10n.failedToUpdatePreferences,
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
    final l10n = AppLocalizations.of(context)!;
    SelectionDialog.show<GlucoseUnit>(
      context,
      title: l10n.selectGlucoseUnit,
      currentValue: currentUnit,
      items: GlucoseUnit.values,
      itemLabel: (unit) => unit.displayName,
      itemSubtitle: (unit) => unit == GlucoseUnit.mgDl
          ? (l10n.glucoseUnitMgDlDescription)
          : l10n.glucoseUnitMmolLDescription,
      onSelected: (selected) async {
        final (success, failure) = await ref
            .read(userProfileProvider.notifier)
            .updateGlucoseUnit(selected);
        if (!success && context.mounted) {
          AppSnackBar.show(
            context,
            message: failure != null
                ? failure.toUserMessage(l10n)
                : l10n.failedToUpdatePreferences,
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
    final l10n = AppLocalizations.of(context)!;
    SelectionDialog.show<HbA1cUnit>(
      context,
      title: l10n.selectHbA1cUnit,
      currentValue: currentUnit,
      items: HbA1cUnit.values,
      itemLabel: (unit) => unit.displayName,
      itemSubtitle: (unit) => unit == HbA1cUnit.percentage
          ? (l10n.hba1cUnitNgspDescription)
          : l10n.hba1cUnitIfccDescription,
      onSelected: (selected) async {
        final (success, failure) = await ref
            .read(userProfileProvider.notifier)
            .updateHbA1cUnit(selected);
        if (!success && context.mounted) {
          AppSnackBar.show(
            context,
            message: failure != null
                ? failure.toUserMessage(l10n)
                : l10n.failedToUpdatePreferences,
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
    final l10n = AppLocalizations.of(context)!;
    SelectionDialog.show<WeightUnit>(
      context,
      title: l10n.selectWeightUnit,
      currentValue: currentUnit,
      items: WeightUnit.values,
      itemLabel: (unit) => unit.displayName,
      itemSubtitle: (unit) => unit == WeightUnit.kilograms
          ? (l10n.weightUnitKgDescription)
          : l10n.weightUnitLbsDescription,
      onSelected: (selected) async {
        final (success, failure) = await ref
            .read(userProfileProvider.notifier)
            .updateWeightUnit(selected);
        if (!success && context.mounted) {
          AppSnackBar.show(
            context,
            message: failure != null
                ? failure.toUserMessage(l10n)
                : l10n.failedToUpdatePreferences,
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
          final l10n = AppLocalizations.of(context)!;
          AppSnackBar.show(
            context,
            message: failure != null
                ? failure.toUserMessage(l10n)
                : l10n.failedToUpdatePreferences,
            type: SnackBarType.error,
          );
        }
      },
    );
  }

  Future<void> _rateApp(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
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
            message: l10n.couldNotOpenStore,
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
          message: l10n.couldNotOpenStore,
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
          final l10n = AppLocalizations.of(context)!;
          AppSnackBar.show(
            context,
            message: failure != null
                ? failure.toUserMessage(l10n)
                : l10n.failedToUpdateThemeMode,
            type: SnackBarType.error,
          );
        }
      },
    );
  }

  String _themeLabel(AppLocalizations l10n, UserThemeMode mode) {
    return switch (mode) {
      UserThemeMode.light => l10n.themeLight,
      UserThemeMode.dark => l10n.themeDark,
      UserThemeMode.system => l10n.themeSystem,
    };
  }

  void _showFirstDayOfWeekPicker(
    BuildContext context,
    WidgetRef ref,
    FirstDayOfWeek current,
  ) {
    final l10n = AppLocalizations.of(context)!;
    SelectionDialog.show<FirstDayOfWeek>(
      context,
      title: l10n.selectFirstDayOfWeek,
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
            message: failure != null
                ? failure.toUserMessage(l10n)
                : l10n.failedToUpdatePreferences,
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
    final l10n = AppLocalizations.of(context)!;
    if (enable) {
      final canAuth = await BiometricService.instance.canAuthenticate();
      if (!canAuth) {
        if (context.mounted) {
          AppSnackBar.show(
            context,
            message: l10n.biometricNotAvailable,
            type: SnackBarType.error,
          );
        }
        return;
      }

      final result = await BiometricService.instance.authenticate(
        localizedReason: l10n.biometricReason,
        authMessages: BiometricService.createAuthMessages(l10n),
      );

      if (result != BiometricAuthResult.success) {
        if (context.mounted && result != BiometricAuthResult.canceled) {
          final errorMsg = result == BiometricAuthResult.lockedOut
              ? (l10n.biometricLockedOut)
              : l10n.biometricNotAvailable;
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
        message: failure != null
            ? failure.toUserMessage(l10n)
            : l10n.failedToUpdatePreferences,
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
        final l10n = AppLocalizations.of(context)!;
        if (success) {
          AppSnackBar.show(
            context,
            message: l10n.wipeDataSuccess,
            type: SnackBarType.success,
          );
        } else {
          AppSnackBar.show(
            context,
            message: failure != null
                ? failure.toUserMessage(l10n)
                : l10n.wipeDataError,
            type: SnackBarType.error,
          );
        }
      }
    }
  }
}
