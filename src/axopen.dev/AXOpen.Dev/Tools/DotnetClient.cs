using AXOpen.Dev.Process;

namespace AXOpen.Dev.Tools;

/// <summary>Thin wrapper over the <c>dotnet</c> CLI for the AX builder tools.</summary>
public sealed class DotnetClient(IProcessRunner runner)
{
    public const string Executable = "dotnet";

    /// <summary>dotnet ixc — runs the AX# compiler.</summary>
    public Task<ProcessResult> IxcAsync(CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest { Executable = Executable, Arguments = new[] { "ixc" } }, ct);

    /// <summary>dotnet run --project PROJECT -- ARGS</summary>
    public Task<ProcessResult> RunProjectAsync(string projectPath, IReadOnlyList<string> args, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[] { "run", "--project", projectPath, "--" }.Concat(args).ToArray(),
        }, ct);
}
