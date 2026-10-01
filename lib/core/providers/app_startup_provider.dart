import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'isar_provider.dart';

part 'app_startup_provider.g.dart';

/// Pre-warms and initializes all critical asynchronous dependencies before UI rendering.
///
/// Watches [isarDbProvider] to ensure local database collections are open and ready.
/// Returns a [Future] completing when all startup services are initialized.
@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  await ref.watch(isarDbProvider.future);
}
