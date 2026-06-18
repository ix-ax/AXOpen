## Why

AXOpen is moving its CI/CD infrastructure from GitHub Actions to a self-managed GitLab instance (`gitlab.mts.sk`; `origin` already points there). The build logic is centralized in Cake.Frosting and must stay that way, but Cake currently **hardcodes three GitHub publish destinations** (NuGet feed, apax/npm registry, GitHub Releases), so it cannot run a GitLab pipeline. This change parametrizes those destinations and adds a thin `.gitlab-ci.yml` so the existing Cake build drives a GitLab pipeline without duplicating build logic.

## What Changes

- Add a `--publish-target gitlab|github` option to the Cake build; package push and release creation branch on it. Default `github` (keeps the retained `.github/workflows/*` working unchanged; the GitLab pipeline passes the flag explicitly).
- Teach the Cake build to detect GitLab CI and read GitLab's predefined variables (`CI_API_V4_URL`, `CI_PROJECT_ID`, `CI_JOB_TOKEN`) for the GitLab Package Registry (NuGet + npm/apax) and the GitLab Releases API.
- Split apax publishing into GitHub and GitLab variants, with an `npm publish` + `.npmrc` fallback (gated by `AXO_APAX_USE_NPM_FALLBACK`) because apax→GitLab-npm auth is unverified.
- Create GitLab Releases from Cake via the Releases API (replacing the GitHub Octokit release on the GitLab path); the GitHub Octokit path remains for rollback.
- Add `.gitlab-ci.yml` implementing: **Merge Request** → build + test only; **`dev` branch** → `build+test` → *(manual gate)* GitLab artefacts release → GitLab Pages build & deploy → *(manual gate)* GitHub Packages push.
- Ensure GitVersion resolves the real branch name under GitLab's shallow/detached-HEAD checkout (`GIT_DEPTH: 0` + re-attach HEAD), so the existing branch-based release gating keeps working.
- Move the docfx documentation site from GitHub Pages to **GitLab Pages**.
- Update `docfx/docfx.json` sitemap base URL and `README.md` badges/links to GitLab.
- **No change** to `build.ps1` / `scripts/check_requisites.ps1`; `.github/workflows/*` are left intact this pass for a clean rollback.

## Capabilities

### New Capabilities
- `build-publish-targets`: The Cake build can select GitLab or GitHub as the destination for package push (NuGet + apax) and release creation, detecting the CI environment and resolving registry/release endpoints and credentials per target, while preserving existing branch-based release gating.
- `gitlab-ci-pipeline`: A GitLab CI pipeline that orchestrates Merge Request build+test and the staged `dev`-branch flow (build+test → manual GitLab artefacts release → Pages deploy → manual GitHub Packages push) as thin wrappers over the Cake build, with correct runner targeting and GitVersion branch resolution.

### Modified Capabilities
<!-- None. Existing specs (showcase-*) are unaffected by the CI/CD migration. -->

## Impact

- **Cake build sources**: `cake/BuildParameters.cs`, `cake/BuildContext.cs`, `cake/Program.cs`, `cake/ApaxCmd.cs`, `cake/Helpers.cs`.
- **New file**: `.gitlab-ci.yml` (repo root).
- **Docs/metadata**: `docfx/docfx.json` (sitemap base URL), `README.md` (badges + docs link).
- **External systems**: GitLab Package Registry (NuGet + npm), GitLab Releases, GitLab Pages on `gitlab.mts.sk`; GitHub Packages retained as a publish target. GitHub Releases and GitHub Pages deploys are retired from the active pipeline.
- **Ops prerequisites** (not code): GitLab CI/CD variables `GH_TOKEN`, `GH_USER` (masked/protected), optional `GITLAB_API_TOKEN`; Package Registry + Pages enabled; CI job-token API access (or PAT); Windows runners registered with tags `windows, x64, l2, ax`.
- **Out of scope (follow-ups)**: GitLab equivalents for `master.yml`/`release.yml` (L3/APP, test-level 100), `nightly.yml` (incl. SHA-dedup state), `codeql.yml` → GitLab SAST; retiring GitHub Packages once GitLab consumption is proven.
