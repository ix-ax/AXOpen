using AXOpen.Dev.Apax;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>Lists hardware diagnostic info from a PLC. Port of <c>hw_diag_list.sh</c>.</summary>
public sealed class HwDiagListCommand(ApaxClient apax, Func<string, bool>? fileExists = null)
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

        var result = await apax.HwDiagListAsync(target.IpAddress, target.Username, target.Password, target.CertificatePath, ct);
        return result.ExitCode;
    }
}
