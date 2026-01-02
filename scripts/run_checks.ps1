# Run local checks for the LogiTech Mobile Flutter project
# Usage (PowerShell):
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
#   .\scripts\run_checks.ps1

function Ensure-Command($cmd) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Error "$cmd is not installed or not in PATH. Please install Flutter SDK: https://flutter.dev/docs/get-started/install"
        exit 1
    }
}

Ensure-Command flutter

Write-Host "Running: flutter --version"
flutter --version

Write-Host "Running: flutter pub get"
flutter pub get

Write-Host "Running: flutter analyze"
flutter analyze
$analyzeExit = $LASTEXITCODE

Write-Host "Running: flutter test"
flutter test
$testExit = $LASTEXITCODE

Write-Host "Checking format (dart format --set-exit-if-changed .)"
dart format --set-exit-if-changed .
$formatExit = $LASTEXITCODE

if ($analyzeExit -ne 0 -or $testExit -ne 0 -or $formatExit -ne 0) {
    Write-Error "One or more checks failed. See output above. Fix the issues and re-run this script."
    exit 1
}

Write-Host "All checks passed. ✅"
