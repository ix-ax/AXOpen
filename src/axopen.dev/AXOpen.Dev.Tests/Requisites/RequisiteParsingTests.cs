using AXOpen.Dev.Requisites;

namespace AXOpen.Dev.Tests.Requisites;

public sealed class RequisiteParsingTests
{
    [Theory]
    [InlineData("v23.7.0", "23.7.0")]
    [InlineData("23.7.0\n", "23.7.0")]
    public void ParseNodeVersion(string input, string expected)
        => Assert.Equal(expected, RequisiteParsing.ParseNodeVersion(input));

    [Theory]
    [InlineData("git version 2.44.0.windows.1", "2.44.0")]
    [InlineData("git version 2.45.1", "2.45.1")]
    [InlineData("no version here", null)]
    public void ExtractGitVersion(string input, string? expected)
        => Assert.Equal(expected, RequisiteParsing.ExtractGitVersion(input));

    [Fact]
    public void DotnetSdkListed_matches_exact_leading_version()
    {
        var lines = new[]
        {
            "8.0.404 [C:\\Program Files\\dotnet\\sdk]",
            "10.0.100 [C:\\Program Files\\dotnet\\sdk]",
        };
        Assert.True(RequisiteParsing.DotnetSdkListed(lines, "10.0.100"));
        Assert.False(RequisiteParsing.DotnetSdkListed(lines, "10.0.200"));
        // must be a leading match, not a substring
        Assert.False(RequisiteParsing.DotnetSdkListed(new[] { "110.0.100 [x]" }, "10.0.100"));
    }

    [Fact]
    public void HasDesktopRuntime_checks_windowsdesktop_app_versions()
    {
        var lines = new[]
        {
            "Microsoft.AspNetCore.App 8.0.22 [C:\\x]",
            "Microsoft.WindowsDesktop.App 8.0.30 [C:\\x]",
            "Microsoft.NETCore.App 8.0.30 [C:\\x]",
        };
        Assert.True(RequisiteParsing.HasDesktopRuntime(lines, "8.0.22"));
        Assert.False(RequisiteParsing.HasDesktopRuntime(lines, "8.0.40"));
        Assert.False(RequisiteParsing.HasDesktopRuntime(lines, "9.0.0"));
    }

    [Theory]
    [InlineData("\r\n    Version    REG_SZ    14.38.33135.0\r\n", "14.38.33135.0")]
    [InlineData("    Installed    REG_DWORD    0x1\r\n", "0x1")]
    public void ExtractRegValue(string output, string expected)
        => Assert.Equal(expected, RequisiteParsing.ExtractRegValue(output, expected.StartsWith("0x") ? "Installed" : "Version"));
}
