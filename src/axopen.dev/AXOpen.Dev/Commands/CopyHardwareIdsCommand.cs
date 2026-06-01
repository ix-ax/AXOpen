using AXOpen.Dev.Hardware;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Generates <c>src/IO/HwIdentifiers.st</c> and <c>src/IO/HwIdentifierList.st</c> from the
/// compiled <c>SystemConstants/&lt;PLC&gt;_HwIdentifiers.st</c>. Port of <c>copy_hardware_ids.sh</c>.
/// Paths are relative to the current working directory (the app folder).
/// </summary>
public sealed class CopyHardwareIdsCommand
{
    public int Execute(string @namespace, string plcName)
    {
        try
        {
            ArgumentGuards.EnsureNotEmpty("NAMESPACE", @namespace);
            ArgumentGuards.EnsureNotEmpty("PLC_NAME", plcName);
        }
        catch (ArgumentValidationException ex)
        {
            Output.Error(ex.Message);
            return 1;
        }

        if (!Directory.Exists("./hwc"))
        {
            Output.Error("Directory \"./hwc\" does not exist!!!");
            return 1;
        }

        var input = Path.Combine("SystemConstants", $"{plcName}_HwIdentifiers.st");
        if (!File.Exists(input))
        {
            Output.Error($"File {input} does not exist!!!");
            return 1;
        }

        var (identifiers, list) = HwIdentifiersGenerator.Generate(@namespace, File.ReadAllText(input));
        StFile.Write(Path.Combine("src", "IO", "HwIdentifiers.st"), identifiers);
        StFile.Write(Path.Combine("src", "IO", "HwIdentifierList.st"), list);

        Output.Success("Generation complete: src/IO/HwIdentifiers.st, src/IO/HwIdentifierList.st");
        return 0;
    }
}
