using System.ComponentModel;
using AXOpen.Dev.Commands;
using AXOpen.Dev.Process;
using AXOpen.Dev.Requisites;
using Spectre.Console.Cli;

namespace AXOpen.Dev.Tool.Commands;

/// <summary>Settings for the multi-step orchestrators.</summary>
public class OrchestratorSettings : SwVerbSettings
{
    [CommandOption("--namespace <NAMESPACE>")]
    [Description("Default namespace (DEFAULT_NAMESPACE).")]
    public string Namespace { get; init; } = string.Empty;

    [CommandOption("--use-plc-sim")]
    [Description("Start PLCSIM Advanced first (USE_PLC_SIM_ADVANCED).")]
    public bool UsePlcSim { get; init; }

    [CommandOption("--force")]
    [Description("Force-regenerate certificates (delete ./certs and ./hwc/hwc.gen first).")]
    public bool Force { get; init; }
}

/// <summary>axdev all-first — port of all_first.sh. apax alias: alf.</summary>
[Description("Full initial bring-up of a PLC (HW + SW). apax alias: alf")]
public sealed class AllFirstVerb : AsyncCommand<OrchestratorSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, OrchestratorSettings s)
        => new AllFirstCommand(Clients.Apax(), Clients.Openssl(), Clients.Dotnet())
            .ExecuteAsync(s.Namespace, s.Name, s.IpAddress, s.Platform, s.Username, s.ResolvePassword(), s.UsePlcSim, s.Force);
}

/// <summary>axdev all — smart update dispatcher. Port of all.sh. apax alias: a.</summary>
[Description("Smart update: first-setup, fast update, or regenerate based on certificate state. apax alias: a")]
public sealed class AllVerb : AsyncCommand<OrchestratorSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, OrchestratorSettings s)
        => new AllCommand(Clients.Apax(), Clients.Openssl(), Clients.Dotnet())
            .ExecuteAsync(s.Namespace, s.Name, s.IpAddress, s.Platform, s.Username, s.ResolvePassword(), s.UsePlcSim, s.Force);
}

/// <summary>axdev compile-all — port of compile_all.sh. apax alias: ca.</summary>
[Description("Compile HW + SW and pull the PLC certificate (no download). apax alias: ca")]
public sealed class CompileAllVerb : AsyncCommand<OrchestratorSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, OrchestratorSettings s)
        => new CompileAllCommand(Clients.Apax(), Clients.Openssl(), Clients.Dotnet())
            .ExecuteAsync(s.Namespace, s.Name, s.IpAddress, s.Platform, s.Username, s.ResolvePassword(), s.UsePlcSim);
}

/// <summary>axdev compile-all-compare-all — port of compile_all_compare_all.sh. apax alias: cca.</summary>
[Description("Compile everything, then compare online vs offline. apax alias: cca")]
public sealed class CompileAllCompareAllVerb : AsyncCommand<OrchestratorSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, OrchestratorSettings s)
        => new CompileAllCompareAllCommand(Clients.Apax(), Clients.Openssl(), Clients.Dotnet())
            .ExecuteAsync(s.Namespace, s.Name, s.IpAddress, s.Platform, s.Username, s.ResolvePassword(), s.UsePlcSim);
}

/// <summary>axdev compare-all — port of compare_all.sh.</summary>
[Description("Compare online (PLC) vs offline (compiled) software. Exit 0/9/10/11.")]
public sealed class CompareAllVerb : AsyncCommand<SwVerbSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, SwVerbSettings s)
        => new CompareAllCommand(Clients.Apax())
            .ExecuteAsync(s.Name, s.IpAddress, s.Platform, s.Username, s.ResolvePassword());
}

/// <summary>axdev hw-update — port of hw_update.sh. apax alias: hwu.</summary>
[Description("Update HW: gsd + templates + compile + download via certificate. apax alias: hwu")]
public sealed class HwUpdateVerb : AsyncCommand<HwUpdateVerb.Settings>
{
    public sealed class Settings : NamedPlcSettings
    {
        [CommandOption("--namespace <NAMESPACE>")]
        public string Namespace { get; init; } = string.Empty;
    }

    public override Task<int> ExecuteAsync(CommandContext context, Settings s)
        => new HwUpdateCommand(Clients.Apax())
            .ExecuteAsync(s.Namespace, s.Name, s.IpAddress, s.Username, s.ResolvePassword());
}

/// <summary>axdev check-requisites — apax/nuget/custom-registry prerequisite checks.</summary>
[Description("Check apax, NuGet feed and custom NPM registry prerequisites (report-only).")]
public sealed class CheckRequisitesVerb : AsyncCommand
{
    public override async Task<int> ExecuteAsync(CommandContext context)
    {
        var checker = new RequisiteChecker(new ProcessRunner());
        var ok = await checker.CheckApaxAsync() & await checker.CheckNugetAsync() & checker.CheckCustomRegistry();
        return ok ? 0 : 1;
    }
}
