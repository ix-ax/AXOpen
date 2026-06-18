## ADDED Requirements

### Requirement: Jobs are thin wrappers over the Cake build

Every pipeline job that builds, tests, or publishes SHALL invoke the Cake build directly via `dotnet build cake/Build.csproj` followed by `dotnet run --project cake/Build.csproj -- <flags>`. The pipeline definition SHALL NOT contain build or publish logic of its own. Jobs SHALL NOT call `build.ps1` (it runs the interactive `scripts/check_requisites.ps1`). Destination and credentials SHALL be supplied to Cake through GitLab predefined variables (`CI_API_V4_URL`, `CI_PROJECT_ID`, `CI_JOB_TOKEN`) rather than encoded in the YAML.

#### Scenario: Build/test/publish job invokes Cake

- **WHEN** any build, test, or publish job runs
- **THEN** its script builds and runs `cake/Build.csproj` with flags, and never invokes `build.ps1`

### Requirement: Merge Request pipeline runs build and test only

For Merge Request pipelines (`$CI_PIPELINE_SOURCE == "merge_request_event"`), the pipeline SHALL run a single build+test job equivalent to the former PR check (`--do-test --test-level 1 --do-template-test`). It SHALL NOT pack, publish, or release, and SHALL NOT deploy Pages.

#### Scenario: MR opened

- **WHEN** a Merge Request pipeline runs
- **THEN** only the build+test job runs, with no packaging, publishing, release, or Pages deploy

### Requirement: dev branch staged pipeline with manual gates

For pipelines on the `dev` branch, the pipeline SHALL define stages in this order: build+test, GitLab artefacts release, Pages, GitHub Packages push. The build+test stage SHALL run `--do-test --do-pack --test-level 2` and expose the produced `artifacts/nugets/*.nupkg` and `artifacts/apax/*` as job artifacts. The GitLab artefacts release stage and the GitHub Packages push stage SHALL each require a manual trigger (`when: manual`). Workflow rules SHALL prevent duplicate branch and Merge Request pipelines.

#### Scenario: dev push runs build and test automatically

- **WHEN** a commit is pushed to `dev`
- **THEN** the build+test job runs automatically and produces NuGet and apax artifacts

#### Scenario: Release stages are gated

- **WHEN** the build+test job has completed on `dev`
- **THEN** the GitLab artefacts release and GitHub Packages push stages remain blocked until manually triggered

### Requirement: GitLab artefacts release stage

The GitLab artefacts release stage SHALL reuse the tested artifacts from the build+test job and run Cake with `--do-publish-only --do-publish --do-publish-release --publish-target gitlab`. It SHALL publish NuGet packages and apax packages to the GitLab Package Registry and create a GitLab Release.

#### Scenario: Manual GitLab release

- **WHEN** the GitLab artefacts release stage is manually triggered on `dev`
- **THEN** NuGet packages and `@inxton/*` apax packages appear in the GitLab Package Registry and a SemVer-named entry appears under the project's Releases

### Requirement: Pages build and deploy to GitLab Pages

The pipeline SHALL include a job named `pages` that builds the docfx documentation site and publishes it to GitLab Pages. The job SHALL restore dotnet tools, generate ctrl API metadata via `scripts/_invoke_ixd.ps1`, run `dotnet docfx metadata docfx/docfx.json` and `dotnet docfx build docfx/docfx.json --output docs/`, move the output into `public/`, and expose `public/` as a job artifact.

#### Scenario: Pages deploy on dev

- **WHEN** the `pages` job runs on `dev`
- **THEN** the docfx site is built into `public/` and served by GitLab Pages

### Requirement: GitHub Packages push stage without GitHub Release

The GitHub Packages push stage SHALL reuse the tested artifacts and run Cake with `--do-publish-only --do-publish --publish-target github` and SHALL NOT pass `--do-publish-release`. It SHALL push NuGet and apax packages to GitHub Packages and SHALL NOT create a GitHub Release. The stage SHALL require a manual trigger and SHALL use `GH_TOKEN` and `GH_USER` CI variables.

#### Scenario: Manual GitHub packages push

- **WHEN** the GitHub Packages push stage is manually triggered on `dev`
- **THEN** packages are published to GitHub Packages and no GitHub Release is created

### Requirement: GitVersion branch resolution under GitLab checkout

The pipeline SHALL configure a full clone (`GIT_DEPTH: 0`) so GitVersion has full history and tags, and SHALL re-attach HEAD to the real branch before building so GitVersion resolves a branch name (not a detached SHA). On branch pipelines this SHALL use `CI_COMMIT_BRANCH`; on Merge Request pipelines it MAY use the source branch name. This guarantees the Cake release gating sees the correct branch.

#### Scenario: GitVersion resolves dev

- **WHEN** a pipeline runs on the `dev` branch with the full clone and HEAD re-attached
- **THEN** GitVersion reports the branch name as `dev` and release gating behaves as on `dev`

### Requirement: Runner targeting via tags

Build, test, release, and Pages jobs SHALL target self-hosted Windows runners via GitLab tags `windows, x64, l2, ax`, mapping the former GitHub self-hosted labels. Jobs requiring PLC hardware for higher test levels are out of scope for this pass and will use `l3`/`app` tag sets when added.

#### Scenario: Job runs on a tagged Windows runner

- **WHEN** any build/test/release/Pages job is scheduled
- **THEN** it runs on a runner tagged `windows, x64, l2, ax`
