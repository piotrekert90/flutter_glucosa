/// Defines all application navigation routes, paths, and names for GoRouter.
enum AppRoute {
  /// Main dashboard overview screen route.
  overview('/', 'overview'),

  /// Health measurements history list route.
  history('/history', 'history'),

  /// User profile and application settings route.
  settings('/settings', 'settings'),

  /// Open-source licenses screen route.
  licenses('licenses', 'licenses'),

  /// Privacy policy screen route.
  privacyPolicy('privacy-policy', 'privacy_policy');

  const AppRoute(this.path, this.name);

  /// The URL path template for the route.
  final String path;

  /// The unique identifier name for named navigation.
  final String name;
}
