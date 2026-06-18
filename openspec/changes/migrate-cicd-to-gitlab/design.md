## Context

All current GitHub Actions workflows are thin wrappers around a Cake.Frosting build: they run `dotnet build cake/Build.csproj` then `dotnet run --project cake/Build.csproj -- <flags>`. The "runners only call the pipeline" model therefore already exists. The repository's `origin` already points to `gitlab.mts.sk`.

The blocker for a GitLab pipeline is that Cake hardcodes three GitHub publish destinations:
- NuGet push → `https://nuget.pkg.github.com/inxton/index.json` (`cake/Program.cs`, `PushPackages`).
- apax publish → `https://npm.pkg.github.com` (`cake/ApaxCmd.cs`, `ApaxPublish`).
- GitHub Release via Octokit → `inxton/AXOpen` (`cake/Program.cs`, `PublishReleaseTask`).

Release gating lives in `cake/Helpers.cs` and keys on `GitVersionInformation.BranchName` (internal: `dev`/`main`/`master`/`release`/`releases/*`; public: `main`/`master`/`release`/`releases/*`). `GitVersionInformation` is generated at build time by GitVersion.MsBuild, so it depends on the checkout exposing full history, tags, and the real branch.

`build.ps1` calls `scripts/check_requisites.ps1`, which is interactive (`Read-Host`) and developer-only; CI must call Cake directly, as the GitHub workflows already do.

## Goals / Non-Goals

**Goals:**
- Keep Cake as the single source of truth; GitLab jobs stay thin wrappers.
- Make package push and release creation target-aware (GitLab or GitHub) via one option.
- Implement the requested pipeline: MR → build+test; `dev` → build+test → manual GitLab artefacts release → GitLab Pages → manual GitHub Packages push.
- Keep the GitHub path intact for rollback.

**Non-Goals:**
- Migrating `master.yml`, `release.yml`, `nightly.yml` (incl. its SHA-dedup state), or `codeql.yml` (these are follow-ups).
- L3/L4 hardware test jobs (PLC/PLCSIM) — only L1/L2 are wired this pass.
- Removing GitHub Packages or `.github/workflows/*` (retained for rollback).
- Repository mirroring between GitLab and GitHub.

## Decisions

### One `--publish-target gitlab|github` enum, not twin booleans
A single enum keeps the three publish sites coherent and prevents nonsensical mixes (e.g. NuGet→GitLab while Release→GitHub). `--do-publish`/`--do-publish-release` remain the *whether*; the enum is the *where*. Default **`github`**: the retained `.github/workflows/*` never pass the flag, so a `github` default keeps them working unchanged (the rollback guarantee). The `.gitlab-ci.yml` passes `--publish-target gitlab|github` explicitly on both publish stages, so the default never affects the GitLab pipeline. (Parsing is made case-insensitive via the CommandLineParser `CaseInsensitiveEnumValues` setting so the YAML can use lowercase values.) *Alternative considered:* default `gitlab` — rejected because it would silently break the retained GitHub workflows. *Alternative considered:* two booleans `--do-publish-gitlab`/`--do-publish-github` — rejected as more error-prone and harder to gate.

### Self-contained GitLab NuGet push (full URL + job token)
Push with the full project `index.json` URL as `Source` and `CI_JOB_TOKEN` as `ApiKey`, so no CI-side `nuget.config` or `dotnet nuget add source` step is needed and all logic stays in Cake. *Alternative considered:* register a named source in a `before_script` and push `--source gitlab` — rejected because it leaks publish wiring into the YAML.

### GitLab Release created inside Cake via the Releases API
Mirror the existing Octokit approach for symmetry and to keep release logic in Cake: `POST {CI_API_V4_URL}/projects/{CI_PROJECT_ID}/releases` with a `JOB-TOKEN` header, body `{ name, tag_name = SemVer, ref = Sha, description }`; GitLab auto-creates the tag. Use `System.Net.Http` — no new NuGet dependency. *Alternative considered:* the GitLab CI `release:`/release-cli keyword — rejected because it would move release logic out of Cake, against the architecture principle.

### GitVersion branch resolution: full clone + re-attach HEAD
GitLab's default shallow, detached-HEAD checkout makes GitVersion report a SHA, silently breaking branch gating. Set `GIT_DEPTH: 0` and, in a global `before_script`, run `git checkout -B "$BRANCH" "$CI_COMMIT_SHA"` (BRANCH from `CI_COMMIT_BRANCH`, falling back to the MR source branch). This is more robust than relying solely on GitVersion's build-server provider. Add a one-time `dotnet gitversion /showvariable BranchName` log line to confirm it prints `dev`.

### Linear stages with two manual gates
Stages `build-test → gitlab-release → pages → github-release`. The release stages reuse the build+test job's artifacts (`needs`/`dependencies`) so the published bits are exactly what was tested. `github-release` omits `-r`, so it pushes packages without creating a GitHub Release (decision 4 in the proposal). `pages` runs after `gitlab-release` (per the requested ordering), so docs redeploy on a manual release rather than on every `dev` push; switching to per-push deploys is a one-line rule change (`needs: [build-test:dev]`).

### Runners use PowerShell; artifact output dir is confirmed
The self-hosted GitLab runners are configured with the PowerShell executor, so **every `script:`/`before_script:` block is PowerShell**, not bash — e.g. `git checkout -B $env:CI_COMMIT_BRANCH $env:CI_COMMIT_SHA` and `Move-Item docs public`. The cross-job artifact paths are confirmed: `cake/Build.csproj` sets `<RunWorkingDirectory>$(MSBuildProjectDirectory)</RunWorkingDirectory>`, so `dotnet run --project cake/Build.csproj` always runs with working dir `repoRoot/cake` regardless of caller cwd; `BuildContext.Artifacts` (`WorkingDirectory/../artifacts`) therefore resolves to `repoRoot/artifacts`, giving `repoRoot/artifacts/nugets/*.nupkg` and `repoRoot/artifacts/apax/*` (and these are git-ignored). GitLab artifact paths relative to `CI_PROJECT_DIR` (= repoRoot) match exactly, so the build→publish split is sound.

## Risks / Trade-offs

- **apax → GitLab npm auth is unverified** → Implement a fallback gated by `AXO_APAX_USE_NPM_FALLBACK` that writes a transient project `.npmrc` (`@inxton` scope + `_authToken=$CI_JOB_TOKEN`) and runs `npm publish`. Resolve which path to use during the local make-or-break test (step 3 in Verification).
- **Releases API may reject the job token** → If `JOB-TOKEN` returns `401`/`403`, fall back to a masked `GITLAB_API_TOKEN` PAT via `PRIVATE-TOKEN`; ops must enable "CI/CD job token → API access" or provide the PAT.
- **GitVersion misresolves branch on GitLab** → `GIT_DEPTH: 0` + HEAD re-attach + a verification log line; if still wrong, gating would skip publishing (fail-safe, not a bad publish).
- **GitLab Pages not enabled on the instance** → Ops prerequisite; the `pages` job will no-op for serving until enabled. Confirm the exact Pages base URL from Settings → Pages before updating `docfx.json`/`README.md`.
- **Runner tag mismatch** → Jobs stay pending if no runner advertises `windows, x64, l2, ax`; register the existing Windows runners with these tags.

## Migration Plan

1. Implement the Cake changes (option, env detection, target branching, GitLab release helper, apax split + fallback).
2. Add `.gitlab-ci.yml`; update `docfx/docfx.json` sitemap base URL and `README.md` badges/links once the Pages URL is known.
3. Verify locally: `dotnet gitversion /showvariable BranchName` on `dev` → `dev`; `--do-pack --test-level 1` produces artifacts and the new option parses; a throwaway-project `--do-publish --publish-target gitlab` validates the apax path.
4. Verify on GitLab from a throwaway branch, then `dev`: MR runs build+test only; manual GitLab release populates the Package Registry and Releases; Pages renders; manual GitHub push lands packages with no GitHub Release.
5. **Rollback:** delete `.gitlab-ci.yml` or disable GitLab CI; `.github/workflows/*` remain and the GitHub publish path is preserved via `--publish-target github`.

## Open Questions

- Exact GitLab Pages base URL for `docfx.json`/`README.md` (read from Settings → Pages).
- Whether apax authenticates natively to the GitLab npm endpoint or the `.npmrc`/`npm publish` fallback is required (resolved by the local test).
- Whether the Releases API accepts `CI_JOB_TOKEN` on this instance or a `GITLAB_API_TOKEN` PAT is needed.
