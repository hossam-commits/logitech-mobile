# Contributing to LogiTech Mobile

Thank you for contributing to the LogiTech Flutter mobile app! This document outlines our development workflow, commit conventions, and quality standards.

## Git Workflow

We follow a **feature branch → pull request → CI checks → merge to main** workflow:

1. **Create a feature branch** from `main`:
   ```bash
   git checkout -b feat/your-feature-name
   # or: fix/bug-name, docs/documentation, chore/maintenance
   ```

2. **Make commits** using Conventional Commits (see below):
   ```bash
   git commit -m "feat(tickets): add audio recording support"
   ```

3. **Push your branch** and open a **Pull Request**:
   ```bash
   git push origin feat/your-feature-name
   ```

4. **CI checks run automatically** (mobile-ci.yml):
   - `flutter pub get` (dependency resolution)
   - `flutter analyze --fatal-infos` (strict code quality)
   - `flutter test --coverage` (unit tests with coverage)
   - Coverage upload to Codecov
   - **PR will block if analyzer warnings or tests fail.**

5. **Code review** and approval required (see PR template in `.github/pull_request_template.md`).

6. **Merge to main** once all checks pass and review is approved.

---

## Commit Message Convention (Conventional Commits)

We enforce [Conventional Commits](https://www.conventionalcommits.org/) to maintain clean, semantic commit history:

### Format
```
<type>(<scope>): <subject>

<body (optional)>

<footer (optional)>
```

### Types
- **feat:** A new feature
- **fix:** A bug fix
- **chore:** Build, deps, tooling (no code change)
- **docs:** Documentation only
- **refactor:** Code refactor (no new feature, no bug fix)
- **test:** Tests only (no code change)
- **perf:** Performance improvement

### Scope (optional)
Indicate the affected feature: `tickets`, `auth`, `dashboard`, `riverpod`, `media`, etc.

### Subject
- Use imperative mood ("add" not "added")
- Don't capitalize first letter
- No period at the end
- Max 50 characters

### Examples
```
feat(tickets): add audio recording to ticket creation
fix(auth): handle network timeout gracefully
chore(deps): upgrade flutter_riverpod to 3.1.0
docs(readme): add testing section
refactor(notifier): simplify state management
test(ticket_notifier): add async state transition tests
```

---

## Quality Gates & Code Review

### Automated Checks (CI/CD)
- ✅ Code must pass `flutter analyze --fatal-infos` (no warnings)
- ✅ All tests must pass (`flutter test`)
- ✅ Code coverage must not decrease
- ✅ Codecov reports coverage metrics

**PR will be blocked if any check fails.**

### Manual Review
- At least 1 approving review required
- 2 reviews required for:
  - Riverpod state management changes
  - Architecture/layer changes
  - Breaking API changes
  - Dependency upgrades

### Before Opening a PR
- [ ] Run `flutter analyze` locally and fix all warnings
- [ ] Run `flutter test` locally and ensure all pass
- [ ] Format code: `dart format .` (or `flutter format .`)
- [ ] Update unit tests for new logic
- [ ] Update documentation (README, comments)
- [ ] Sync schema changes with web dashboard if needed

---

## Testing Requirements

All feature code must have corresponding unit tests:

- **Notifiers:** Test state transitions, async values (loading, data, error)
- **Repositories:** Mock data sources, test error handling
- **Use Cases:** Verify business logic isolation
- **Widgets:** Use `flutter test` for UI component behavior

Example test pattern (Riverpod 3.x):
```dart
test('Happy Path: Notifier updates state correctly', () {
  final container = ProviderContainer();
  final notifier = container.read(myProvider.notifier);
  
  notifier.doSomething();
  
  expect(container.read(myProvider), expectedState);
});
```

See `test/features/tickets/ticket_notifier_test.dart` for a full example.

---

## Syncing with Web Dashboard

When making changes that affect **schema, types, or APIs**:
- Update domain models in `lib/features/*/domain/`
- Sync type changes to `logitech-dashboard/src/services/firestore.ts`
- Document any schema migration steps in your PR
- Ensure both repos' Firestore collection interfaces match

---

## Setting Up Local Development

```bash
# 1. Clone and navigate
git clone <repo-url>
cd logitech-mobile

# 2. Install dependencies
flutter pub get

# 3. Run on emulator/device
flutter run -d <device-id>

# 4. Run tests in watch mode (in another terminal)
flutter test --watch

# 5. Static analysis
flutter analyze

# 6. Format code
dart format .
```

---

## Local Quality Checks

A helper script is provided at `scripts/run_checks.ps1` to run all checks on Windows:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\scripts\run_checks.ps1
```

This script runs:
- `flutter pub get`
- `flutter analyze --fatal-infos`
- `flutter test --coverage`
- `dart format --set-exit-if-changed .`

Make sure all local checks pass before opening a PR.

---

## Questions?

- Check [`.github/copilot-instructions.md`](../.github/copilot-instructions.md) for architectural context
- Review recent PRs for examples
- Check `docs/environment-management.md` for environment setup
- Open an issue with your question

## Prerequisites
- Install Flutter SDK (https://flutter.dev/docs/get-started/install)
- Ensure `flutter`, `dart` are available in PATH
- Optional: install an IDE (VS Code / Android Studio) and Dart/Flutter plugins

## Local checks
A helper script is provided at `scripts/run_checks.ps1` to run the standard checks on Windows (PowerShell):

```powershell
# From repository root
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
.\scripts\run_checks.ps1
```

This script runs:
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `dart format --set-exit-if-changed .` (fails if formatting required)

If any of the checks fail, fix the issues and re-run the script.

## Continuous Integration (CI)
We run checks on every PR and push to `main` using GitHub Actions.
The CI workflow (`.github/workflows/flutter-ci.yml`) runs:
- `flutter pub get`
- `flutter analyze`
- `flutter test` (unit & widget tests, with coverage)
- `dart format --set-exit-if-changed .` (format check)

Make sure local checks pass before opening a PR to avoid failures on CI.

### Codecov
Coverage is uploaded to Codecov from the `analyze_and_test` job using `coverage/lcov.info`.
- For public repositories this should work without additional configuration.
- For private repositories, set the repository secret `CODECOV_TOKEN` (Settings → Secrets → Actions) so the CI can upload coverage.


## Git workflow (GitHub)
- Create a short-lived feature/fix branch from `main`: `fix/description` or `feature/description`
- Make small, focused commits with conventional messages e.g. `fix: normalize test, use LogiTechApp`
- Push branch and open a PR targeting `main` and request reviews
- CI must pass before merging (analyze, tests, formatting)

## Code style and guidelines
- Follow the Dart & Flutter lints (see `analysis_options.yaml`)
- Use `dart format .` to format code
- Keep secrets/config in environment variables (Twelve-Factor: Config)

If you have questions or need help, please open an issue or ping maintainers in the PR.
