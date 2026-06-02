using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Tests.Validation;

public class ArgumentGuardsTests
{
    [Theory]
    [InlineData("value")]
    [InlineData("p@ss$word`with|specials;")] // no special-char rejection exists in the source scripts
    public void NotEmpty_accepts_non_empty(string value)
        => ArgumentGuards.EnsureNotEmpty("ARG", value); // does not throw

    [Theory]
    [InlineData(null)]
    [InlineData("")]
    [InlineData("   ")]
    public void NotEmpty_rejects_empty_or_whitespace(string? value)
        => Assert.Throws<ArgumentValidationException>(() => ArgumentGuards.EnsureNotEmpty("ARG", value));

    [Theory]
    [InlineData("true", true)]
    [InlineData("True", true)]
    [InlineData("TRUE", true)]
    [InlineData("false", false)]
    [InlineData("FALSE", false)]
    public void PlcSim_flag_parses_case_insensitively(string value, bool expected)
        => Assert.Equal(expected, ArgumentGuards.ParsePlcSim(value));

    [Theory]
    [InlineData("yes")]
    [InlineData("1")]
    [InlineData("")]
    [InlineData(null)]
    public void PlcSim_flag_rejects_other_values(string? value)
        => Assert.Throws<ArgumentValidationException>(() => ArgumentGuards.ParsePlcSim(value));

    [Theory]
    [InlineData("true", true)]
    [InlineData("True", false)]   // bash `[ "$8" = "true" ]` is case-sensitive
    [InlineData("false", false)]
    [InlineData("anything", false)]
    [InlineData(null, false)]
    public void Force_flag_is_exact_lowercase_true(string? value, bool expected)
        => Assert.Equal(expected, ArgumentGuards.ParseForce(value));
}
