
**Apax Package Registry**

> [!IMPORTANT]
> AXOpen Apax (SIMATIC AX) packages are published from the shared monorepo; keep versions aligned analogous to the NuGet guidance.

Registry is hosted on GitHub Packages (npm endpoint). Authentication references:
* Siemens AX docs (external registries): <https://console.simatic-ax.siemens.io/docs/faq/login-to-external-registries>
* GitHub PAT management: <https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens>

Login:

```bash
apax login --registry https://npm.pkg.github.com --username YOUR_GITHUB_USERNAME --password YOUR_GITHUB_PAT
```

`apax.yml` snippet:

```yml
registries:
  "@inxton": https://npm.pkg.github.com/
```

> [!NOTE]
> Version Alignment: Use the same version across all `@inxton` scoped packages whenever possible. Diverging major versions is unsupported; minor/patch divergence is untested and should be a temporary measure only.

### Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| 401 Unauthorized | PAT missing `read:packages` | Recreate PAT with required scope |
| 404 Not Found | Registry not listed in `apax.yml` | Add registry block & retry |
| Version mismatch build errors | Mixed major versions | Align all package versions |

### Updating Packages
1. Adjust versions in `apax.yml` / package manifest.
2. Run `apax install` to refresh.
3. Commit the version change as a cohesive set.

### Publishing (Maintainers)
CI handles publish. For exceptional manual publish ensure tags follow semantic versioning and coordinate with NuGet release to keep parity.



