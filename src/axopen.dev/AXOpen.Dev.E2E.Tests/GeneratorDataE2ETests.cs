using AXOpen.Dev.Hardware;

namespace AXOpen.Dev.E2E.Tests;

/// <summary>
/// Read-only end-to-end check: the ST generators reproduce the app's shipped <c>src/IO/*.st</c>
/// byte-for-byte from the compiled <c>SystemConstants/*.st</c>. Needs only the app directory
/// (no apax, no PLC). Enable with AXDEV_E2E_DATA=1.
/// </summary>
public class GeneratorDataE2ETests
{
    private static string App => E2E.AppDirectory;

    private static string ReadExpected(string relative) =>
        File.ReadAllText(Path.Combine(App, "src", "IO", relative)).Replace("\r\n", "\n");

    [E2EFact(E2E.DataFlag)]
    public void HwIdentifier_files_are_byte_identical()
    {
        var input = File.ReadAllText(Path.Combine(App, "SystemConstants", $"{E2E.PlcName}_HwIdentifiers.st"));
        var (identifiers, list) = HwIdentifiersGenerator.Generate(E2E.Namespace, input);

        Assert.Equal(ReadExpected("HwIdentifiers.st"), identifiers);
        Assert.Equal(ReadExpected("HwIdentifierList.st"), list);
    }

    [E2EFact(E2E.DataFlag)]
    public void IoAddress_files_are_byte_identical()
    {
        var input = File.ReadAllText(Path.Combine(App, "SystemConstants", $"{E2E.PlcName}_IoAddresses.st"));
        var (inputs, outputs, structures) = IoAddressesGenerator.Generate(E2E.Namespace, input);

        // The shipped files carry the PowerShell Set-Content trailing newline.
        Assert.Equal(ReadExpected("Inputs.st"), inputs + "\n");
        Assert.Equal(ReadExpected("Outputs.st"), outputs + "\n");
        Assert.Equal(ReadExpected("IoStructures.st"), structures + "\n");
    }
}
