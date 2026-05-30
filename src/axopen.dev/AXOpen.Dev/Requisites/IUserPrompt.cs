using Spectre.Console;

namespace AXOpen.Dev.Requisites;

/// <summary>Abstracts the <c>Read-Host "... (Y/N)"</c> prompts so the checker is testable / scriptable.</summary>
public interface IUserPrompt
{
    /// <summary>Returns true when the user answers Y/y, mirroring the PowerShell prompts.</summary>
    bool Confirm(string message);
}

/// <summary>Interactive console prompt (default for the CLI).</summary>
public sealed class ConsoleUserPrompt : IUserPrompt
{
    public bool Confirm(string message)
    {
        AnsiConsole.Markup($"[yellow]{Markup.Escape(message)} (Y/N)[/] ");
        var response = Console.ReadLine();
        return string.Equals(response?.Trim(), "Y", StringComparison.OrdinalIgnoreCase);
    }
}

/// <summary>Non-interactive prompt that always returns the same answer (for <c>--yes</c> / <c>--non-interactive</c>).</summary>
public sealed class FixedUserPrompt(bool answer) : IUserPrompt
{
    public bool Confirm(string message) => answer;
}
