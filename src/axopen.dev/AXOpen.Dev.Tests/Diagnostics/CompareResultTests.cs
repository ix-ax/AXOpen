using AXOpen.Dev.Diagnostics;

namespace AXOpen.Dev.Tests.Diagnostics;

public class CompareResultTests
{
    [Theory]
    [InlineData(0, CompareOutcome.Identical, 0)]
    [InlineData(9, CompareOutcome.CodeBlocksDiffer, 9)]
    [InlineData(10, CompareOutcome.DataBlocksDiffer, 10)]
    [InlineData(11, CompareOutcome.CodeAndDataBlocksDiffer, 11)]
    public void Known_apax_codes_map_and_propagate(int apax, CompareOutcome outcome, int processExit)
    {
        var result = CompareResult.FromApaxExitCode(apax);
        Assert.Equal(outcome, result.Outcome);
        Assert.Equal(processExit, result.ProcessExitCode);
        Assert.False(string.IsNullOrWhiteSpace(result.Message));
    }

    [Theory]
    [InlineData(1)]
    [InlineData(7)]
    [InlineData(255)]
    public void Unknown_codes_are_unspecified_and_fail_with_1(int apax)
    {
        var result = CompareResult.FromApaxExitCode(apax);
        Assert.Equal(CompareOutcome.Unspecified, result.Outcome);
        Assert.Equal(1, result.ProcessExitCode);
    }

    [Fact]
    public void Identical_is_the_only_success()
    {
        Assert.True(CompareResult.FromApaxExitCode(0).IsIdentical);
        Assert.False(CompareResult.FromApaxExitCode(9).IsIdentical);
    }
}
