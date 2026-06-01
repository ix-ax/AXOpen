using System.Text;
using CliWrap;

namespace AXOpen.Dev.Process;

/// <summary>
/// Cross-platform <see cref="IProcessRunner"/> built on CliWrap. Captures stdout/stderr
/// and, when requested, streams them live to the console.
/// </summary>
public sealed class ProcessRunner : IProcessRunner
{
    public async Task<ProcessResult> RunAsync(ProcessRequest request, CancellationToken cancellationToken = default)
    {
        var stdout = new StringBuilder();
        var stderr = new StringBuilder();

        var outTarget = request.EchoToConsole
            ? PipeTarget.Merge(PipeTarget.ToStringBuilder(stdout), PipeTarget.ToDelegate(Console.Out.WriteLine))
            : PipeTarget.ToStringBuilder(stdout);

        var errTarget = request.EchoToConsole
            ? PipeTarget.Merge(PipeTarget.ToStringBuilder(stderr), PipeTarget.ToDelegate(Console.Error.WriteLine))
            : PipeTarget.ToStringBuilder(stderr);

        var command = Cli.Wrap(request.Executable)
            .WithArguments(request.Arguments)
            .WithValidation(CommandResultValidation.None)
            .WithStandardOutputPipe(outTarget)
            .WithStandardErrorPipe(errTarget);

        if (!string.IsNullOrEmpty(request.WorkingDirectory))
        {
            command = command.WithWorkingDirectory(request.WorkingDirectory);
        }

        if (request.Environment is not null)
        {
            command = command.WithEnvironmentVariables(request.Environment);
        }

        if (request.StandardInput is not null)
        {
            command = command.WithStandardInputPipe(PipeSource.FromString(request.StandardInput));
        }

        var result = await command.ExecuteAsync(cancellationToken).ConfigureAwait(false);
        return new ProcessResult(result.ExitCode, stdout.ToString(), stderr.ToString());
    }
}
