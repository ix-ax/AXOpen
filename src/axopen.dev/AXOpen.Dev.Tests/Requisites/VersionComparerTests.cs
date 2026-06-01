using AXOpen.Dev.Requisites;

namespace AXOpen.Dev.Tests.Requisites;

public sealed class VersionComparerTests
{
    [Theory]
    [InlineData("8.0", true)]
    [InlineData("8.0.2", true)]
    [InlineData("16.11.36631.11", true)]
    [InlineData("8", false)]
    [InlineData("v8.0", false)]
    [InlineData("8.0.2.3.4", false)]
    [InlineData("", false)]
    public void IsValidRequiredVersion_matches_powershell_regex(string version, bool expected)
        => Assert.Equal(expected, VersionComparer.IsValidRequiredVersion(version));

    [Theory]
    [InlineData("4.3.0", "4.3.0", true)]
    [InlineData("4.3.1", "4.3.0", false)]
    public void Equal_requires_exact_match(string actual, string required, bool expected)
        => Assert.Equal(expected, VersionComparer.Equal(actual, required));

    [Theory]
    [InlineData("23.7.0", "23.7.0", true)]
    [InlineData("23.8.0", "23.7.0", true)]
    [InlineData("23.6.9", "23.7.0", false)]
    [InlineData("2.44.1", "2.44.0", true)]
    public void EqualOrHigher_allows_same_or_newer(string actual, string required, bool expected)
        => Assert.Equal(expected, VersionComparer.EqualOrHigher(actual, required));

    // PowerShell [version] semantics: unspecified components are -1, so "8.0" < "8.0.0".
    [Fact]
    public void EqualOrHigher_respects_unspecified_component_semantics()
        => Assert.False(VersionComparer.EqualOrHigher("8.0", "8.0.0"));

    [Theory]
    [InlineData("8.0.22", "8.0.22", true)]   // desktop runtime exact
    [InlineData("8.0.30", "8.0.22", true)]   // higher build
    [InlineData("8.0.10", "8.0.22", false)]  // lower build
    [InlineData("9.0.22", "8.0.22", false)]  // major differs
    public void MajorMinorEqual_BuildRevisionEqualOrHigher(string actual, string required, bool expected)
        => Assert.Equal(expected, VersionComparer.MajorMinorEqualBuildRevisionEqualOrHigher(actual, required));

    [Theory]
    [InlineData("16.11.36631.11", "16.11.36631.11", true)]
    [InlineData("16.11.36631.20", "16.11.36631.11", true)] // higher revision
    [InlineData("16.11.36631.5", "16.11.36631.11", false)] // lower revision
    [InlineData("16.11.40000.11", "16.11.36631.11", false)] // build differs
    public void MajorMinorBuildEqual_RevisionEqualOrHigher(string actual, string required, bool expected)
        => Assert.Equal(expected, VersionComparer.MajorMinorBuildEqualRevisionEqualOrHigher(actual, required));
}
