using AXOpen.Dev.Hardware;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Generates <c>src/IO/Inputs.st</c>, <c>Outputs.st</c> and <c>IoStructures.st</c> from the
/// compiled <c>SystemConstants/&lt;PLC&gt;_IoAddresses.st</c>. Port of <c>copy_io_addresses.sh</c>
/// (hwc &gt;= 3.4.0 path). Files get a trailing newline to match PowerShell Set-Content exactly.
/// </summary>
public sealed class CopyIoAddressesCommand
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

        var input = Path.Combine("SystemConstants", $"{plcName}_IoAddresses.st");
        if (!File.Exists(input))
        {
            Output.Error($"File {input} does not exist!!!");
            return 1;
        }

        try
        {
            var (inputs, outputs, structures) = IoAddressesGenerator.Generate(@namespace, File.ReadAllText(input));
            StFile.Write(Path.Combine("src", "IO", "Inputs.st"), inputs, trailingNewline: true);
            StFile.Write(Path.Combine("src", "IO", "Outputs.st"), outputs, trailingNewline: true);
            StFile.Write(Path.Combine("src", "IO", "IoStructures.st"), structures, trailingNewline: true);
        }
        catch (IoAddressesFormatException ex)
        {
            Output.Error(ex.Message);
            return 1;
        }

        Output.Success("Generation complete: src/IO/Inputs.st, src/IO/Outputs.st, src/IO/IoStructures.st");
        return 0;
    }
}
