import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../router/app_routes.dart';

/// Shows a modal bottom sheet letting the user pick which metric type to log.
///
/// Each option navigates to the corresponding add-reading form.
Future<void> showAddReadingBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (_) => const AddReadingBottomSheet(),
  );
}

/// Bottom sheet content listing all loggable health metric types.
class AddReadingBottomSheet extends StatelessWidget {
  /// Creates an [AddReadingBottomSheet].
  const AddReadingBottomSheet({super.key});

  void _navigate(BuildContext context, AppRoute route) {
    Navigator.of(context).pop();
    context.push(route.path);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final options = <_MetricOption>[
      _MetricOption(
        icon: Icons.water_drop_outlined,
        label: l10n?.glucose ?? 'Blood Glucose',
        route: AppRoute.addGlucose,
      ),
      _MetricOption(
        icon: Icons.science_outlined,
        label: l10n?.hba1c ?? 'HbA1c',
        route: AppRoute.addHba1c,
      ),
      _MetricOption(
        icon: Icons.favorite_outline,
        label: l10n?.bloodPressure ?? 'Blood Pressure',
        route: AppRoute.addBloodPressure,
      ),
      _MetricOption(
        icon: Icons.biotech_outlined,
        label: l10n?.ketones ?? 'Ketones',
        route: AppRoute.addKetones,
      ),
      _MetricOption(
        icon: Icons.monitor_heart_outlined,
        label: l10n?.cholesterol ?? 'Cholesterol',
        route: AppRoute.addCholesterol,
      ),
      _MetricOption(
        icon: Icons.monitor_weight_outlined,
        label: l10n?.weight ?? 'Weight',
        route: AppRoute.addWeight,
      ),
    ];

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Text(
              l10n?.addReading ?? 'Add reading',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final option in options)
                    ListTile(
                      leading: Icon(option.icon),
                      title: Text(option.label),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _navigate(context, option.route),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Single metric entry displayed in [AddReadingBottomSheet].
class _MetricOption {
  /// Leading icon representing the metric.
  final IconData icon;

  /// Localized display label.
  final String label;

  /// Add-form route opened when the option is tapped.
  final AppRoute route;

  const _MetricOption({
    required this.icon,
    required this.label,
    required this.route,
  });
}
