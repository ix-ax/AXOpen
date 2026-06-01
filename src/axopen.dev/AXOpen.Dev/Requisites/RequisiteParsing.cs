using System.Text.RegularExpressions;

namespace AXOpen.Dev.Requisites;

/// <summary>
/// Pure parsing helpers for the tool outputs consumed by <c>scripts/check_requisites.ps1</c>
/// (node -v, git --version, dotnet --list-sdks / --list-runtimes, reg query).
/// </summary>
public static partial class RequisiteParsing
{
    [GeneratedRegex(@"[0-9]+\.[0-9]+\.[0-9]+")]
    private static partial Regex SemVerPattern();

    [GeneratedRegex(@"^Microsoft\.WindowsDesktop\.App\s+([\d\.]+)\s")]
    private static partial Regex DesktopRuntimePattern();

    /// <summary><c>(node -v).TrimStart('v')</c>.</summary>
    public static string ParseNodeVersion(string nodeDashV)
        => (nodeDashV ?? string.Empty).Trim().TrimStart('v');

    /// <summary>First <c>x.y.z</c> match in <c>git --version</c> output, or null.</summary>
    public static string? ExtractGitVersion(string gitVersionOutput)
    {
        var match = SemVerPattern().Match(gitVersionOutput ?? string.Empty);
        return match.Success ? match.Value : null;
    }

    /// <summary>True when any <c>dotnet --list-sdks</c> line starts with the required version followed by whitespace.</summary>
    public static bool DotnetSdkListed(IEnumerable<string> sdkLines, string requiredVersion)
    {
        var pattern = new Regex("^" + Regex.Escape(requiredVersion) + @"\s");
        return sdkLines.Any(line => pattern.IsMatch(line));
    }

    /// <summary>
    /// True when <c>dotnet --list-runtimes</c> contains a <c>Microsoft.WindowsDesktop.App</c> whose version
    /// satisfies <see cref="VersionComparer.MajorMinorEqualBuildRevisionEqualOrHigher"/> against the requirement.
    /// </summary>
    public static bool HasDesktopRuntime(IEnumerable<string> runtimeLines, string requiredVersion)
    {
        foreach (var line in runtimeLines)
        {
            var match = DesktopRuntimePattern().Match(line);
            if (match.Success && VersionComparer.MajorMinorEqualBuildRevisionEqualOrHigher(match.Groups[1].Value, requiredVersion))
            {
                return true;
            }
        }

        return false;
    }

    /// <summary>Extracts a REG_SZ value from <c>reg query ... /v Name</c> output (the token after the type).</summary>
    public static string? ExtractRegValue(string regQueryOutput, string valueName)
    {
        foreach (var raw in (regQueryOutput ?? string.Empty).Split('\n'))
        {
            var line = raw.Trim();
            if (line.StartsWith(valueName, StringComparison.OrdinalIgnoreCase) && line.Contains("REG_"))
            {
                // Format: "Name    REG_SZ    value"
                var parts = Regex.Split(line, @"\s{2,}|\t+");
                if (parts.Length >= 3)
                {
                    return parts[^1].Trim();
                }
            }
        }

        return null;
    }
}
