using System.Text.Json;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Process;

namespace AXOpen.Dev.Requisites;

/// <summary>
/// Cross-platform, report-only prerequisite checks. Ports <c>check_requisites_apax.sh</c>,
/// <c>check_requisites_nuget.sh</c> and <c>check_requisites_custom_registry.ps1</c>. No auto-install.
/// </summary>
public sealed class RequisiteChecker(IProcessRunner runner)
{
    public const string ApaxSite = "https://console.simatic-ax.siemens.io/";
    public const string NugetFeed = "https://nuget.pkg.github.com/inxton/index.json";
    public const string NpmRegistry = "https://npm.pkg.github.com/";
    public const string ExpectedApaxVersion = "4.3.0";

    public async Task<bool> CheckApaxAsync(CancellationToken ct = default)
    {
        var version = await runner.RunAsync(new ProcessRequest
        {
            Executable = "apax",
            Arguments = new[] { "--version" },
            EchoToConsole = false,
        }, ct);

        if (!version.Success)
        {
            Output.Error("Apax is not installed or not found in PATH. You need a valid SIMATIC-AX license.");
            return false;
        }

        var found = version.StandardOutput.Trim();
        if (found != ExpectedApaxVersion)
        {
            Output.Error($"Apax version mismatch. Expected {ExpectedApaxVersion} but found {found}. Run 'apax self-update {ExpectedApaxVersion}'.");
            return false;
        }

        Output.Success($"Apax {ExpectedApaxVersion} detected.");

        if (!await IsHttpReachableAsync(ApaxSite, ct))
        {
            Output.Error($"Failed to access {ApaxSite}. Check your connection, firewall, credentials, etc.");
            return false;
        }

        Output.Success($"Feed {ApaxSite} accessible.");

        var scopes = await runner.RunAsync(new ProcessRequest
        {
            Executable = "apax",
            Arguments = new[] { "info", "--ax-scopes" },
            EchoToConsole = false,
        }, ct);

        if ((scopes.StandardOutput + scopes.StandardError).Contains("No access to the Simatic-AX registry", StringComparison.OrdinalIgnoreCase))
        {
            Output.Error("Unable to access apax registries. Check your connection, firewall, credentials, etc.");
            return false;
        }

        Output.Success("Apax registries are accessible.");
        return true;
    }

    public async Task<bool> CheckNugetAsync(CancellationToken ct = default)
    {
        var sources = await runner.RunAsync(new ProcessRequest
        {
            Executable = "dotnet",
            Arguments = new[] { "nuget", "list", "source" },
            EchoToConsole = false,
        }, ct);

        if (!sources.StandardOutput.Contains(NugetFeed, StringComparison.OrdinalIgnoreCase))
        {
            Output.Error($"The NuGet feed {NugetFeed} is not added. Add it manually (see src/README.md).");
            return false;
        }

        Output.Success($"The NuGet feed {NugetFeed} is added.");
        return true;
    }

    public bool CheckCustomRegistry()
    {
        var authPath = Path.Combine(UserProfileDirectory(), ".apax", "auth.json");
        if (!File.Exists(authPath))
        {
            Output.Error($"apax auth file not found at {authPath}. Run 'apax login' for the custom NPM registry.");
            return false;
        }

        if (AuthJsonHasRegistry(File.ReadAllText(authPath), NpmRegistry))
        {
            Output.Success($"Registry {NpmRegistry} found in apax auth.");
            return true;
        }

        Output.Error($"Registry '{NpmRegistry}' not found in apax auth. Run 'apax login' for the custom NPM registry.");
        return false;
    }

    /// <summary>True when the auth json contains the registry with a non-empty registryToken.</summary>
    public static bool AuthJsonHasRegistry(string json, string registryUrl)
    {
        try
        {
            using var doc = JsonDocument.Parse(json);
            return doc.RootElement.TryGetProperty(registryUrl, out var registry)
                   && registry.TryGetProperty("registryToken", out var token)
                   && token.ValueKind == JsonValueKind.String
                   && !string.IsNullOrEmpty(token.GetString());
        }
        catch (JsonException)
        {
            return false;
        }
    }

    private static string UserProfileDirectory()
        => Environment.GetEnvironmentVariable("USERPROFILE")
           ?? Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);

    private static async Task<bool> IsHttpReachableAsync(string url, CancellationToken ct)
    {
        try
        {
            using var client = new HttpClient { Timeout = TimeSpan.FromSeconds(15) };
            using var response = await client.GetAsync(url, ct);
            return (int)response.StatusCode == 200;
        }
        catch
        {
            return false;
        }
    }
}
