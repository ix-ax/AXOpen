
**NuGet Package Feed**

> [!IMPORTANT]
> AXOpen NuGet packages are currently published from a single (monorepo) source. Treat releases as cohesive sets; mixing unrelated versions is discouraged.

The feed is hosted on GitHub Packages. See official GitHub docs for authentication: [Using the NuGet registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-nuget-registry).

Add the feed:

~~~bash
dotnet nuget add source \
	--username YOUR_GITHUB_USERNAME \
	--password YOUR_GITHUB_PAT \
	--store-password-in-clear-text \
	--name gh-packages-inxton \
	"https://nuget.pkg.github.com/inxton/index.json"
~~~

Replace:
* `YOUR_GITHUB_USERNAME` with your GitHub handle.
* `YOUR_GITHUB_PAT` with a Personal Access Token having `read:packages` (and `write:packages` if you publish).

> [!NOTE]
> Version Alignment: All AXOpen packages share synchronized version numbers (semantic versioning). Always try to consume the same version across the set. Mixing majors will very likely produce runtime or source incompatibilities. Minor/patch divergence is technically possible but not tested as a matrix; proceed only if you fully understand the public surface differences.

### Recommended Consumer Workflow

1. Add/refresh the source (above) once per dev machine.
2. Pin explicit versions in your `.csproj` – avoid floating versions (`*`).
3. When upgrading, bump all AXOpen package references in a single commit/PR.
4. Review the CHANGELOG for breaking notes between majors before updating.

### Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| 401 Unauthorized | Missing / invalid PAT scope | Regenerate PAT with `read:packages` |
| 404 Package not found | Source not added or typo in ID | Re-run add source / verify package ID |
| Version conflict | Mixed versions pulled transitively | Align direct references to same version |

### Publishing (Maintainers)

Publishing is handled by CI. Manual publish should only be done for emergency hotfixes; ensure GitVersion tags follow the established convention before triggering release workflows.



