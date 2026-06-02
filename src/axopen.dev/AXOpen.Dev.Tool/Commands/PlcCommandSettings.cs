using System.ComponentModel;
using Spectre.Console.Cli;

namespace AXOpen.Dev.Tool.Commands;

/// <summary>
/// Shared settings for PLC-targeting verbs. Passwords prefer the AX_TARGET_PWD environment
/// variable; the positional/option value is a deprecated back-compat fallback.
/// </summary>
public class PlcCommandSettings : CommandSettings
{
    [CommandOption("-t|--target <IP>")]
    [Description("PLC IP address (AXTARGET).")]
    public string IpAddress { get; init; } = string.Empty;

    [CommandOption("-u|--username <USER>")]
    [Description("PLC username (AX_USERNAME).")]
    public string Username { get; init; } = string.Empty;

    [CommandOption("-p|--password <PASSWORD>")]
    [Description("PLC password. Prefer the AX_TARGET_PWD environment variable; this option is a deprecated fallback.")]
    public string? Password { get; init; }

    /// <summary>Resolves the password from AX_TARGET_PWD first, then the option value.</summary>
    public string ResolvePassword()
        => Environment.GetEnvironmentVariable("AX_TARGET_PWD") is { Length: > 0 } env ? env : Password ?? string.Empty;
}
