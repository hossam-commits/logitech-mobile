# logitech_mobile

[![Mobile CI](https://github.com/LogiTech-System/logitech-mobile/actions/workflows/mobile-ci.yml/badge.svg)](https://github.com/LogiTech-System/logitech-mobile/actions/workflows/mobile-ci.yml)
[![codecov](https://codecov.io/gh/LogiTech-System/logitech-mobile/branch/main/graph/badge.svg)](https://codecov.io/gh/LogiTech-System/logitech-mobile)

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

* [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
* [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

This branch adds Codecov coverage upload. <!-- Trigger CI -->

---

## Architecture
- The mobile app follows a Clean Architecture approach:
  - Data layer: repositories, remote/local data sources.
  - Domain layer: use cases and business logic.
  - Presentation layer: UI and state management (Riverpod Notifiers).

## State Management
- Uses Riverpod 3.x with the Notifier/NotifierProvider pattern (see `lib/features/*/presentation/*_provider.dart` or `*_notifier.dart`).
- Prefer immutable state objects and `copyWith` methods for updates (see `lib/features/tickets/domain/create_ticket_form.dart`).

## Quality & Testing
- Static analysis: `flutter analyze` (CI runs `flutter analyze --fatal-infos`).
- Tests: `flutter test` (CI runs tests and generates coverage report).
- CI: See `.github/workflows/flutter_ci.yml` which runs: checkout, setup Flutter, `dart format`, `flutter analyze`, and `flutter test --coverage`.

---

If you'd like, I can add a short example showing how to write a simple unit test for a Notifier or add a coverage upload step to CI (Codecov/GitHub uploads).