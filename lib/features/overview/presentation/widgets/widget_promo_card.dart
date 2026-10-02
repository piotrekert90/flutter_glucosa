import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';

/// Dismissible card promoting the native home screen glucose widget.
///
/// Shown on Overview only when the platform supports widget pin requests and
/// no widget instance is installed yet. Renders nothing otherwise, so it never
/// disturbs unsupported platforms or widget tests without a native host.
class WidgetPromoCard extends ConsumerStatefulWidget {
  /// Creates a [WidgetPromoCard].
  const WidgetPromoCard({super.key});

  @override
  ConsumerState<WidgetPromoCard> createState() => _WidgetPromoCardState();
}

class _WidgetPromoCardState extends ConsumerState<WidgetPromoCard> {
  /// Whether the card passed the async eligibility checks.
  bool _eligible = false;

  @override
  void initState() {
    super.initState();
    _checkEligibility();
  }

  /// Verifies pin support and the absence of installed widget instances.
  ///
  /// Stays hidden on any error (e.g. no native host in tests).
  Future<void> _checkEligibility() async {
    try {
      if (defaultTargetPlatform != TargetPlatform.android) return;
      final supported = await HomeWidget.isRequestPinWidgetSupported();
      if (supported != true) return;
      final installed = await HomeWidget.getInstalledWidgets();
      if (!mounted || installed.isNotEmpty) return;
      setState(() => _eligible = true);
    } catch (_) {
      // Native widget integration unavailable: stay hidden.
    }
  }

  /// Asks the launcher to pin the compact glucose widget.
  Future<void> _handlePin() async {
    try {
      await HomeWidget.requestPinWidget(
        androidName: 'GlucosaAppWidgetProvider',
      );
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      AppSnackBar.show(
        context,
        message:
            l10n?.widgetPinRequested ?? 'Widget pin request sent to launcher',
        type: SnackBarType.success,
      );
    } catch (_) {
      // Pin request failed: stay silent, the card remains available.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_eligible) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.widgets_outlined,
              size: 32,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n?.widgetPromoTitle ?? 'Glucose at a glance',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n?.widgetPromoSubtitle ??
                        'Pin the Glucosa widget to your home screen',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              onPressed: _handlePin,
              child: Text(l10n?.widgetPromoPin ?? 'Pin'),
            ),
          ],
        ),
      ),
    );
  }
}
