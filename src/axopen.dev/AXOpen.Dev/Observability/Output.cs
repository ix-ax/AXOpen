using Spectre.Console;

namespace AXOpen.Dev.Observability;

/// <summary>Console output helpers. Replaces the bash colored <c>printf</c> messages.</summary>
public static class Output
{
    public static void Error(string message) => AnsiConsole.MarkupLineInterpolated($"[red]{message}[/]");

    public static void Warning(string message) => AnsiConsole.MarkupLineInterpolated($"[yellow]{message}[/]");

    public static void Success(string message) => AnsiConsole.MarkupLineInterpolated($"[green]{message}[/]");
}
