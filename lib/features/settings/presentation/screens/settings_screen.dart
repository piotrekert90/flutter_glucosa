import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/presentation/extensions/failure_ui_extension.dart';
import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/utils/crash_reporter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/user_preferences.dart';
import '../providers/user_preferences_notifier.dart';
import '../widgets/components/custom_settings_tile.dart';
import '../widgets/components/custom_settings_toggle.dart';
import '../widgets/components/section_header.dart';
import '../widgets/components/theme_selection_dialog.dart';

/// Presentation widget rendering the user preferences and settings screen.
///
/// Displays theme mode selectors, notification switches, and application information,
/// backed by [userPreferencesProvider].
class SettingsScreen extends ConsumerWidget {
  /// Creates a settings screen widget instance.
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesAsync = ref.watch(userPreferencesProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.settingsTitle ?? 'Settings')),
      body: preferencesAsync.when(
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => AppErrorView(
          message: error is Failure && l10n != null
              ? error.toUserMessage(l10n)
              : error.toString(),
          retryLabel: l10n?.tryAgain ?? 'Try again',
          onRetry: () => ref.invalidate(userPreferencesProvider),
        ),
        data: (preferences) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                SectionHeader(label: l10n?.appearance ?? 'Appearance'),
                CustomSettingsTile(
                  icon: Icons.palette_outlined,
                  title: l10n?.theme ?? 'Theme',
                  valueText: _themeLabel(l10n, preferences.themeMode),
                  onTap: () =>
                      _showThemePicker(context, ref, preferences.themeMode),
                ),
                const SizedBox(height: 12),
                CustomSettingsToggle(
                  icon: Icons.notifications_outlined,
                  title: l10n?.notifications ?? 'Notifications',
                  subtitle:
                      l10n?.receivePushNotifications ??
                      'Receive push notifications',
                  value: preferences.isNotificationsEnabled,
                  onChanged: (value) async {
                    final (success, failure) = await ref
                        .read(userPreferencesProvider.notifier)
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
            .read(userPreferencesProvider.notifier)
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
}
