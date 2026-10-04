import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/onboarding_notifier.dart';

/// Eighth onboarding step presenting transparent data-privacy information.
///
/// All health data and diagnostic logs stay on the device.
/// Advancing requires acknowledging the notice.
class OnboardingPrivacyStep extends ConsumerWidget {
  /// Creates an [OnboardingPrivacyStep].
  const OnboardingPrivacyStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final acknowledged = ref.watch(
      onboardingProvider.select((draft) => draft.privacyAcknowledged),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Icon(
            Icons.privacy_tip_outlined,
            size: 72,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.onboardingPrivacyTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingPrivacySubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          CheckboxListTile(
            title: Text(l10n.onboardingPrivacyAcknowledge),
            value: acknowledged,
            onChanged: (value) {
              if (value == true) {
                ref.read(onboardingProvider.notifier).acknowledgePrivacy();
              }
            },
          ),
        ],
      ),
    );
  }
}
