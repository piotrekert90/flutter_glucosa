import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/settings/presentation/providers/user_profile_notifier.dart';
import '../../../l10n/app_localizations.dart';
import '../widgets/app_error_view.dart';

/// Blocking error screen shown when the user profile fails to load at startup.
///
/// Prevents the router from failing open into the main flow with undefined
/// state; retry re-reads the profile repository.
class StartupErrorScreen extends ConsumerWidget {
  /// Creates a [StartupErrorScreen].
  const StartupErrorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: AppErrorView(
          message: l10n.genericError,
          onRetry: () => ref.invalidate(userProfileProvider),
        ),
      ),
    );
  }
}
