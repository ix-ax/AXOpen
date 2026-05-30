namespace AXOpen.Dev.Requisites;

/// <summary>
/// Constants from the top of <c>scripts/check_requisites.ps1</c> (required versions, URLs, paths).
/// </summary>
public static class RequisitesConfig
{
    // Node
    public const string NodeRequiredVersion = "23.7.0";
    public const string NodeWingetId = "OpenJS.NodeJS.LTS";

    // Microsoft Visual C++ Redistributable
    public const string VcpRequiredVersion = "14.38.33135.0";
    public const string VcpRegPath = @"HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64";
    public const string VcpUrl = "https://aka.ms/vs/17/release/vc_redist.x64.exe";

    // Git
    public const string GitRequiredVersion = "2.44.0";
    public const string GitWingetId = "Git.Git";

    // .NET
    public const string DotNetInstallScriptUrl = "https://dot.net/v1/dotnet-install.ps1";
    public const string DotNetSdkRequiredVersion = "10.0.100";
    public const string DotNetDesktopRuntimeRequiredVersion = "8.0.22";

    // AX Code
    public const string AxCodeRequiredVersion = "1.94.2";
    public const string AxCodeDownloadUrl = "https://console.simatic-ax.siemens.io/downloads";

    // Apax
    public const string ApaxRequiredVersion = "4.1.1";
    public const string ApaxUrl = "https://console.simatic-ax.siemens.io/";

    // Inxton registry + NuGet feed
    public const string InxtonRegistryUrl = "https://npm.pkg.github.com/";
    public const string NugetFeedUrl = "https://nuget.pkg.github.com/inxton/index.json";

    // Visual Studio Build Tools
    public const string VsBuildToolInstallationUrl = "https://aka.ms/vs/16/release/vs_buildtools.exe";
    public const string VsBuildToolRequiredVersion = "16.11.36631.11";
    public const string ExpectedVcToolsInstallDir = @"C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.29.30133";

    public static readonly string[] VsBuildToolInstallArgs =
    {
        "--wait", "--norestart", "--nocache", "--passive",
        "--add", "Microsoft.VisualStudio.Workload.VCTools",
        "--add", "Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
        "--add", "Microsoft.VisualStudio.Component.Windows10SDK",
        "--add", "Microsoft.VisualStudio.Component.Windows10SDK.19041",
    };

    // Visual Studio (optional)
    public const string VisualStudioRequiredVersionRange = "[17.8.0,19.0)";
    public const string VisualStudioDownloadUrl = "https://visualstudio.microsoft.com/vs/";
}
