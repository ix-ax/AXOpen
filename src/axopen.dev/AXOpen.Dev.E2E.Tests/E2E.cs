namespace AXOpen.Dev.E2E.Tests;

/// <summary>
/// Environment-driven configuration + gating for the optional end-to-end tests. All tests are
/// skipped unless their flag env var is set; PLC tests additionally need connection settings.
/// Defaults target the showcase app + its PLCSIM Advanced instance.
/// </summary>
internal static class E2E
{
    // Gating flags (set to "1"/"true" to enable that tier):
    public const string DataFlag = "AXDEV_E2E_DATA";                       // read-only, needs only the app dir
    public const string PlcFlag = "AXDEV_E2E_PLC";                         // read-only, needs a provisioned PLC
    public const string ProvisionFlag = "AXDEV_E2E_PLC_DESTRUCTIVE";       // provisions/overwrites the PLC

    public static bool Enabled(string flag) =>
        Environment.GetEnvironmentVariable(flag) is "1" or "true" or "TRUE";

    public static string Target => Get("AX_TARGET", "192.168.100.1");
    public static string PlcName => Get("AX_PLC_NAME", "plc_line");
    public static string Username => Get("AX_USERNAME", "admin");
    public static string Password => Environment.GetEnvironmentVariable("AX_TARGET_PWD") ?? string.Empty;
    public static string Namespace => Get("AX_NAMESPACE", "AXOpen.Showcase");
    public static string Platform => Get("AX_PLATFORM", @".\bin\1500\");

    /// <summary>The apax app directory the commands run in (relative paths resolve against it).</summary>
    public static string AppDirectory => Get("AX_APP_DIR", DiscoverAppDirectory());

    /// <summary>Set the process CWD to the app directory (commands use ./certs, ./hwc, etc.).</summary>
    public static void EnterAppDirectory() => Directory.SetCurrentDirectory(AppDirectory);

    private static string Get(string key, string fallback)
    {
        var value = Environment.GetEnvironmentVariable(key);
        return string.IsNullOrEmpty(value) ? fallback : value;
    }

    private static string DiscoverAppDirectory()
    {
        // Walk up from the test output directory until we find src/showcase/app/apax.yml.
        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        while (dir is not null)
        {
            var candidate = Path.Combine(dir.FullName, "src", "showcase", "app");
            if (File.Exists(Path.Combine(candidate, "apax.yml")))
            {
                return candidate;
            }

            dir = dir.Parent;
        }

        return Directory.GetCurrentDirectory();
    }
}

/// <summary>A <see cref="FactAttribute"/> that skips unless its gating env flag is enabled.</summary>
public sealed class E2EFactAttribute : FactAttribute
{
    public E2EFactAttribute(string flag)
    {
        if (!E2E.Enabled(flag))
        {
            Skip = $"End-to-end test disabled. Set {flag}=1 (and the AX_* connection env vars) to run it.";
        }
    }
}
