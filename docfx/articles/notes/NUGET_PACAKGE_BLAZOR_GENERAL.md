
**NuGet Package Feed (Blazor Packages)**

This note applies specifically to the AXOpen Blazor UI / integration packages but defers to the consolidated guidance in `NUGET_PACAKGE_GENERAL.md`.

> [!TIP]
> If you have already added the `gh-packages-inxton` source (see general doc) you do not need to repeat configuration for Blazor packages.

Common package IDs (examples):

* `AXOpen.Core.Blazor`
* `AXOpen.Integrations.Blazor`
* `AXOpen.Security` (UI components depend on this for auth views)

Add (only if not already configured):

```bash
dotnet nuget add source \
	--username YOUR_GITHUB_USERNAME \
	--password YOUR_GITHUB_PAT \
	--store-password-in-clear-text \
	--name gh-packages-inxton \
	"https://nuget.pkg.github.com/inxton/index.json"
```

### Version Strategy

Blazor surface changes (Razor components, CSS/JS assets) may introduce subtle breakage if versions drift from backend core packages. Keep UI and core packages on identical versions to avoid mismatched rendering metadata or missing layout attributes.

### Asset Resolution

Static assets (icons, css, JS) are served via the standard `_content/{PackageId}/...` path. When creating composite libraries, re-export or document the asset path rather than copying files into the host app to reduce duplication.

### Debugging UI Package Issues

| Symptom | Likely Cause | Suggested Fix |
|---------|--------------|---------------|
| 404 on `_content/...` | Static web assets not referenced (missing package ref) | Confirm `<PackageReference>` present & rebuild |
| Missing styles | Theme CSS not selected / cookie unset | Inspect cookies, verify theme asset existence |
| Auth views blank | `ConfigureAxBlazorSecurity` not called or DI mismatch | Check `Program.cs` configuration order |

For adding or updating the feed, contribution, or advanced scenarios (mirroring, offline caches) see `NUGET_PACAKGE_GENERAL.md`.



