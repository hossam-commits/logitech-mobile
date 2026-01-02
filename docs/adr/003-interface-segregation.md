# ADR 003: Separating Interfaces from Implementations

## Status
Accepted

## Context
Directly depending on concrete classes makes the code hard to test and swap (e.g., swapping a Mock service for a real Firebase service). Factor IV: Backing Services suggests treating services as attached resources.

## Decision
We will define all external services as abstract interfaces.
Concrete implementations will be placed in an `impl/` sub-package or adjacent file.
We will use `flutter_riverpod` for Dependency Injection to provide implementations to the rest of the app.

## Consequences
- Enhanced testability (easy to mock interfaces).
- Cleaner separation of concerns.
- Minor increase in initial boilerplate.
