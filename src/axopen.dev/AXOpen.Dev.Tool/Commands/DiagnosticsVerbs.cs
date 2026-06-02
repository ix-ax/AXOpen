using System.ComponentModel;
using AXOpen.Dev.Apax;
using AXOpen.Dev.Commands;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Process;
using Spectre.Console.Cli;

namespace AXOpen.Dev.Tool.Commands;

/// <summary>Settings for verbs that also need the PLC name (to locate its certificate).</summary>
public class NamedPlcSettings : PlcCommandSettings
{
    [CommandOption("-n|--name <PLC_NAME>")]
    [Description("PLC name (locates ./certs/<name>/<name>.cer).")]
    public string Name { get; init; } = string.Empty;
}

/// <summary>axdev hw-diag — port of hw_diag_list.sh. apax alias: hdl.</summary>
[Description("List hardware diagnostic information from the PLC (apax hw-diag list).")]
public sealed class HwDiagVerb : AsyncCommand<NamedPlcSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, NamedPlcSettings settings)
        => new HwDiagListCommand(new ApaxClient(new ProcessRunner()))
            .ExecuteAsync(new PlcTarget(settings.IpAddress, settings.Name, settings.Username, settings.ResolvePassword()));
}

/// <summary>axdev cert-check — port of is_cert_hash_sha1_equal.sh.</summary>
[Description("Compare the stored certificate SHA1 against the certificate on the PLC.")]
public sealed class CertCheckVerb : AsyncCommand<NamedPlcSettings>
{
    public override Task<int> ExecuteAsync(CommandContext context, NamedPlcSettings settings)
        => new CertHashCheckCommand(new ApaxClient(new ProcessRunner()))
            .ExecuteAsync(new PlcTarget(settings.IpAddress, settings.Name, settings.Username, settings.ResolvePassword()));
}
