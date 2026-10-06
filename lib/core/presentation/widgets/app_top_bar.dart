import 'package:flutter/material.dart';

import '../theme/app_layout_tokens.dart';

/// A reusable Material 3 top app bar for main navigation screens.
///
/// Mirrors the Balance [AppTopBar] contract: unified 64dp toolbar, title in
/// [TextTheme.headlineMedium] bold with the primary brand color, surface
/// background with no scroll tint, and content-aligned title spacing.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  /// The title text displayed in the app bar.
  final String title;

  /// An optional list of action widgets displayed on the right.
  final List<Widget>? actions;

  /// An optional leading widget (defaults to the enclosing [Scaffold] behavior).
  final Widget? leading;

  /// Whether to automatically imply a leading widget when none is provided.
  final bool automaticallyImplyLeading;

  /// Creates an [AppTopBar].
  const AppTopBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      toolbarHeight: 64,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: colorScheme.surface,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      centerTitle: false,
      titleSpacing: context.contentHorizontalPadding,
      title: Semantics(
        header: true,
        child: Text(
          title,
          style: textTheme.headlineMedium?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      actions: actions,
    );
  }
}
