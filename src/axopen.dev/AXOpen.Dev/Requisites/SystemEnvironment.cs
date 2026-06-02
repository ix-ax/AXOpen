using System.Runtime.Versioning;
using SysProcess = System.Diagnostics.Process;
using ProcessStartInfo = System.Diagnostics.ProcessStartInfo;

namespace AXOpen.Dev.Requisites;

/// <summary>
/// Windows environment + elevated-process helpers used by the installers in the requisites checker.
/// Ports <c>Refresh-Path</c>, the user-PATH persistence, env-var set/get and <c>Start-Process -Verb RunAs</c>.
/// </summary>
[SupportedOSPlatform("windows")]
public static class SystemEnvironment
{
    /// <summary><c>Refresh-Path</c>: rebuilds the process PATH from Machine + User scopes.</summary>
    public static void RefreshPath()
    {
        var machine = Environment.GetEnvironmentVariable("Path", EnvironmentVariableTarget.Machine);
        var user = Environment.GetEnvironmentVariable("Path", EnvironmentVariableTarget.User);
        Environment.SetEnvironmentVariable("Path", $"{machine};{user}");
    }

    /// <summary>Prepends <paramref name="directory"/> to the user PATH (persisted) if absent, then refreshes.</summary>
    public static void EnsureUserPath(string directory)
    {
        var existing = Environment.GetEnvironmentVariable("PATH", EnvironmentVariableTarget.User) ?? string.Empty;
        if (!existing.Contains(directory, StringComparison.OrdinalIgnoreCase))
        {
            Environment.SetEnvironmentVariable("PATH", $"{directory};{existing}", EnvironmentVariableTarget.User);
            RefreshPath();
        }
    }

    public static string? GetUserEnv(string name)
        => Environment.GetEnvironmentVariable(name, EnvironmentVariableTarget.User);

    public static void SetUserEnv(string name, string value)
        => Environment.SetEnvironmentVariable(name, value, EnvironmentVariableTarget.User);

    /// <summary>Runs an installer elevated (<c>-Verb RunAs</c>) and waits; returns its exit code (or -1 if cancelled).</summary>
    public static int RunElevated(string fileName, string arguments)
    {
        var psi = new ProcessStartInfo
        {
            FileName = fileName,
            Arguments = arguments,
            UseShellExecute = true,
            Verb = "runas",
        };

        try
        {
            using var proc = SysProcess.Start(psi);
            if (proc is null)
            {
                return -1;
            }

            proc.WaitForExit();
            return proc.ExitCode;
        }
        catch (Exception)
        {
            // The UAC prompt was declined or the shell could not elevate.
            return -1;
        }
    }
}
