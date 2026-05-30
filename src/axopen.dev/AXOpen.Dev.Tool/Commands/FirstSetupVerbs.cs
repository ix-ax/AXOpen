using System.ComponentModel;
using AXOpen.Dev.Apax;
using AXOpen.Dev.Commands;
using AXOpen.Dev.Process;
using AXOpen.Dev.Tools;
using Spectre.Console.Cli;

namespace AXOpen.Dev.Tool.Commands;

internal static class Clients
{
    public static ApaxClient Apax() => new(new ProcessRunner());
    public static OpensslClient Openssl() => new(new ProcessRunner());
    public static DotnetClient Dotnet() => new(new ProcessRunner());
}

/// <summary>axdev hw-compile — apax hwc compile. apax alias: hwcc.</summary>
[Description("Compile the hardware configuration (apax hwc compile). apax alias: hwcc")]
public sealed class HwCompileVerb : AsyncCommand
{
    public override Task<int> ExecuteAsync(CommandContext context)
        => new HwCompileCommand(Clients.Apax()).ExecuteAsync();
}

/// <summary>axdev install-gsd — copy + install GSDML files. apax alias: gsd.</summary>
[Description("Copy and install GSDML files from library assets. apax alias: gsd")]
public sealed class GsdVerb : AsyncCommand
{
    public override Task<int> ExecuteAsync(CommandContext context)
        => new GsdInstallCommand(Clients.Apax()).ExecuteAsync();
}

/// <summary>axdev copy-hwl-templates — copy HWL templates. apax alias: hwl.</summary>
[Description("Copy hardware library templates from library assets. apax alias: hwl")]
public sealed class HwlVerb : Command
{
    public override int Execute(CommandContext context) => new HwlCopyCommand().Execute();
}

/// <summary>axdev setup-secure-communication — port of setup_secure_communication.sh. apax alias: ssc.</summary>
[Description("Create certificates and configure secure communication on the PLC. apax alias: ssc")]
public sealed class SetupSecureCommVerb : AsyncCommand<NamedPlcSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, NamedPlcSettings settings)
        => new SetupSecureCommunicationCommand(Clients.Apax(), Clients.Openssl())
            .ExecuteAsync(settings.Name, settings.Username, settings.ResolvePassword(), settings.IpAddress);
}

/// <summary>axdev hw-first-download — port of hw_first_download.sh. apax alias: hwfd.</summary>
[Description("First-time HW provisioning: gsd + templates + secure comms + compile + download + cert. apax alias: hwfd")]
public sealed class HwFirstDownloadVerb : AsyncCommand<HwFirstDownloadVerb.Settings>
{
    public sealed class Settings : NamedPlcSettings
    {
        [CommandOption("--namespace <NAMESPACE>")]
        [Description("Default namespace (DEFAULT_NAMESPACE).")]
        public string Namespace { get; init; } = string.Empty;
    }

    public override Task<int> ExecuteAsync(CommandContext context, Settings settings)
        => new HwFirstDownloadCommand(Clients.Apax(), Clients.Openssl())
            .ExecuteAsync(settings.Namespace, settings.Name, settings.IpAddress, settings.Username, settings.ResolvePassword());
}

/// <summary>axdev hw-first-download-only — port of hw_first_download_only.sh. apax alias: hwfdo.</summary>
[Description("First HW download with master password + pull certificate. apax alias: hwfdo")]
public sealed class HwFirstDownloadOnlyVerb : AsyncCommand<NamedPlcSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, NamedPlcSettings settings)
        => new HwFirstDownloadOnlyCommand(Clients.Apax())
            .ExecuteAsync(settings.Name, settings.IpAddress, settings.ResolvePassword());
}

/// <summary>axdev sw-download-full — port of sw_download_full.sh. apax alias: swfdo.</summary>
[Description("Full software download via certificate (apax sld load --mode FULL --restart). apax alias: swfdo")]
public sealed class SwDownloadFullVerb : AsyncCommand<SwVerbSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, SwVerbSettings settings)
        => new SwDownloadFullCommand(Clients.Apax())
            .ExecuteAsync(settings.Name, settings.IpAddress, settings.Platform, settings.Username, settings.ResolvePassword());
}

/// <summary>axdev sw-build-download-full — port of sw_build_and_download_full.sh. apax alias: swfd.</summary>
[Description("Build software and full-download it to the PLC. apax alias: swfd")]
public sealed class SwBuildDownloadFullVerb : AsyncCommand<SwVerbSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, SwVerbSettings settings)
        => new SwBuildDownloadFullCommand(Clients.Apax(), Clients.Dotnet())
            .ExecuteAsync(settings.Name, settings.IpAddress, settings.Platform, settings.Username, settings.ResolvePassword());
}

/// <summary>Settings for software download verbs (adds platform input path).</summary>
public class SwVerbSettings : NamedPlcSettings
{
    [CommandOption("--platform <PLATFORM>")]
    [Description("Platform output directory (AXTARGETPLATFORMINPUT, e.g. .\\bin\\1500\\).")]
    public string Platform { get; init; } = string.Empty;
}
