using System.ComponentModel;
using AXOpen.Dev.Commands;
using Spectre.Console.Cli;

namespace AXOpen.Dev.Tool.Commands;

/// <summary>Settings carrying the namespace + PLC name used by the ST generators.</summary>
public class HardwareGenSettings : CommandSettings
{
    [CommandArgument(0, "<NAMESPACE>")]
    [Description("Default namespace for the generated types (DEFAULT_NAMESPACE).")]
    public string Namespace { get; init; } = string.Empty;

    [CommandArgument(1, "<PLC_NAME>")]
    [Description("PLC name (selects SystemConstants/<PLC_NAME>_*.st).")]
    public string PlcName { get; init; } = string.Empty;
}

/// <summary>axdev copy-hardware-ids — port of copy_hardware_ids.sh. apax alias: hwid.</summary>
[Description("Generate src/IO/HwIdentifiers.st + HwIdentifierList.st. apax alias: hwid")]
public sealed class CopyHardwareIdsVerb : Command<HardwareGenSettings>
{
    public override int Execute(CommandContext context, HardwareGenSettings settings)
        => new CopyHardwareIdsCommand().Execute(settings.Namespace, settings.PlcName);
}

/// <summary>axdev copy-io-addresses — port of copy_io_addresses.sh. apax alias: hwadr.</summary>
[Description("Generate src/IO/Inputs.st + Outputs.st + IoStructures.st. apax alias: hwadr")]
public sealed class CopyIoAddressesVerb : Command<HardwareGenSettings>
{
    public override int Execute(CommandContext context, HardwareGenSettings settings)
        => new CopyIoAddressesCommand().Execute(settings.Namespace, settings.PlcName);
}
