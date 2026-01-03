# Environment & Secret Management Strategy

This document outlines the strategy for achieving **Dev/Prod Parity** (Factor X) and secure **Configuration** (Factor III) management in the LogiTech Mobile project.

## 1. Multiple Entry Points (Flavors)

We use different entry points for each environment:
- `lib/main_dev.dart`: Development environment.
- `lib/main_prod.dart`: Production environment.
- `lib/main_common.dart`: Shared initialization logic.

### Usage
- **Run Dev**: `flutter run -t lib/main_dev.dart`
- **Run Prod**: `flutter run -t lib/main_prod.dart`

## 2. Configuration via `--dart-define`

Sensitive data and environment-specific variables are NOT committed to the repository. Instead, we use `--dart-define`.

### Local Development
Create a `config_dev.json` (GIT IGNORED):
```json
{
  "APP_TITLE": "LogiTech DEV",
  "API_BASE_URL": "https://api-dev.logitech.com",
  "API_KEY": "dev_secret_key",
  "FIREBASE_PROJECT_ID": "logitech-dev-123"
}
```
Run with: `flutter run -t lib/main_dev.dart --dart-define-from-file=config_dev.json`

### CI/CD (GitHub Actions)
Secrets are stored in GitHub Repository Secrets and passed during the build:
```yaml
- name: Build APK
  run: flutter build apk -t lib/main_prod.dart \
    --dart-define=API_KEY=${{ secrets.PROD_API_KEY }} \
    --dart-define=FIREBASE_PROJECT_ID=${{ secrets.PROD_FIREBASE_PROJECT_ID }}
```

## 3. Separation of Concerns
- **Dev Secrets**: Isolated in local `json` files or simple dev keys.
- **Prod Secrets**: Accessible only by the CI/CD pipeline or authorized architects.
- **Data Pollution**: By strictly using different `API_BASE_URL` and `FIREBASE_PROJECT_ID` per environment, development testing never touches production data.
