import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/onboarding_notifier.dart';

/// First onboarding step collecting the user's display name.
class OnboardingWelcomeStep extends ConsumerStatefulWidget {
  /// Creates an [OnboardingWelcomeStep].
  const OnboardingWelcomeStep({super.key});

  @override
  ConsumerState<OnboardingWelcomeStep> createState() =>
      _OnboardingWelcomeStepState();
}

class _OnboardingWelcomeStepState extends ConsumerState<OnboardingWelcomeStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(onboardingProvider).name,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Icon(
            Icons.water_drop_rounded,
            size: 72,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n?.onboardingWelcomeTitle ?? 'Welcome to Glucosa',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n?.onboardingWelcomeSubtitle ??
                "Let's set up your profile in a few quick steps.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              labelText: l10n?.onboardingNameLabel ?? 'Your name',
              hintText: l10n?.onboardingNameHint ?? 'e.g. Alex',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.person_outlined),
            ),
            onChanged: (val) =>
                ref.read(onboardingProvider.notifier).updateName(val),
          ),
        ],
      ),
    );
  }
}
