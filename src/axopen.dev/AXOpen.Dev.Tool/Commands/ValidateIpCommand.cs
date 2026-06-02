using System.ComponentModel;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Validation;
using Spectre.Console.Cli;

namespace AXOpen.Dev.Tool.Commands;

/// <summary>axdev validate-ip &lt;ip&gt; — port of validate_ip.sh.</summary>
public sealed class ValidateIpCommand : Command<ValidateIpCommand.Settings>
{
    public sealed class Settings : CommandSettings
    {
        [CommandArgument(0, "<ip>")]
        [Description("IPv4 address to validate.")]
        public string Ip { get; init; } = string.Empty;
    }

    public override int Execute(CommandContext context, Settings settings)
    {
        if (IpValidator.IsValidIp(settings.Ip))
        {
            return 0;
        }

        Output.Error($"The input parameter '{settings.Ip}' is not a valid IP address.");
        return 1;
    }
}
