---
name: update-axsharp-version
description: Update AXSharp.* and Inxton.Operon.* package versions in this repo (via scripts/update_axsharp_versions.ps1), verify the build, update the central CHANGELOG.md, and open a PR with a generated description. Use when the user asks to bump/update AXSharp versions or open a dependency-update PR. Defaults to the latest versions from the feed; accepts optional explicit versions.
---

# Update AXSharp version

Drives the AXSharp / Inxton.Operon dependency bump end to end: run the existing update script →
verify the build → record the change in the central `CHANGELOG.md` → open a PR.

The actual file edits live in [`scripts/update_axsharp_versions.ps1`](../../../scripts/update_axsharp_versions.ps1).
**Do not reimplement version rewriting** — this skill only orchestrates around that script.

By default the script auto-detects the latest `AXSharp.ixc` and `Inxton.Operon` versions from the
GitHub Packages feed. The user may pass explicit versions; thread them through as
`-AxSharpVersion <v>` / `-OperonVersion <v>` on every script invocation below.

## Procedure

### 1. Preconditions

- Run all commands from the **repo root**. The script resolves its own `repoRoot`, but `git`/`gh`
  operations assume root.
- **Token (auto-detect mode only):** the script needs a feed token with `read:packages` scope. It
  reads, in order, `AXSHARP_FEED_TOKEN`, `GITHUB_PACKAGES_TOKEN`, `GITHUB_TOKEN`, `GH_TOKEN`,
  `NUGET_TOKEN`. If none is set **and** no explicit versions were given, tell the user to set one
  (or pass `-Token`) and stop. Skip this check when explicit versions are supplied.
- **Clean tree:** run `git status`. If the working tree is dirty, surface it and stop — do not bundle
  unrelated changes into a dependency PR.

### 2. Branch

Check the current branch (`git branch --show-current`). If on the default branch `dev` (or any
protected branch), create a working branch first. Prefer a version-tagged name once the version is
known, otherwise a generic one:

```powershell
git switch -c chore/update-axsharp-versions
```

If already on a non-default working branch, stay on it.

### 3. Preview (recommended)

Show the user what will change before touching files:

```powershell
pwsh -File scripts/update_axsharp_versions.ps1 -DryRun -Detailed
```

Append `-AxSharpVersion <v> -OperonVersion <v>` to override. Use `-ListAvailable` to inspect feed
versions. The dry run must not modify files — `git status` stays clean.

### 4. Apply

Run for real and **capture stdout** — the `Summary of changes:` and `Target versions:` blocks feed
the CHANGELOG entry, commit message, and PR body:

```powershell
pwsh -File scripts/update_axsharp_versions.ps1
# or, with overrides:
pwsh -File scripts/update_axsharp_versions.ps1 -AxSharpVersion <v> -OperonVersion <v>
```

Handle outcomes:
- **Non-zero exit** — exit `2` = feed/auth failure, exit `3` = JSON parse failure. Report the error
  output and stop.
- **No changes** — if `git status` shows nothing changed, report "already up to date at
  `<version>`" and stop. Do **not** open a PR.

Record the resolved `<AxSharpVersion>` and `<OperonVersion>` from the script's `Target versions:`
block for the steps below.

### 5. Verify build

Confirm the new package set resolves before opening the PR (build only, no tests):

```powershell
dotnet run --project cake/Build.csproj -- --do-apax-update
```

`--do-apax-update` pulls the apax-side packages; the .NET restore covers the central-managed NuGet
bumps. For a heavier check, [`scripts/build_with_update.ps1`](../../../scripts/build_with_update.ps1)
runs build + tests at level 10.

If the build **fails**: report the failure with output and **do not open the PR**. Leave the changes
on the branch for the user to inspect.

### 6. Update central CHANGELOG.md

Prepend a new entry at the **top** of [`CHANGELOG.md`](../../../CHANGELOG.md) (newest-on-top, above
the current first `###` heading), matching the existing structured format. Use category tag `[DEPS]`.
Fill bullets from the script's `Summary of changes:` block.

```markdown
### [DEPS] Update AXSharp / Inxton.Operon package versions to <AxSharpVersion>

**Note:** Dependency version bump via `scripts/update_axsharp_versions.ps1`. No source change.
Branch: `<branch-name>`.

- chore: AXSharp.* packages updated to `<AxSharpVersion>` in `.config/dotnet-tools.json` and `Directory.Packages.props`.
- chore: Inxton.Operon.* packages updated to `<OperonVersion>`.
- chore: reconciled AXSharp transitive (third-party) dependencies in `Directory.Packages.props` (bump-up only).
<one bullet per non-trivial line from the script's "Summary of changes:" block>

**Impact:**
- Repo now builds and tests against AXSharp `<AxSharpVersion>` / Inxton.Operon `<OperonVersion>`.

**Risks/Review:**
- Transitive pinned versions were bumped up to satisfy AXSharp's nuspec requirements; review `Directory.Packages.props` diff.

**Testing:**
- `dotnet run --project cake/Build.csproj -- --do-apax-update` — build succeeds with the new package set.
```

### 7. Commit

Match the repo convention (see commit `0929211f1`):

```powershell
git add .config/dotnet-tools.json Directory.Packages.props CHANGELOG.md
git commit -m "chore: update AXSharp package versions to <AxSharpVersion> and reconcile transitive dependencies"
git push -u origin HEAD
```

Scope the `git add` to the touched files. (The script edits only these in a normal run.)

### 8. Create PR

```powershell
gh pr create --base dev --title "chore: update AXSharp package versions to <AxSharpVersion>" --body "<body>"
```

Use the template below for `<body>`, filling placeholders and pasting the script's
`Summary of changes:` lines as a bullet list. Report the resulting PR URL to the user.

#### PR body template

```markdown
## Update AXSharp / Inxton.Operon package versions

Bumps AXSharp.* and Inxton.Operon.* packages and reconciles transitive (third-party) dependencies
that AXSharp requires, via `scripts/update_axsharp_versions.ps1`.

### Target versions
- **AXSharp.\***: `<AxSharpVersion>`
- **Inxton.Operon.\***: `<OperonVersion>`

### Changes
- `.config/dotnet-tools.json` — tool versions bumped
- `Directory.Packages.props` — package versions + bump-up of pinned transitive deps
- `CHANGELOG.md` — `[DEPS]` entry prepended

<paste the script's "Summary of changes:" lines here as a bullet list>

### Verification
- [x] `dotnet run --project cake/Build.csproj -- --do-apax-update` succeeded

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

## Notes

- Script switches: `-DryRun`, `-Detailed`, `-ListAvailable`, `-AxSharpVersion`, `-OperonVersion`,
  `-SkipTransitive`, `-Source`, `-Token`, `-Username`, `-NormalizeJson`.
- Default PR base branch: `dev`.
- Build options live in [`cake/BuildParameters.cs`](../../../cake/BuildParameters.cs).
