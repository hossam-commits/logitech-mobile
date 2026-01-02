# Prepare and push a branch with the CI + fixes and optionally create a PR via gh (GitHub CLI)
# Usage:
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
#   .\scripts\prepare_pr.ps1 -BranchName "ci/add-flutter-checks" -CreatePR
param(
    [string]$BranchName = "ci/add-flutter-checks",
    [switch]$CreatePR
)

Write-Host "Creating branch: $BranchName"
git checkout -b $BranchName

Write-Host "Staging changes"
git add .github/workflows/flutter-ci.yml CONTRIBUTING.md scripts/run_checks.ps1 scripts/prepare_pr.ps1 test/widget_test.dart lib/core/services/daily_preparation_usecase.dart lib/features/operations/presentation/daily_preparation_notifier.dart

Write-Host "Committing"
git commit -m "chore(ci): add Flutter CI and fix tests/encoding; add run_checks script and docs"

Write-Host "Pushing to origin/$BranchName"
git push -u origin $BranchName

if ($CreatePR) {
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        Write-Host "Creating PR via GitHub CLI"
        gh pr create --base main --title "chore(ci): add Flutter CI and fix tests/encoding" --body "Adds GitHub Actions to run flutter analyze/test and dart format. Fixes failing widget test and normalizes Arabic messages. Includes local scripts and CONTRIBUTING.md updates." --label "chore" --assignee @me
    } else {
        Write-Warning "gh CLI not found. Install GitHub CLI (https://cli.github.com/) or create PR manually via GitHub UI."
    }
} else {
    Write-Host "Skip creating PR. To create PR automatically, rerun with -CreatePR switch (requires gh CLI)."
}
