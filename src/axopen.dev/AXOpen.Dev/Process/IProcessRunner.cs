namespace AXOpen.Dev.Process;

/// <summary>
/// Describes an external process invocation (apax, dotnet, openssl, …).
/// </summary>
public sealed record ProcessRequest
{
    public required string Executable { get; init; }
    public IReadOnlyList<string> Arguments { get; init; } = Array.Empty<string>();
    public string? WorkingDirectory { get; init; }
    public IReadOnlyDictionary<string, string?>? Environment { get; init; }

    /// <summary>Optional text piped to the process's standard input (e.g. the bash <c>echo y |</c> idiom).</summary>
    public string? StandardInput { get; init; }

    /// <summary>When true, the process output is also echoed live to the console.</summary>
    public bool EchoToConsole { get; init; } = true;
}

/// <summary>Result of an external process invocation.</summary>
public sealed record ProcessResult(int ExitCode, string StandardOutput, string StandardError)
{
    public bool Success => ExitCode == 0;
}

/// <summary>
/// Abstraction over external process execution so orchestration logic is unit-testable
/// (replace with a fake in tests) and the implementation is cross-platform.
/// </summary>
public interface IProcessRunner
{
    Task<ProcessResult> RunAsync(ProcessRequest request, CancellationToken cancellationToken = default);
}
