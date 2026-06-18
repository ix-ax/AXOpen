## 1. Cake: publish-target option

- [x] 1.1 Add `PublishTarget { GitLab, GitHub }` enum and a `--publish-target` option (default `GitHub`, so retained GitHub workflows keep working) to `cake/BuildParameters.cs`; enable `CaseInsensitiveEnumValues` in the parser.
- [x] 1.2 Build `cake/Build.csproj` and confirm `--publish-target gitlab|github` parses case-insensitively.

## 2. Cake: GitLab environment detection

- [x] 2.1 In `cake/BuildContext.cs`, add `IsGitLabCI` plus `GitLabToken` (`CI_JOB_TOKEN`), `GitLabApiV4Url` (`CI_API_V4_URL`), `GitLabProjectId` (`CI_PROJECT_ID`), and `GitLabApiToken` (`GITLAB_API_TOKEN`) properties.
- [x] 2.2 Add computed `GitLabNuGetSource`, `GitLabNpmRegistry`, and `GitLabReleasesApi` URL properties (project-scoped).
- [x] 2.3 Set `IsGitLabCI = context.EnvironmentVariable("GITLAB_CI") == "true";` in the constructor (next to the `GITHUB_ACTIONS` line).
- [x] 2.4 In `cake/Program.cs` `CleanUpTask.Run`, force `CleanUp = true` when `IsGitHubActions || IsGitLabCI`.

## 3. Cake: per-target package push

- [x] 3.1 In `cake/Program.cs` `PushPackages`, keep the `Helpers.CanReleaseInternal()` gate and select NuGet `Source`/`ApiKey` from `BuildParameters.Target` (GitHub feed + `GitHubToken` vs `GitLabNuGetSource` + `GitLabToken`), keeping `SkipDuplicate = true`.
- [x] 3.2 In `PushPackages`, call `ApaxPublishGitHub()` or `ApaxPublishGitLab()` based on `Target`.

## 4. Cake: apax publisher split + fallback

- [x] 4.1 In `cake/ApaxCmd.cs`, rename the current `ApaxPublish` to `ApaxPublishGitHub` (behavior unchanged: login + publish against `npm.pkg.github.com`).
- [x] 4.2 Add `ApaxPublishGitLab` that logs in and publishes each `*.apax.tgz` to `GitLabNpmRegistry` using `CI_JOB_TOKEN`.
- [x] 4.3 In `ApaxPublishGitLab`, when `AXO_APAX_USE_NPM_FALLBACK` is set, write a transient project `.npmrc` (`@inxton` scope → GitLab npm registry, `_authToken=$CI_JOB_TOKEN`) and run `npm publish` per package instead; ensure `.npmrc` is not committed.

## 5. Cake: per-target release creation

- [x] 5.1 In `cake/Program.cs` `PublishReleaseTask`, keep the `CanReleaseInternal()` gate and branch on `Target`: GitHub → existing Octokit path; GitLab → new helper.
- [x] 5.2 Add a `CreateGitLabRelease` helper (using `System.Net.Http`) that POSTs to `GitLabReleasesApi` with `JOB-TOKEN` header and body `{ name, tag_name = SemVer, ref = Sha, description }`; no draft flag.
- [x] 5.3 On `401`/`403`, retry using `GITLAB_API_TOKEN` via a `PRIVATE-TOKEN` header.

## 6. Cake: gating note

- [x] 6.1 In `cake/Helpers.cs`, add a comment that branch gating now relies on the CI `git checkout -B` step to expose the real branch name (no logic change).

## 7. GitLab pipeline definition

> Runners use the **PowerShell** executor — every `script:`/`before_script:` block is PowerShell, not bash. Artifact output dir is confirmed `repoRoot/artifacts/{nugets,apax}` (`cake/Build.csproj` sets `RunWorkingDirectory=$(MSBuildProjectDirectory)`).

- [x] 7.1 Create `.gitlab-ci.yml` at repo root with stages `build-test → gitlab-release → pages → github-release`, `variables: GIT_DEPTH: "0"`, and `workflow:rules` to suppress duplicate branch+MR pipelines.
- [x] 7.2 Add a global `before_script` (PowerShell) that re-attaches HEAD: `$b = if ($env:CI_COMMIT_BRANCH) { $env:CI_COMMIT_BRANCH } else { $env:CI_MERGE_REQUEST_SOURCE_BRANCH_NAME }; git checkout -B $b $env:CI_COMMIT_SHA`, then log `dotnet gitversion /showvariable BranchName` once.
- [x] 7.3 Add `build-test:mr` (rule `$CI_PIPELINE_SOURCE == "merge_request_event"`; flags `--do-test --test-level 1 --do-template-test`; no artifacts).
- [x] 7.4 Add `build-test:dev` (rule `$CI_COMMIT_BRANCH == "dev"`; flags `--do-test --do-pack --test-level 2`; `artifacts: paths: [artifacts/nugets/*.nupkg, artifacts/apax/*]`, expire 1 day).
- [x] 7.5 Add `gitlab-release` (rule dev + `when: manual`; `needs/dependencies: [build-test:dev]`; flags `--do-publish-only --do-publish --do-publish-release --publish-target gitlab`).
- [x] 7.6 Add `pages` job (PowerShell): `needs: [gitlab-release]`; `dotnet tool restore` → `./scripts/_invoke_ixd.ps1` → `dotnet docfx metadata docfx/docfx.json` → `dotnet docfx build docfx/docfx.json --output docs/` → `Move-Item docs public` → `artifacts: paths: [public]`. (Docs deploy after the manual GitLab release; switch to `needs: [build-test:dev]` for per-push deploys.)
- [x] 7.7 Add `github-release` (rule dev + `when: manual`; `needs/dependencies: [build-test:dev]`; flags `--do-publish-only --do-publish --publish-target github`; no `-r`).
- [x] 7.8 Set runner `tags: [windows, x64, l2, ax]` on build/test/release/pages jobs.

## 8. Docs and metadata

- [x] 8.1 Update `docfx/docfx.json` `sitemap.baseUrl` to the GitLab Pages URL (confirm from Settings → Pages).
- [x] 8.2 Update `README.md` (badges ~lines 3–5, docs link ~line 114) to GitLab pipeline/release badges and the GitLab Pages docs URL.

## 9. GitLab project setup (ops prerequisites)

- [ ] 9.1 Add masked/protected CI/CD variables `GH_TOKEN`, `GH_USER`, and optional `GITLAB_API_TOKEN`.
- [ ] 9.2 Enable Package Registry and Pages; allow CI job-token API access (or rely on the PAT).
- [ ] 9.3 Register the Windows runners with tags `windows, x64, l2, ax`.

## 10. Verification

- [x] 10.1 Local: `dotnet gitversion /showvariable BranchName` on `dev` prints `dev`; then `/showvariable SemVer`.
- [ ] 10.2 Local: `dotnet build cake/Build.csproj` + `dotnet run --project cake/Build.csproj -- --do-pack --test-level 1` produces `artifacts/nugets/*.nupkg` and `artifacts/apax/*.apax.tgz`.
- [ ] 10.3 Local: with `CI_API_V4_URL`/`CI_PROJECT_ID`/`CI_JOB_TOKEN` set, run `--do-publish-only --do-publish --publish-target gitlab` against a throwaway GitLab project; if apax 4xx's, set `AXO_APAX_USE_NPM_FALLBACK` and retry.
- [ ] 10.4 GitLab (branch `ci/gitlab-migration` then `dev`): MR runs only `build-test:mr`; manual `gitlab-release` populates Package Registry + Releases; `pages` renders; manual `github-release` lands packages in GitHub Packages with no GitHub Release.
- [x] 10.5 Confirm rollback: removing `.gitlab-ci.yml` leaves `.github/workflows/*` and the `--publish-target github` path intact.
