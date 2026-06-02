using AXOpen.Dev.Apax;
using AXOpen.Dev.Commands;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Process;
using AXOpen.Dev.Tests.Fakes;

namespace AXOpen.Dev.Tests.Commands;

public class PlcControlCommandTests
{
    private static readonly ProcessResult Ok = new(0, string.Empty, string.Empty);
    private static readonly ProcessResult Fail = new(1, string.Empty, "boom");

    [Fact]
    public async Task Restart_issues_stop_then_run_with_certificate()
    {
        var fake = new FakeProcessRunner { Default = Ok };
        var target = new PlcTarget("10.10.10.120", "PLC1", "user", "pass");
        var cmd = new RestartPlcCommand(new ApaxClient(fake), fileExists: _ => true);

        var exit = await cmd.ExecuteAsync(target);

        Assert.Equal(0, exit);
        Assert.Equal(2, fake.Invocations.Count);
        Assert.All(fake.Invocations, r => Assert.Equal("apax", r.Executable));
        Assert.Contains("STOP", fake.Invocations[0].Arguments);
        Assert.Contains("RUN", fake.Invocations[1].Arguments);
        Assert.Contains(target.CertificatePath, fake.Invocations[0].Arguments);
        Assert.Contains("--no-input", fake.Invocations[0].Arguments);
    }

    [Fact]
    public async Task Restart_stops_after_failed_stop_and_returns_1()
    {
        var fake = new FakeProcessRunner();
        fake.When(r => r.Arguments.Contains("STOP"), Fail);
        var cmd = new RestartPlcCommand(new ApaxClient(fake), fileExists: _ => true);

        var exit = await cmd.ExecuteAsync(new PlcTarget("1.2.3.4", "PLC1", "u", "p"));

        Assert.Equal(1, exit);
        Assert.Single(fake.Invocations); // never attempts RUN
    }

    [Fact]
    public async Task Restart_rejects_invalid_ip_without_calling_apax()
    {
        var fake = new FakeProcessRunner { Default = Ok };
        var cmd = new RestartPlcCommand(new ApaxClient(fake), fileExists: _ => true);

        var exit = await cmd.ExecuteAsync(new PlcTarget("999.1.1.1", "PLC1", "u", "p"));

        Assert.Equal(1, exit);
        Assert.Empty(fake.Invocations);
    }

    [Fact]
    public async Task Restart_fails_when_certificate_missing()
    {
        var fake = new FakeProcessRunner { Default = Ok };
        var cmd = new RestartPlcCommand(new ApaxClient(fake), fileExists: _ => false);

        var exit = await cmd.ExecuteAsync(new PlcTarget("1.2.3.4", "PLC1", "u", "p"));

        Assert.Equal(1, exit);
        Assert.Empty(fake.Invocations);
    }

    [Theory]
    [InlineData(ResetScope.KeepOnlyIp, "KeepOnlyIP")]
    [InlineData(ResetScope.All, "All")]
    public async Task Reset_passes_correct_scope_and_pipes_confirmation(ResetScope scope, string expectedFlag)
    {
        var fake = new FakeProcessRunner { Default = Ok };
        var cmd = new ResetPlcCommand(new ApaxClient(fake));

        var exit = await cmd.ExecuteAsync(scope, "10.10.10.120", "user", "pass");

        Assert.Equal(0, exit);
        var call = Assert.Single(fake.Invocations);
        Assert.Equal("apax", call.Executable);
        Assert.Contains("hwld", call.Arguments);
        Assert.Contains(expectedFlag, call.Arguments);
        Assert.Equal("y\n", call.StandardInput);
    }

    [Fact]
    public async Task Reset_maps_apax_failure_to_exit_1()
    {
        var fake = new FakeProcessRunner { Default = Fail };
        var cmd = new ResetPlcCommand(new ApaxClient(fake));

        var exit = await cmd.ExecuteAsync(ResetScope.All, "1.2.3.4", "u", "p");

        Assert.Equal(1, exit);
    }
}
