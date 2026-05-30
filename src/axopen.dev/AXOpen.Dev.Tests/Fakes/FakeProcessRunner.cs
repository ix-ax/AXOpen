using AXOpen.Dev.Process;

namespace AXOpen.Dev.Tests.Fakes;

/// <summary>
/// Test double for <see cref="IProcessRunner"/>. Records every request and returns
/// scripted results matched by executable + first argument, falling back to a default.
/// </summary>
public sealed class FakeProcessRunner : IProcessRunner
{
    private readonly List<(Func<ProcessRequest, bool> Match, ProcessResult Result)> _rules = new();

    public List<ProcessRequest> Invocations { get; } = new();

    public ProcessResult Default { get; set; } = new(0, string.Empty, string.Empty);

    /// <summary>Return <paramref name="result"/> for requests matching <paramref name="predicate"/>.</summary>
    public FakeProcessRunner When(Func<ProcessRequest, bool> predicate, ProcessResult result)
    {
        _rules.Add((predicate, result));
        return this;
    }

    /// <summary>Match on executable name and (optionally) the first argument.</summary>
    public FakeProcessRunner When(string executable, ProcessResult result, string? firstArg = null)
        => When(r => r.Executable == executable && (firstArg is null || (r.Arguments.Count > 0 && r.Arguments[0] == firstArg)), result);

    public Task<ProcessResult> RunAsync(ProcessRequest request, CancellationToken cancellationToken = default)
    {
        Invocations.Add(request);
        foreach (var (match, result) in _rules)
        {
            if (match(request))
            {
                return Task.FromResult(result);
            }
        }

        return Task.FromResult(Default);
    }
}
