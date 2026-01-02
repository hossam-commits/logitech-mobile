# Contributing — LogiTech Mobile

Thank you for contributing! This document explains local setup, the checks to run, and the Git workflow we follow.

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
