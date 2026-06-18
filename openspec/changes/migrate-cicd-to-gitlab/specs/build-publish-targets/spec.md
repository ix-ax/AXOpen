## ADDED Requirements

### Requirement: Selectable publish target

The Cake build SHALL accept a `--publish-target` option whose value is `gitlab` or `github`, defaulting to `github`. The option SHALL select the destination for package push and release creation. Parsing SHALL be case-insensitive. The existing `--do-publish` and `--do-publish-release` flags SHALL continue to control *whether* publishing/release happens; `--publish-target` controls *where*. The default is `github` so the retained GitHub workflows (which never pass the flag) keep their original behavior; the GitLab pipeline always passes the flag explicitly.

#### Scenario: Default target is GitHub

- **WHEN** the build runs with `--do-publish` and no `--publish-target` flag
- **THEN** packages are pushed to the GitHub destination

#### Scenario: Explicit GitHub target

- **WHEN** the build runs with `--do-publish --publish-target github`
- **THEN** packages are pushed to the GitHub destination

#### Scenario: Case-insensitive value

- **WHEN** the build runs with `--publish-target GitHub` or `--publish-target GITHUB`
- **THEN** the value is parsed as the GitHub target without error

### Requirement: GitLab CI environment detection

The Cake build SHALL detect that it is running under GitLab CI when the environment variable `GITLAB_CI` equals `"true"`, exposing this as `IsGitLabCI`. It SHALL read `CI_JOB_TOKEN`, `CI_API_V4_URL`, `CI_PROJECT_ID`, and an optional `GITLAB_API_TOKEN` from the environment. When running under GitLab CI, the build SHALL force the clean-up step on, matching the existing behavior under GitHub Actions.

#### Scenario: Detect GitLab CI

- **WHEN** the build runs with `GITLAB_CI=true` in the environment
- **THEN** `IsGitLabCI` is true and clean-up is forced on

#### Scenario: Resolve GitLab endpoints from CI variables

- **WHEN** `CI_API_V4_URL` and `CI_PROJECT_ID` are set
- **THEN** the build derives the GitLab NuGet source, npm registry, and Releases API URLs from those project-scoped values

### Requirement: Per-target package push destinations

When `--do-publish` is set and release gating allows it, the Cake build SHALL push NuGet packages and apax packages to the destination matching the selected target. For GitHub, the NuGet source SHALL be `https://nuget.pkg.github.com/inxton/index.json` with the GitHub token, and apax SHALL publish to `https://npm.pkg.github.com`. For GitLab, the NuGet source SHALL be the project-scoped GitLab NuGet `index.json` with `CI_JOB_TOKEN` as the API key, and apax SHALL publish to the project-scoped GitLab npm registry. NuGet pushes SHALL skip duplicates.

#### Scenario: Push to GitLab registry

- **WHEN** the build runs with `--do-publish --publish-target gitlab` on a release-eligible branch
- **THEN** each `.nupkg` is pushed to the GitLab project NuGet feed using `CI_JOB_TOKEN`, and each apax package is published to the GitLab npm registry

#### Scenario: Push to GitHub packages

- **WHEN** the build runs with `--do-publish --publish-target github` on a release-eligible branch
- **THEN** each `.nupkg` is pushed to `nuget.pkg.github.com/inxton` and each apax package is published to `npm.pkg.github.com`

### Requirement: apax GitLab publish with npm fallback

The Cake build SHALL provide separate apax publishers for GitHub and GitLab. The GitHub publisher SHALL retain the existing `apax login` + `apax publish` behavior against `npm.pkg.github.com`. The GitLab publisher SHALL attempt `apax login`/`apax publish` against the GitLab npm registry using `CI_JOB_TOKEN`. When the environment variable `AXO_APAX_USE_NPM_FALLBACK` is set, the GitLab publisher SHALL instead write a project-scoped `.npmrc` (with the `@inxton` scope mapped to the GitLab npm registry and an `_authToken` of `CI_JOB_TOKEN`) and run `npm publish` for each package. The `.npmrc` SHALL NOT be committed to the repository.

#### Scenario: apax native publish to GitLab

- **WHEN** the GitLab apax publisher runs and `AXO_APAX_USE_NPM_FALLBACK` is not set
- **THEN** it logs in and publishes each `*.apax.tgz` to the GitLab npm registry via apax

#### Scenario: npm fallback publish to GitLab

- **WHEN** the GitLab apax publisher runs and `AXO_APAX_USE_NPM_FALLBACK` is set
- **THEN** it writes a transient `.npmrc` and publishes each package via `npm publish`

### Requirement: Per-target release creation

When `--do-publish-release` is set and release gating allows it, the Cake build SHALL create a release on the destination matching the selected target. For GitLab, it SHALL POST to the GitLab Releases API with `tag_name` set to the GitVersion SemVer and `ref` set to the GitVersion SHA, authenticating with `CI_JOB_TOKEN` via a `JOB-TOKEN` header and falling back to `GITLAB_API_TOKEN` via a `PRIVATE-TOKEN` header on `401`/`403`. For GitHub, it SHALL retain the existing Octokit release behavior. The GitLab release SHALL NOT use a draft flag (GitLab has no draft concept).

#### Scenario: Create GitLab release

- **WHEN** the build runs with `--do-publish-release --publish-target gitlab` on a release-eligible branch
- **THEN** a GitLab Release is created with the SemVer tag at the build SHA, and GitLab auto-creates the tag from `ref`

#### Scenario: Releases API auth fallback

- **WHEN** the GitLab Releases API call returns `401` or `403` for the `JOB-TOKEN` header
- **THEN** the build retries using `GITLAB_API_TOKEN` as a `PRIVATE-TOKEN`

#### Scenario: GitHub stage creates no release when flag omitted

- **WHEN** the build runs with `--do-publish --publish-target github` and without `--do-publish-release`
- **THEN** packages are pushed to GitHub but no GitHub Release is created

### Requirement: Branch-based release gating preserved across CI environments

The existing branch-based release gating SHALL remain unchanged in logic: internal publishing is allowed on `dev`, `main`, `master`, `release`, or any `releases/*` branch, and public release on `main`, `master`, `release`, or `releases/*`. Gating SHALL continue to key on the GitVersion-resolved branch name, which requires the CI environment to present the real branch (not a detached HEAD).

#### Scenario: Internal publish allowed on dev

- **WHEN** the GitVersion-resolved branch name is `dev`
- **THEN** internal publishing (package push) is allowed and public release is not
