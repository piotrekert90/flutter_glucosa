# Project-Specific Rules — Glucosa (v1.0.0)

*Companion to `AGENTS.md`. Save this file as `agents_project.md` in this repo's root, next to `AGENTS.md`.
Frozen strictly around 3 pillars: Clean Architecture, Riverpod 3.x, and Isar Community, with an integrated
minimal l10n blueprint.*

### Build & Generation Commands
| Command | Purpose |
|---|---|
| `flutter pub get` | Install workspace dependencies |
| `flutter gen-l10n` | Regenerate localization if ARB files changed |
| `dart run build_runner build` | Generate Riverpod + Isar code (`--delete-conflicting-outputs`) |
| `dart run flutter_launcher_icons` | Generate app icons (Android + iOS) from `assets/icon/` |
| `dart run flutter_native_splash:create` | Generate native splash screens from `assets/icon/` |
| `dart format lib test integration_test test_driver` | Format all source and test directories |
| `flutter analyze` | Static analysis across the workspace |
| `dart run custom_lint` | Riverpod-specific architectural lint checks |
| `flutter test` | Run tests (`--exclude-tags "golden,screenshot"` for CI/fast runs) |
| `./scripts/screenshots/generate_screenshots.sh [target\|device] [device\|locale] [locale]` | Automated App Store / Play Store screenshot capture |
| `bash scripts/before_push.sh` | Full pre-push verification pipeline |

### Architecture & Layer Boundaries
Feature-First Clean Architecture under `lib/features/<feature>/`. Features include: `glucose`, `history`,
`overview`, and `settings` (singleton Isar collection, id=0). Global providers live under
`lib/core/providers/`, and declarative routing is configured under `lib/core/router/` using `GoRouter`.

- **Domain** (`lib/features/<feature>/domain/`): Pure Dart — entities, repository interfaces, use cases,
  enums, and value objects. NO Flutter or Riverpod imports allowed here.
- **Data** (`lib/features/<feature>/data/`): Repository implementations, Isar models, and **synchronous**
  mappers (extensions).
- **Presentation** (`lib/features/<feature>/presentation/`): UI (`ConsumerWidget`) and state management via
  Riverpod 3.x generators (`@riverpod`).
- **State Management:** Riverpod 3.x strictly.
- **Data Flow:** UI (`ConsumerWidget`) → Notifier (`@riverpod`) → Repository Interface (domain) → Repository
  Impl (data) → Local DB (`isar_community`).
- **Reactivity:** Handled purely via Isar streams. Notifiers listen to Isar collections and pipe data
  directly into `AsyncValue` state.

#### Strict Dependency Rules
- **No data-model leakage into presentation:** Presentation files (`notifier`, widgets) must never import
  `UserProfileModel`, `GlucoseReadingModel`, or any file from `lib/features/*/data/models/`. Only domain entities
  (`UserProfile`, `GlucoseReading`) and failure types may be referenced.
- **No Isar annotations in presentation:** `@collection`, `@property`, `@Index`, `Isar.autoIncrement`, and
  any other Isar-specific annotations or types must not appear in presentation-layer code.
- **Mappers must be stateless:** Mapper functions (e.g. `toDomain()`, `toModel()`) must be synchronous,
  side-effect-free extension methods. They must not hold mutable state, perform I/O, or depend on external services.
- **One-way dependency:** Imports flow inward toward the domain. Presentation imports domain; data imports
  domain and Isar. Domain imports nothing project-specific.

### Riverpod 3.x + Isar Community Patterns
- **Always** use `@riverpod` code generation — never manual state mutation.
- State is **stream-driven**: notifiers listen to Isar collections and pipe into `AsyncValue`. No manual
  `state = ...` in CRUD methods.
- **I/O isolation:** mappers are synchronous, stateless extensions — they never execute I/O.
- **Single source of truth:** screens subscribe by ID via `.family(id)` providers.
- Use `isar_community` (not `isar`) — the original `isar` package conflicts with `riverpod_generator`.

### Logging & UI Tokens
- **Logging:** Never use `print` / `debugPrint`. Use `AppLogger` (`lib/core/utils/app_logger.dart`) with
  `AppLogger.debug`, `AppLogger.info`, `AppLogger.warning`, `AppLogger.error`. Unhandled errors are also
  intercepted globally by `AppProviderObserver` (`lib/core/providers/app_provider_observer.dart`) and
  persisted to rotating on-device crash logs via `AppCrashReporter` (`lib/core/utils/crash_reporter.dart`).
- **UI Colors:** Never hardcode raw colors (`Color(0x...)`, `Colors.*`). Use `AppTheme`
  (`lib/core/presentation/theme/app_theme.dart`), `AppFeedbackTheme`
  (`lib/core/presentation/theme/app_feedback_theme.dart`), and `AppChartTheme`
  (`lib/core/presentation/theme/app_chart_theme.dart`). There is no `AppColors`
  class; `Color(0x...)` literals are only allowed inside those token definitions.
- **Layout & Responsiveness:** Use `AppLayoutTokens` (`lib/core/presentation/theme/app_layout_tokens.dart`)
  via `context.layout`, `context.isPhone`, `context.isTablet`, `ClampedLayout`, and `AdaptiveNavigationScaffold`.
- **Result Types:** Use `CommandResult` and `DataResult<T>` (`lib/core/errors/result.dart`) for standard
  record-based domain operation returns.

### Security & Data Protection
- **Local Persistence & Encryption Debt:** Isar Community (3.1.0+1) runs unencrypted within the local
  application sandbox. Native database-level encryption is unsupported by the current engine and is documented
  as conscious technical debt. The former `FieldCipher` field-level encryption utility was removed with its
  `crypto` dependency; do not reference it.

### Resource Lifecycle & Disposal (concrete items)
- Every `StreamSubscription` cancelled in `dispose()` or the corresponding Notifier's `ref.onDispose()`.
- Every `Timer` or `AnimationController` cancelled/disposed the same way to prevent memory leaks.
- All Isar dynamic query streams properly closed or managed via Riverpod's auto-dispose mechanism.

### Testing Conventions
- **Unit tests:** notifier state transitions, CRUD logic, subscription cancellation, mappers, ciphers.
- **Widget tests:** fake repositories injected via `ProviderScope(overrides: [...])`.
- **Golden tests:** tagged `golden` in `dart_test.yaml`. Run with `flutter test --tags=golden`.
- **Screenshot tests:** modular integration test harness under `integration_test/*_screenshots_test.dart` tagged `screenshot`.
- **Fixtures:** `test/helpers/fake_user_profile_repository.dart`.
  Always call `.dispose()` in `tearDown()` to close stream controllers.

### Generated Files
- `*.g.dart` files come from `build_runner` and are excluded from analysis (`analysis_options.yaml`).

### Mandatory Verification Pipeline (concrete commands)
Matches `scripts/before_push.sh` and CI:
1. `flutter pub get`
2. `flutter gen-l10n`
3. `dart run build_runner build`
4. `dart format lib test integration_test test_driver`
5. `flutter analyze`
6. `dart run custom_lint`
7. `flutter test --exclude-tags "golden,screenshot"`

Once all 7 steps are green and the Resource Lifecycle checklist above is verified, commit per `AGENTS.md` →
Git & Version Control (autonomous commit is enabled for this repo, since this file exists).

### Atomic Commit Discipline
- One feature = stack of layer commits (`domain` → `data` → `presentation` → `l10n/wiring` → `test`), each pipeline-green, instead of a single whole-feature commit.
- Soft cap: ~500 lines of hand-written code per commit; above that, split by layer or concern.
- Generated `*.g.dart` (build_runner / Isar) always land in a separate `chore(gen)` commit adjacent to the hand-written change — never bundled into `feat`/`fix` diffs.
- Single-concern commits below the cap (one screen, one repository, one dialog) stay as-is; do not over-split.
