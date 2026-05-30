using System.Runtime.Versioning;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Process;
using Spectre.Console;

namespace AXOpen.Dev.Requisites;

/// <summary>
/// Faithful port of <c>scripts/check_requisites.ps1</c>: a Windows developer-machine bootstrap that
/// verifies (and optionally installs) Node, VC++ Redistributable, Git, the .NET SDK + Desktop Runtime,
/// VS Build Tools and the VCToolsInstallDir env var, then checks AX Code, Apax, the @inxton registry,
/// the GitHub NuGet feed and Visual Studio. Process calls go through <see cref="IProcessRunner"/>;
/// prompts through <see cref="IUserPrompt"/>; downloads through <see cref="IFileDownloader"/>.
/// </summary>
public sealed class SystemRequisitesChecker(IProcessRunner runner, IUserPrompt prompt, IFileDownloader downloader)
{
    /// <summary>Runs the full sequence. Returns the process exit code (mirrors the script's exit points).</summary>
    public async Task<int> RunAsync(CancellationToken ct = default)
    {
        if (!OperatingSystem.IsWindows())
        {
            Output.Warning("check-requisites is a Windows developer-machine bootstrap; running the portable subset only.");
            var portable = new RequisiteChecker(runner);
            var ok = await portable.CheckApaxAsync(ct) & await portable.CheckNugetAsync(ct) & portable.CheckCustomRegistry();
            return ok ? 0 : 1;
        }

        return await RunWindowsAsync(ct);
    }

    [SupportedOSPlatform("windows")]
    private async Task<int> RunWindowsAsync(CancellationToken ct)
    {
        SystemEnvironment.RefreshPath();

        if (!await ToolAvailableAsync("winget", ct))
        {
            Output.Error("winget is not available on this system.");
            AnsiConsole.MarkupLine("[yellow]        To install winget:\n            1. Proceed to: https://learn.microsoft.com/en-us/windows/package-manager/winget/.\n            2. Follow the on-site instructions to download and install winget.[/]");
            return 1;
        }

        // Node
        if (!await VerifyNodeAsync(ct) && prompt.Confirm($"Node.js {RequisitesConfig.NodeRequiredVersion} is not installed. Would you like to install it now?"))
        {
            await InstallViaWingetAsync(RequisitesConfig.NodeWingetId, "Node.js", ct);
        }

        // Microsoft Visual C++ Redistributable
        if (!await VerifyVcpAsync(ct) && prompt.Confirm($"Microsoft Visual C++ Redistributable {RequisitesConfig.VcpRequiredVersion} is not installed. Would you like to install it now?"))
        {
            await InstallVcpAsync(ct);
        }

        // Git
        if (!await VerifyGitAsync(ct) && prompt.Confirm($"Git {RequisitesConfig.GitRequiredVersion} is not installed. Would you like to install it now?"))
        {
            await InstallViaWingetAsync(RequisitesConfig.GitWingetId, "Git", ct);
        }

        // .NET SDK
        if (!await VerifyDotNetSdkAsync(ct) && prompt.Confirm($".NET {RequisitesConfig.DotNetSdkRequiredVersion} SDK is not installed. Would you like to install it now?"))
        {
            await InstallDotNetSdkAsync(ct);
        }

        // .NET Desktop Runtime x86 + x64
        if (!await VerifyDotNetDesktopRuntimeAsync("x86", ct) && prompt.Confirm($".NET {RequisitesConfig.DotNetDesktopRuntimeRequiredVersion} runtime x86 is not installed. Would you like to install it now?"))
        {
            await InstallDotNetDesktopRuntimeAsync("x86", ct);
        }

        if (!await VerifyDotNetDesktopRuntimeAsync("x64", ct) && prompt.Confirm($".NET {RequisitesConfig.DotNetDesktopRuntimeRequiredVersion} runtime x64 is not installed. Would you like to install it now?"))
        {
            await InstallDotNetDesktopRuntimeAsync("x64", ct);
        }

        // AX Code (warn on mismatch; exit 1 when not installed)
        var axCode = await RunAsync("axcode", new[] { "--version" }, ct);
        if (!axCode.Success)
        {
            Output.Error("Error: Unable to determine the AXCode version. Ensure AXCode is correctly installed and accessible from the command line.");
            AnsiConsole.MarkupLine($"[yellow]To install the AXCode:\n        1. Ensure that you have a valid SIMATIC AX license.\n        2. Verify that you have access to {RequisitesConfig.AxCodeDownloadUrl}.\n        3. Download AX Code for Windows.\n        4. Install it, restart your computer, and run this check again.[/]");
            return 1;
        }

        var axVersion = axCode.StandardOutput.Split('\n').FirstOrDefault()?.Trim() ?? string.Empty;
        if (!VersionComparer.IsValidRequiredVersion(axVersion) || !VersionComparer.EqualOrHigher(axVersion, RequisitesConfig.AxCodeRequiredVersion))
        {
            Output.Error($"The AXCode version ({axVersion}) does not match the expected version: {RequisitesConfig.AxCodeRequiredVersion}. It's highly recommended to update it.");
        }
        else
        {
            Output.Success($"AX Code {axVersion} detected.");
        }

        // Apax installation
        var isApaxInstalled = false;
        var apax = await RunAsync("apax", new[] { "--version" }, ct);
        if (apax.Success && VersionComparer.IsValidRequiredVersion(apax.StandardOutput.Trim()) &&
            VersionComparer.EqualOrHigher(apax.StandardOutput.Trim(), RequisitesConfig.ApaxRequiredVersion))
        {
            isApaxInstalled = true;
            Output.Success($"APAX {apax.StandardOutput.Trim()} detected.");
        }
        else if (apax.Success)
        {
            Output.Error($"The APAX version does not match the expected version: {RequisitesConfig.ApaxRequiredVersion}. It's highly recommended to update it.");
        }

        if (!isApaxInstalled)
        {
            Output.Warning($"Apax is not installed or not found in PATH. You need a valid SIMATIC-AX license.\nTo download Apax:\n    1. Proceed to: {RequisitesConfig.AxCodeDownloadUrl} in your browser.\n    2. Log in with your credentials.\n    3. Follow the on-site instructions to download and install Apax.");
        }

        // Apax network + registry access
        if (isApaxInstalled)
        {
            if (await IsHttpReachableAsync(RequisitesConfig.ApaxUrl, ct))
            {
                Output.Success($"Feed: {RequisitesConfig.ApaxUrl} accessible by means of network.");
            }
            else
            {
                Output.Error($"Failed to access feed: {RequisitesConfig.ApaxUrl}. Check your connection, firewall settings, etc.");
            }
        }

        var scopes = await RunAsync("apax", new[] { "info", "--ax-scopes" }, ct);
        if ((scopes.StandardOutput + scopes.StandardError).Contains("No access to the Simatic-AX registry", StringComparison.OrdinalIgnoreCase))
        {
            Output.Error("Unable to access apax packages.");
            AnsiConsole.MarkupLine($"[yellow]            1. Check your connections, firewall, credentials etc.\n            2. Proceed to: {RequisitesConfig.ApaxUrl} and verify it is accessible.\n            3. Log in, then run 'apax login' and choose 'AX (for Apax packages and IDE extensions)'.\n            4. Run this check again.[/]");
            return 1;
        }

        Output.Success("Apax packages are accessible.");

        // @inxton registry (auth.json)
        if (!CheckInxtonRegistry())
        {
            return 1;
        }

        // GitHub NuGet feed
        var feedExit = await CheckNugetFeedAsync(ct);
        if (feedExit != 0)
        {
            return feedExit;
        }

        // VS Build Tools + VCToolsInstallDir env var
        if (!await VerifyVsBuildToolsAsync(ct) && prompt.Confirm($"VSBuildTools {RequisitesConfig.VsBuildToolRequiredVersion} is not installed. Would you like to install it now?"))
        {
            await InstallVsBuildToolsAsync(ct);
        }

        if (!VerifyVcToolsInstallDirEnvVar() &&
            prompt.Confirm($"VCToolsInstallDir environment variable is not set to: {RequisitesConfig.ExpectedVcToolsInstallDir} for the current user. Would you like to set it now?"))
        {
            SystemEnvironment.SetUserEnv("VCToolsInstallDir", RequisitesConfig.ExpectedVcToolsInstallDir);
        }

        // Visual Studio (optional)
        CheckVisualStudio();

        return 0;
    }

    // ---- Node ------------------------------------------------------------------------------

    [SupportedOSPlatform("windows")]
    private async Task<bool> VerifyNodeAsync(CancellationToken ct)
    {
        var node = await RunAsync("node", new[] { "-v" }, ct);
        if (!node.Success)
        {
            Output.Error("Node.js is not installed or not found in PATH.");
            return false;
        }

        return LogVersion("Node.js", RequisiteParsing.ParseNodeVersion(node.StandardOutput), RequisitesConfig.NodeRequiredVersion, VersionComparer.EqualOrHigher);
    }

    // ---- VC++ Redistributable (registry) ---------------------------------------------------

    [SupportedOSPlatform("windows")]
    private async Task<bool> VerifyVcpAsync(CancellationToken ct)
    {
        var query = await RunAsync("reg", new[] { "query", RequisitesConfig.VcpRegPath }, ct);
        var installed = RequisiteParsing.ExtractRegValue(query.StandardOutput, "Installed");
        var version = RequisiteParsing.ExtractRegValue(query.StandardOutput, "Version")?.TrimStart('v');

        var ok = query.Success
                 && (installed == "0x1" || installed == "1")
                 && version is not null
                 && VersionComparer.IsValidRequiredVersion(version)
                 && VersionComparer.EqualOrHigher(version, RequisitesConfig.VcpRequiredVersion);

        if (ok)
        {
            Output.Success($"VC++ Redistributable {RequisitesConfig.VcpRequiredVersion} detected.");
        }
        else
        {
            Output.Error($"VC++ Redistributable {RequisitesConfig.VcpRequiredVersion} is not installed.");
        }

        return ok;
    }

    [SupportedOSPlatform("windows")]
    private async Task InstallVcpAsync(CancellationToken ct)
    {
        var installer = Path.Combine(Path.GetTempPath(), "vc_redist.x64.exe");
        Output.Warning("Downloading VC++ Redistributable...");
        await downloader.DownloadAsync(RequisitesConfig.VcpUrl, installer, ct);
        Output.Warning("Installing VC++ Redistributable...");
        await RunAsync(installer, new[] { "/install", "/quiet", "/norestart" }, ct);
        if (!await VerifyVcpAsync(ct))
        {
            Output.Error("Error installing VC++ Redistributable.");
        }
    }

    // ---- Git -------------------------------------------------------------------------------

    [SupportedOSPlatform("windows")]
    private async Task<bool> VerifyGitAsync(CancellationToken ct)
    {
        var git = await RunAsync("git", new[] { "--version" }, ct);
        var version = git.Success ? RequisiteParsing.ExtractGitVersion(git.StandardOutput) : null;
        if (version is null)
        {
            Output.Error("Git is not installed.");
            return false;
        }

        return LogVersion("Git", version, RequisitesConfig.GitRequiredVersion, VersionComparer.EqualOrHigher);
    }

    // ---- .NET SDK --------------------------------------------------------------------------

    [SupportedOSPlatform("windows")]
    private async Task<bool> VerifyDotNetSdkAsync(CancellationToken ct)
    {
        var sdks = await RunAsync("dotnet", new[] { "--list-sdks" }, ct);
        var ok = sdks.Success && RequisiteParsing.DotnetSdkListed(SplitLines(sdks.StandardOutput), RequisitesConfig.DotNetSdkRequiredVersion);
        if (ok)
        {
            Output.Success($".NET {RequisitesConfig.DotNetSdkRequiredVersion} SDK detected.");
        }
        else
        {
            Output.Error($".NET {RequisitesConfig.DotNetSdkRequiredVersion} SDK is not installed.");
        }

        return ok;
    }

    [SupportedOSPlatform("windows")]
    private async Task InstallDotNetSdkAsync(CancellationToken ct)
    {
        var script = Path.Combine(Path.GetTempPath(), "dotnet-install.ps1");
        var installDir = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "dotnet");
        try
        {
            Output.Warning("Downloading dotnet-install.ps1... The installer will request administrator rights.");
            await downloader.DownloadAsync(RequisitesConfig.DotNetInstallScriptUrl, script, ct);

            var args = $"-NoProfile -ExecutionPolicy Bypass -File \"{script}\" -Version \"{RequisitesConfig.DotNetSdkRequiredVersion}\" -InstallDir \"{installDir}\" -NoPath";
            var exit = SystemEnvironment.RunElevated("powershell.exe", args);
            if (exit != 0)
            {
                Output.Error($"dotnet-install.ps1 failed with exit code {exit}.");
                return;
            }

            SystemEnvironment.SetUserEnv("DOTNET_ROOT", installDir);
            SystemEnvironment.EnsureUserPath(installDir);

            if (!await VerifyDotNetSdkAsync(ct))
            {
                Output.Error("Error installing dotnet (or dotnet not visible in this session).");
            }
            else
            {
                Output.Success($".NET SDK {RequisitesConfig.DotNetSdkRequiredVersion} installed successfully.");
            }
        }
        finally
        {
            if (File.Exists(script))
            {
                File.Delete(script);
            }
        }
    }

    // ---- .NET Desktop Runtime --------------------------------------------------------------

    [SupportedOSPlatform("windows")]
    private async Task<bool> VerifyDotNetDesktopRuntimeAsync(string architecture, CancellationToken ct)
    {
        var runtimes = await RunAsync("dotnet", new[] { "--list-runtimes" }, ct);
        var ok = runtimes.Success && RequisiteParsing.HasDesktopRuntime(SplitLines(runtimes.StandardOutput), RequisitesConfig.DotNetDesktopRuntimeRequiredVersion);
        if (ok)
        {
            Output.Success($".NET {RequisitesConfig.DotNetDesktopRuntimeRequiredVersion} runtime {architecture} detected.");
        }
        else
        {
            Output.Error($".NET {RequisitesConfig.DotNetDesktopRuntimeRequiredVersion} runtime {architecture} is not installed.");
        }

        return ok;
    }

    [SupportedOSPlatform("windows")]
    private async Task InstallDotNetDesktopRuntimeAsync(string architecture, CancellationToken ct)
    {
        var channel = string.Join('.', RequisitesConfig.DotNetDesktopRuntimeRequiredVersion.Split('.').Take(2));
        var url = $"https://aka.ms/dotnet/{channel}/windowsdesktop-runtime-win-{architecture}.exe";
        var installer = Path.Combine(Path.GetTempPath(), $"dotnet-desktop-runtime-{channel}-{architecture}.exe");

        Output.Warning($"Downloading .NET Desktop Runtime {channel} ({architecture})... The installer will request administrator rights.");
        await downloader.DownloadAsync(url, installer, ct);
        Output.Warning($"Installing .NET Desktop Runtime {channel} ({architecture})...");
        var exit = SystemEnvironment.RunElevated(installer, "/install /quiet /norestart");
        if (exit != 0 || !await VerifyDotNetDesktopRuntimeAsync(architecture, ct))
        {
            Output.Error($".NET Desktop Runtime {RequisitesConfig.DotNetDesktopRuntimeRequiredVersion} ({architecture}) installation failed or could not be verified.");
        }
        else
        {
            Output.Success($".NET Desktop Runtime {RequisitesConfig.DotNetDesktopRuntimeRequiredVersion} ({architecture}) installed successfully.");
        }
    }

    // ---- @inxton registry ------------------------------------------------------------------

    [SupportedOSPlatform("windows")]
    private bool CheckInxtonRegistry()
    {
        var userProfile = Environment.GetEnvironmentVariable("USERPROFILE")
                          ?? Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
        var authPath = Path.Combine(userProfile, ".apax", "auth.json");
        var maskedPath = @"<current_user_name>\.apax\auth.json";

        if (!File.Exists(authPath))
        {
            Output.Error($"Registry '{RequisitesConfig.InxtonRegistryUrl}' not found in {maskedPath}.");
            WriteRegistryGuide();
            return false;
        }

        if (!RequisiteChecker.AuthJsonHasRegistry(File.ReadAllText(authPath), RequisitesConfig.InxtonRegistryUrl))
        {
            Output.Error($"Registry '{RequisitesConfig.InxtonRegistryUrl}' not found in {maskedPath}.");
            WriteRegistryGuide();
            return false;
        }

        Output.Success($"Registry {RequisitesConfig.InxtonRegistryUrl} found in {maskedPath}!");
        return true;
    }

    private static void WriteRegistryGuide()
        => AnsiConsole.MarkupLine("[yellow]You need to provide apax login to the external registry. Run 'apax login', choose 'Custom NPM registry', enter the URL https://npm.pkg.github.com/, your username and a GitHub PAT with at least 'read:packages'.[/]");

    // ---- GitHub NuGet feed -----------------------------------------------------------------

    private async Task<int> CheckNugetFeedAsync(CancellationToken ct)
    {
        var sources = await RunAsync("dotnet", new[] { "nuget", "list", "source" }, ct);
        var added = sources.StandardOutput.Contains(RequisitesConfig.NugetFeedUrl, StringComparison.OrdinalIgnoreCase);

        if (added)
        {
            Output.Success($"The NuGet feed with URL {RequisitesConfig.NugetFeedUrl} is already added.");
        }
        else
        {
            Output.Error($"The NuGet feed with URL {RequisitesConfig.NugetFeedUrl} is not added.");
        }

        var accessible = added && await IsHttpReachableAsync(RequisitesConfig.NugetFeedUrl, ct);
        if (added && accessible)
        {
            Output.Success($"Feed: {RequisitesConfig.NugetFeedUrl} accessible by means of network.");
        }

        if (!(added && accessible))
        {
            var guide = "You need to add the GitHub NuGet feed to your sources manually:\n"
                + "   dotnet nuget add source --username [YOUR_GITHUB_USERNAME] --password [YOUR_PAT] "
                + $"--store-password-in-clear-text --name gh-packages-inxton {RequisitesConfig.NugetFeedUrl}";
            AnsiConsole.MarkupLineInterpolated($"[yellow]{guide}[/]");
            return 0; // the script exits 0 here (non-fatal guidance)
        }

        return 0;
    }

    // ---- VS Build Tools --------------------------------------------------------------------

    [SupportedOSPlatform("windows")]
    private async Task<bool> VerifyVsBuildToolsAsync(CancellationToken ct)
    {
        var vswhere = VsWherePath();
        if (!File.Exists(vswhere))
        {
            Output.Error("vswhere.exe not found. Visual Studio Installer is missing.");
            return false;
        }

        var retval = false;
        var path = await RunAsync(vswhere, new[] { "-products", "Microsoft.VisualStudio.Product.BuildTools", "-property", "installationPath" }, ct);
        if (!string.IsNullOrWhiteSpace(path.StandardOutput))
        {
            Output.Success($"Visual Studio Build Tools already installed at: {path.StandardOutput.Trim()}");
            var version = await RunAsync(vswhere, new[] { "-products", "Microsoft.VisualStudio.Product.BuildTools", "-property", "installationVersion" }, ct);
            var found = version.StandardOutput.Trim();
            retval = VersionComparer.IsValidRequiredVersion(found)
                     && VersionComparer.MajorMinorEqualBuildRevisionEqualOrHigher(found, RequisitesConfig.VsBuildToolRequiredVersion);
        }

        if (Directory.Exists(RequisitesConfig.ExpectedVcToolsInstallDir))
        {
            Output.Success($"VSBuildTools default installation path exists: {RequisitesConfig.ExpectedVcToolsInstallDir}");
        }
        else
        {
            Output.Error($"VSBuildTools default installation path could not be found: {RequisitesConfig.ExpectedVcToolsInstallDir}");
            return false;
        }

        return retval;
    }

    [SupportedOSPlatform("windows")]
    private async Task InstallVsBuildToolsAsync(CancellationToken ct)
    {
        Output.Warning("VS Build Tools not found. Installing...");
        var installer = Path.Combine(Path.GetTempPath(), "vs_buildtools.exe");
        try
        {
            await downloader.DownloadAsync(RequisitesConfig.VsBuildToolInstallationUrl, installer, ct);
            await RunAsync(installer, RequisitesConfig.VsBuildToolInstallArgs, ct);

            if (Directory.Exists(RequisitesConfig.ExpectedVcToolsInstallDir))
            {
                Output.Success($"VSBuildTools default installation path exists: {RequisitesConfig.ExpectedVcToolsInstallDir}");
                SystemEnvironment.SetUserEnv("VCToolsInstallDir", RequisitesConfig.ExpectedVcToolsInstallDir);
            }
            else
            {
                Output.Error($"VSBuildTools default installation path could not be found: {RequisitesConfig.ExpectedVcToolsInstallDir}");
            }
        }
        catch (Exception)
        {
            Output.Error("VS Build Tools installation finished with an error.");
        }
    }

    [SupportedOSPlatform("windows")]
    private bool VerifyVcToolsInstallDirEnvVar()
    {
        if (!Directory.Exists(RequisitesConfig.ExpectedVcToolsInstallDir))
        {
            Output.Error($"VSBuildTools default installation path could not be found: {RequisitesConfig.ExpectedVcToolsInstallDir}");
            return false;
        }

        var value = SystemEnvironment.GetUserEnv("VCToolsInstallDir");
        if (string.Equals(value, RequisitesConfig.ExpectedVcToolsInstallDir, StringComparison.OrdinalIgnoreCase))
        {
            Output.Success($"VCToolsInstallDir is set to: {value}");
            return true;
        }

        Output.Error("VCToolsInstallDir is not set correctly.");
        return false;
    }

    // ---- Visual Studio (optional) ----------------------------------------------------------

    [SupportedOSPlatform("windows")]
    private void CheckVisualStudio()
    {
        const string editorNote = "Visual Studio is optional; you can use VSCode, Rider, or AX Code to edit .NET files.";
        var vswhere = VsWherePath();
        if (!File.Exists(vswhere))
        {
            Output.Warning($"vswhere tool not found. Unable to determine if Visual Studio is installed. {editorNote}");
            return;
        }

        var result = runner.RunAsync(new ProcessRequest
        {
            Executable = vswhere,
            Arguments = new[] { "-version", RequisitesConfig.VisualStudioRequiredVersionRange, "-products", "*", "-property", "catalog_productDisplayVersion" },
            EchoToConsole = false,
        }).GetAwaiter().GetResult();

        if (string.IsNullOrWhiteSpace(result.StandardOutput))
        {
            Output.Warning($"Visual Studio is not detected in the required version range {RequisitesConfig.VisualStudioRequiredVersionRange}. {editorNote}");
            if (prompt.Confirm("Visual Studio is not detected. Would you like to download it now?"))
            {
                SystemEnvironment.RunElevated("cmd.exe", $"/c start {RequisitesConfig.VisualStudioDownloadUrl}");
            }
        }
        else
        {
            Output.Success($"Visual Studio detected: {result.StandardOutput.Trim()}. {editorNote}");
        }
    }

    // ---- helpers ---------------------------------------------------------------------------

    [SupportedOSPlatform("windows")]
    private async Task InstallViaWingetAsync(string packageId, string displayName, CancellationToken ct)
    {
        Output.Warning($"Installing {displayName} via winget...");
        await RunAsync("winget", new[]
        {
            "install", "--id", packageId, "--exact", "--silent",
            "--accept-package-agreements", "--accept-source-agreements",
        }, ct);
        SystemEnvironment.RefreshPath();
    }

    private static string VsWherePath()
    {
        var programFilesX86 = Environment.GetEnvironmentVariable("ProgramFiles(x86)")
                              ?? Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86);
        return Path.Combine(programFilesX86, "Microsoft Visual Studio", "Installer", "vswhere.exe");
    }

    private async Task<bool> ToolAvailableAsync(string executable, CancellationToken ct)
        => (await RunAsync(executable, new[] { "--version" }, ct)).Success;

    private Task<ProcessResult> RunAsync(string executable, string[] arguments, CancellationToken ct)
        => runner.RunAsync(new ProcessRequest { Executable = executable, Arguments = arguments, EchoToConsole = false }, ct);

    private static IReadOnlyList<string> SplitLines(string text)
        => text.Split('\n').Select(l => l.Trim('\r')).Where(l => l.Length > 0).ToList();

    private static bool LogVersion(string item, string actual, string required, Func<string, string, bool> comparer)
    {
        if (VersionComparer.IsValidRequiredVersion(actual) && comparer(actual, required))
        {
            Output.Success($"The actual version of the {item} ({actual}) is equal or higher than required ({required}).");
            return true;
        }

        Output.Error($"The actual version of the {item} ({actual}) is lower than required ({required}).");
        return false;
    }

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
