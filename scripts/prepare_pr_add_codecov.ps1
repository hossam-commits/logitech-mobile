# Commit & push workflow change to a branch and optionally create a PR via gh
param(
    [string]$BranchName = "ci/add-flutter-checks",
    [switch]$CreatePR
)

# Ensure we're up to date
git fetch origin

# If branch exists locally, checkout it; otherwise create from origin/main
if (git show-ref --verify --quiet refs/heads/$BranchName) {
    git checkout $BranchName
} else {
    git checkout -b $BranchName origin/main
}

# Stage updated workflow
git add .github/workflows/flutter-ci.yml CONTRIBUTING.md

if (-not (git diff --staged --quiet)) {
    git commit -m "chore(ci): upload coverage to Codecov and save coverage artifact"
    git push -u origin $BranchName
    Write-Host "Pushed changes to origin/$BranchName"
} else {
    Write-Host "No changes to commit"
}

if ($CreatePR) {
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        gh pr create --base main --title "chore(ci): add Codecov coverage upload" --body "Adds Codecov upload step and coverage artifact to the Flutter CI workflow. Ensure `CODECOV_TOKEN` secret is set if repo is private." --label "chore"
    } else {
        Write-Warning "gh CLI not found. Install GitHub CLI (https://cli.github.com/) or create PR manually via GitHub UI."
    }
} else {
    Write-Host "Done. To create PR automatically, rerun with -CreatePR switch (requires gh CLI)."
}