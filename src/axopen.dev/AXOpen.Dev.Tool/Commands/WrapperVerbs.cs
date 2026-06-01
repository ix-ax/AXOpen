using System.ComponentModel;
using AXOpen.Dev.Commands;
using Spectre.Console.Cli;

namespace AXOpen.Dev.Tool.Commands;

/// <summary>axdev dcp-discover &lt;mac&gt; — port of dcp_utility_discover.sh. apax alias: dcpd.</summary>
[Description("Discover PNIO devices from a source MAC → ./dcp_export/devices.json. apax alias: dcpd")]
public sealed class DcpDiscoverVerb : AsyncCommand<DcpDiscoverVerb.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<MAC_ADDRESS>")]
        [Description("Source adapter MAC address.")]
        public string Mac { get; init; } = string.Empty;
    }

    public override Task<int> ExecuteAsync(CommandContext context, Settings settings)
        => new DcpDiscoverCommand(Clients.Apax()).ExecuteAsync(settings.Mac);
}

/// <summary>axdev dcp-list-interfaces — port of dcp_utility_list_interfaces.sh. apax alias: dcpli.</summary>
[Description("List network interfaces → ./dcp_export/interfaces.json. apax alias: dcpli")]
public sealed class DcpListInterfacesVerb : AsyncCommand
{
    public override Task<int> ExecuteAsync(CommandContext context)
        => new DcpListInterfacesCommand(Clients.Apax()).ExecuteAsync();
}

/// <summary>axdev hw-download-only — port of hw_download_only.sh. apax alias: hwdo.</summary>
[Description("Download compiled HW using certificate. apax alias: hwdo")]
public sealed class HwDownloadOnlyVerb : AsyncCommand<NamedPlcSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, NamedPlcSettings settings)
        => new HwDownloadOnlyCommand(Clients.Apax())
            .ExecuteAsync(settings.Name, settings.IpAddress, settings.Username, settings.ResolvePassword());
}

/// <summary>axdev sw-download-delta — port of sw_download_delta.sh. apax alias: swddo.</summary>
[Description("Delta software download via certificate. apax alias: swddo")]
public sealed class SwDownloadDeltaVerb : AsyncCommand<SwVerbSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, SwVerbSettings settings)
        => new SwDownloadDeltaCommand(Clients.Apax())
            .ExecuteAsync(settings.Name, settings.IpAddress, settings.Platform, settings.Username, settings.ResolvePassword());
}

/// <summary>axdev sw-build-download-delta — port of sw_build_and_download_delta.sh. apax alias: swdd.</summary>
[Description("Build software and delta-download it to the PLC. apax alias: swdd")]
public sealed class SwBuildDownloadDeltaVerb : AsyncCommand<SwVerbSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, SwVerbSettings settings)
        => new SwBuildDownloadDeltaCommand(Clients.Apax(), Clients.Dotnet())
            .ExecuteAsync(settings.Name, settings.IpAddress, settings.Platform, settings.Username, settings.ResolvePassword());
}

/// <summary>axdev plcsim — port of plcsimadvanced.sh. apax alias: plcsim.</summary>
[Description("Start PLCSIM Advanced (Windows only; no-op elsewhere). apax alias: plcsim")]
public sealed class PlcSimVerb : AsyncCommand<PlcSimVerb.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandOption("-x|--instance <INSTANCE>")]
        [Description("Instance name (APAX_YML_NAME).")]
        public string Instance { get; init; } = string.Empty;

        [CommandOption("-n|--name <PLC_NAME>")]
        public string Name { get; init; } = string.Empty;

        [CommandOption("-t|--target <IP>")]
        public string Target { get; init; } = string.Empty;
    }

    public override Task<int> ExecuteAsync(CommandContext context, Settings settings)
        => new PlcSimCommand(Clients.Dotnet()).ExecuteAsync(settings.Instance, settings.Name, settings.Target);
}
