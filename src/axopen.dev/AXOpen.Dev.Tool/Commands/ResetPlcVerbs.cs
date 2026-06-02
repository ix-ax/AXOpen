using System.ComponentModel;
using AXOpen.Dev.Apax;
using AXOpen.Dev.Commands;
using AXOpen.Dev.Process;
using Spectre.Console.Cli;

namespace AXOpen.Dev.Tool.Commands;

/// <summary>axdev clean-plc — port of clean_plc.sh (reset keeping only the IP).</summary>
[Description("Reset the PLC keeping only its IP address (apax hwld --reset-plc KeepOnlyIP).")]
public sealed class CleanPlcVerb : AsyncCommand<PlcCommandSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, PlcCommandSettings settings)
        => new ResetPlcCommand(new ApaxClient(new ProcessRunner()))
            .ExecuteAsync(ResetScope.KeepOnlyIp, settings.IpAddress, settings.Username, settings.ResolvePassword());
}

/// <summary>axdev reset-plc — port of reset_plc.sh (full factory reset).</summary>
[Description("Full factory reset of the PLC including IP and name (apax hwld --reset-plc All).")]
public sealed class ResetPlcVerb : AsyncCommand<PlcCommandSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, PlcCommandSettings settings)
        => new ResetPlcCommand(new ApaxClient(new ProcessRunner()))
            .ExecuteAsync(ResetScope.All, settings.IpAddress, settings.Username, settings.ResolvePassword());
}
