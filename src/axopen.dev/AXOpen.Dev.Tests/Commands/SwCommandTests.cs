using AXOpen.Dev.Apax;
using AXOpen.Dev.Commands;
using AXOpen.Dev.Tools;
using AXOpen.Dev.Tests.Fakes;

namespace AXOpen.Dev.Tests.Commands;

public class SwCommandTests
{
    [Fact]
    public async Task SwBuildDownloadFull_runs_build_then_ixc_before_download()
    {
        var fake = new FakeProcessRunner(); // default success
        var cmd = new SwBuildDownloadFullCommand(new ApaxClient(fake), new DotnetClient(fake));

        // Certificate is absent in the test working directory, so the download step stops early —
        // but build + ixc must have run first, in order.
        var exit = await cmd.ExecuteAsync("plc_line", "192.168.100.1", ".\\bin\\1500\\", "admin", "pwd");

        Assert.Equal(1, exit);
        Assert.True(fake.Invocations.Count >= 2);
        Assert.Equal("apax", fake.Invocations[0].Executable);
        Assert.Contains("build", fake.Invocations[0].Arguments);
        Assert.Equal("dotnet", fake.Invocations[1].Executable);
        Assert.Contains("ixc", fake.Invocations[1].Arguments);
    }

    [Fact]
    public async Task SwBuildDownloadFull_stops_when_build_fails()
    {
        var fake = new FakeProcessRunner();
        fake.When(r => r.Executable == "apax" && r.Arguments.Contains("build"), new(1, "", "err"));
        var cmd = new SwBuildDownloadFullCommand(new ApaxClient(fake), new DotnetClient(fake));

        var exit = await cmd.ExecuteAsync("plc_line", "192.168.100.1", ".\\bin\\1500\\", "admin", "pwd");

        Assert.Equal(1, exit);
        Assert.Single(fake.Invocations); // never reaches dotnet ixc
    }
}
