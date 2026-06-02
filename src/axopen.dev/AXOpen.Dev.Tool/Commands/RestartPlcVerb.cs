using System.ComponentModel;
using AXOpen.Dev.Apax;
using AXOpen.Dev.Commands;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Process;
using Spectre.Console.Cli;

namespace AXOpen.Dev.Tool.Commands;

/// <summary>axdev restart-plc — port of restart_PLC.sh (STOP then RUN via certificate).</summary>
[Description("Restart the PLC by switching it to STOP then back to RUN, using certificate auth.")]
public sealed class RestartPlcVerb : AsyncCommand<RestartPlcVerb.Settings>
{
    public sealed class Settings : PlcCommandSettings
    {
        [CommandOption("-n|--name <PLC_NAME>")]
        [Description("PLC name (used to locate ./certs/<name>/<name>.cer).")]
        public string Name { get; init; } = string.Empty;
    }

    public override Task<int> ExecuteAsync(CommandContext context, Settings settings)
        => new RestartPlcCommand(new ApaxClient(new ProcessRunner()))
            .ExecuteAsync(new PlcTarget(settings.IpAddress, settings.Name, settings.Username, settings.ResolvePassword()));
}
