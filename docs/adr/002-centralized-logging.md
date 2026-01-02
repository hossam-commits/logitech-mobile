# ADR 002: Centralized Logging System

## Status
Accepted

## Context
Standard `print()` statements are difficult to filter, lack severity levels (Info, Warning, Error), and are not easily redirectable to external monitoring services (Factor XI: Logs).

## Decision
We will implement a centralized `AppLogger` utility. 
Initially, it will wrap a lightweight logging package or custom implementation that supports:
1. Severity levels.
2. Contextual tagging.
3. Easy redirection to services like Sentry or Firebase Crashlytics in the future.

## Consequences
- All developers must use `AppLogger` instead of `print()`.
- Consistent log output across the application.
