using AXOpen.Dev.Apax;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Restarts a PLC by switching it to STOP then back to RUN, using certificate auth.
/// Port of <c>restart_PLC.sh</c>.
/// </summary>
public sealed class RestartPlcCommand(ApaxClient apax, Func<string, bool>? fileExists = null)
{
    private readonly Func<string, bool> _fileExists = fileExists ?? File.Exists;

    public async Task<int> ExecuteAsync(PlcTarget target, CancellationToken ct = default)
    {
        if (!IpValidator.IsValidIp(target.IpAddress))
        {
            Output.Error($"The PLC_IP_ADDRESS '{target.IpAddress}' is not a valid IP address.");
            return 1;
        }

        try
        {
            ArgumentGuards.EnsureNotEmpty("PLC_NAME", target.Name);
            ArgumentGuards.EnsureNotEmpty("USERNAME", target.Username);
            ArgumentGuards.EnsureNotEmpty("PASSWORD", target.Password);
        }
        catch (ArgumentValidationException ex)
        {
            Output.Error(ex.Message);
            return 1;
        }

        if (!_fileExists(target.CertificatePath))
        {
            Output.Error($"Certificate file {target.CertificatePath} not found!!!");
            return 1;
        }

        var stop = await apax.SetModeAsync(PlcMode.Stop, target.IpAddress, target.Username, target.Password, target.CertificatePath, ct);
        if (!stop.Success)
        {
            Output.Error("Unable to set the PLC to STOP mode! Please check the details above.");
            return 1;
        }

        Output.Success("PLC was successfully set to STOP mode.");

        var run = await apax.SetModeAsync(PlcMode.Run, target.IpAddress, target.Username, target.Password, target.CertificatePath, ct);
        if (!run.Success)
        {
            Output.Error("Unable to set the PLC to RUN mode! Please check the details above.");
            return 1;
        }

        Output.Success("PLC was successfully set to RUN mode.");
        return 0;
    }
}
