using AXOpen.Dev.Hardware;

namespace AXOpen.Dev.Tests.Hardware;

public class IoAddressesGeneratorTests
{
    private const string Input =
        "NAMESPACE Hwc.Input\n" +
        "    VAR_GLOBAL\n" +
        "        // first input\n" +
        "        Station1_DI AT %IB0 : BYTE;\n" +
        "        Station1_DO AT %QB0 : BYTE;\n" +
        "        NotAnIo : INT := 5;\n" +
        "    END_VAR\n" +
        "    TYPE\n" +
        "        IoStruct : STRUCT\n" +
        "            a : BOOL;\n" +
        "        END_STRUCT;\n" +
        "    END_TYPE\n" +
        "END_NAMESPACE\n";

    [Fact]
    public void Inputs_struct_strips_direction_letter_and_keeps_preceding_comment()
    {
        var result = IoAddressesGenerator.Generate("My.Ns", Input);

        const string expected =
            "NAMESPACE My.Ns\n" +
            "    TYPE\n" +
            "        {S7.extern=ReadWrite}\n" +
            "        {#ix-attr:[Container(Layout.Wrap)]}\n" +
            "        Inputs : STRUCT\n" +
            "\t        // first input\n" +
            "\t        Station1_DI AT %B0 : BYTE;\n" +
            "\n" + // blank line after each declaration block (faithful to the PowerShell source)
            "        END_STRUCT;\n" +
            "    END_TYPE\n" +
            "END_NAMESPACE\n";

        Assert.Equal(expected, result.Inputs);
    }

    [Fact]
    public void Outputs_struct_strips_direction_letter()
    {
        var result = IoAddressesGenerator.Generate("My.Ns", Input);

        const string expected =
            "NAMESPACE My.Ns\n" +
            "    TYPE\n" +
            "        {S7.extern=ReadWrite}\n" +
            "        {#ix-attr:[Container(Layout.Wrap)]}\n" +
            "        Outputs : STRUCT\n" +
            "\t        Station1_DO AT %B0 : BYTE;\n" +
            "\n" + // blank line after each declaration block (faithful to the PowerShell source)
            "        END_STRUCT;\n" +
            "    END_TYPE\n" +
            "END_NAMESPACE\n";

        Assert.Equal(expected, result.Outputs);
    }

    [Fact]
    public void Structures_reemit_type_section_with_injected_attributes()
    {
        var result = IoAddressesGenerator.Generate("My.Ns", Input);

        const string expected =
            "NAMESPACE My.Ns\n" +
            "\t    TYPE\n" +
            "        {S7.extern=ReadWrite}\n" +
            "        {#ix-attr:[Container(Layout.Wrap)]}\n" +
            "\t        IoStruct : STRUCT\n" +
            "\t            a : BOOL;\n" +
            "\t        END_STRUCT;\n" +
            "\t    END_TYPE\n" +
            "\tEND_NAMESPACE\n" +
            "END_NAMESPACE\n";

        Assert.Equal(expected, result.Structures);
    }

    [Fact]
    public void No_io_emits_placeholder_members()
    {
        var input =
            "    VAR_GLOBAL\n" +
            "        OnlyData : INT := 1;\n" +
            "    END_VAR\n";

        var result = IoAddressesGenerator.Generate("My.Ns", input);

        Assert.Contains("            noInputsFoundInTheHwConfig AT %B0:  BYTE;\n", result.Inputs);
        Assert.Contains("            noOutputsFoundInTheHwConfig AT %B0:  BYTE;\n", result.Outputs);
    }

    [Fact]
    public void Missing_var_global_block_throws()
        => Assert.Throws<IoAddressesFormatException>(
            () => IoAddressesGenerator.Generate("My.Ns", "TYPE\nEND_TYPE\n"));

    [Fact]
    public void Output_is_lf_only()
    {
        var result = IoAddressesGenerator.Generate("My.Ns", Input);
        Assert.DoesNotContain('\r', result.Inputs);
        Assert.DoesNotContain('\r', result.Outputs);
        Assert.DoesNotContain('\r', result.Structures);
    }
}
