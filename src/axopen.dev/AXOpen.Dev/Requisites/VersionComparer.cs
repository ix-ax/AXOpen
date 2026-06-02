using System.Text.RegularExpressions;

namespace AXOpen.Dev.Requisites;

/// <summary>
/// Faithful port of the version-comparison helpers in <c>scripts/check_requisites.ps1</c>.
/// PowerShell's <c>[version]</c> cast maps to <see cref="System.Version"/>, where unspecified
/// components are <c>-1</c> (so <c>8.0</c> &lt; <c>8.0.0</c>). The comparisons preserve that semantics.
/// </summary>
public static partial class VersionComparer
{
    [GeneratedRegex(@"^\d+\.\d+(\.\d+){0,2}$")]
    private static partial Regex RequiredVersionPattern();

    /// <summary>Mirrors the guard each Verify* function applies to its <c>RequiredVersion</c> parameter.</summary>
    public static bool IsValidRequiredVersion(string requiredVersion)
        => !string.IsNullOrEmpty(requiredVersion) && RequiredVersionPattern().IsMatch(requiredVersion);

    /// <summary>MajorMinorBuildRevisionEqual — actual version equals the required version exactly.</summary>
    public static bool Equal(string actualVersion, string requiredVersion)
        => Version.Parse(actualVersion) == Version.Parse(requiredVersion);

    /// <summary>MajorMinorBuildRevisionEqualOrHigher — actual version is greater than or equal to required.</summary>
    public static bool EqualOrHigher(string actualVersion, string requiredVersion)
        => Version.Parse(actualVersion) >= Version.Parse(requiredVersion);

    /// <summary>MajorMinorEqualBuildRevisionEqualOrHigher — major+minor equal, build+revision &gt;= required.</summary>
    public static bool MajorMinorEqualBuildRevisionEqualOrHigher(string actualVersion, string requiredVersion)
    {
        var actual = Version.Parse(actualVersion);
        var required = Version.Parse(requiredVersion);
        return actual.Major == required.Major
               && actual.Minor == required.Minor
               && actual.Build >= required.Build
               && actual.Revision >= required.Revision;
    }

    /// <summary>MajorMinorBuildEqualRevisionEqualOrHigher — major+minor+build equal, revision &gt;= required.</summary>
    public static bool MajorMinorBuildEqualRevisionEqualOrHigher(string actualVersion, string requiredVersion)
    {
        var actual = Version.Parse(actualVersion);
        var required = Version.Parse(requiredVersion);
        return actual.Major == required.Major
               && actual.Minor == required.Minor
               && actual.Build == required.Build
               && actual.Revision >= required.Revision;
    }
}
