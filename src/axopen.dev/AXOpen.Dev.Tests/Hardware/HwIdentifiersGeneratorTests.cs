using AXOpen.Dev.Hardware;

namespace AXOpen.Dev.Tests.Hardware;

public class HwIdentifiersGeneratorTests
{
    // Input deliberately unsorted by value, with surrounding namespace + a non-constant
    // block that must be ignored. \r mixed in to exercise CR stripping.
    private const string Input =
        "NAMESPACE Ignored.Input.Ns\r\n" +
        "    VAR_GLOBAL\r\n" +
        "        ShouldBeIgnored : UINT := UINT#999;\r\n" +
        "    END_VAR\r\n" +
        "    VAR_GLOBAL CONSTANT\r\n" +
        "        Device_1 : UINT := UINT#258;\r\n" +
        "        Local : UINT := UINT#0;\r\n" +
        "        PN_IO : UINT := UINT#257;\r\n" +
        "        PROFINET_IO_System : UINT := UINT#256;\r\n" +
        "    END_VAR\r\n" +
        "END_NAMESPACE\r\n";

    [Fact]
    public void Generates_enum_style_identifiers_sorted_by_value()
    {
        var (identifiers, _) = HwIdentifiersGenerator.Generate("My.Ns", Input);

        const string expected =
            "NAMESPACE My.Ns\n" +
            "    TYPE\n" +
            "        HwIdentifiers : UINT\n" +
            "        (\n" +
            "            Local := UINT#0,\n" +
            "            PROFINET_IO_System := UINT#256,\n" +
            "            PN_IO := UINT#257,\n" +
            "            Device_1 := UINT#258\n" +
            "        );\n" +
            "    END_TYPE\n" +
            "END_NAMESPACE\n\n";

        Assert.Equal(expected, identifiers);
    }

    [Fact]
    public void Generates_array_list_sorted_by_value()
    {
        var (_, list) = HwIdentifiersGenerator.Generate("My.Ns", Input);

        const string expected =
            "NAMESPACE My.Ns\n" +
            "    TYPE HwIdentifierList : ARRAY[0..3] OF UINT :=\n" +
            "            [\n" +
            "                UINT#0,\n" +
            "                UINT#256,\n" +
            "                UINT#257,\n" +
            "                UINT#258\n" +
            "    ];\n" +
            "END_TYPE\n" +
            "END_NAMESPACE\n\n";

        Assert.Equal(expected, list);
    }

    [Fact]
    public void Empty_constant_block_emits_NONE()
    {
        var (identifiers, _) = HwIdentifiersGenerator.Generate("My.Ns",
            "VAR_GLOBAL CONSTANT\r\nEND_VAR\r\n");

        Assert.Contains("            NONE := UINT#0\n", identifiers);
    }

    [Fact]
    public void Uses_lf_line_endings_only()
    {
        var (identifiers, list) = HwIdentifiersGenerator.Generate("My.Ns", Input);
        Assert.DoesNotContain('\r', identifiers);
        Assert.DoesNotContain('\r', list);
    }
}
