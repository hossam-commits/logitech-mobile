# ADR 001: Configuration Management using --dart-define

## Status
Accepted

## Context
Logitech Mobile requires different configurations for different environments (development, staging, production). Hardcoding values like API base URLs or Firebase configuration strings violates The Twelve-Factor App principle (Factor III: Config).

## Decision
We will use Dart environment variables via the `--dart-define` and `--dart-define-from-file` flags. This approach:
1. Keeps configuration separate from code.
2. Allows providing default values if variables are missing.
3. Is natively supported by Flutter without external dependencies for basic use cases.

A centralized `AppConfig` class in `lib/core/config/app_config.dart` will act as the single source of truth.

## Consequences
- Developers must provide `--dart-define` flags or a config file when running/building the app.
- Improved security by not checking sensitive keys into version control (they should be passed via CI/CD secrets).
