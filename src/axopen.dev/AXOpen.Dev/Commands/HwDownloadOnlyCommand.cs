using AXOpen.Dev.Apax;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Download an already-compiled HW configuration using certificate auth. Port of
/// <c>hw_download_only.sh</c>.
/// </summary>
public sealed class HwDownloadOnlyCommand(ApaxClient apax)
{
    public async Task<int> ExecuteAsync(string plcName, string ipAddress, string username, string password, CancellationToken ct = default)
    {
        try
        {
            ArgumentGuards.EnsureNotEmpty("PLC_NAME", plcName);
            ArgumentGuards.EnsureNotEmpty("USERNAME", username);
            ArgumentGuards.EnsureNotEmpty("PASSWORD", password);
        }
        catch (ArgumentValidationException ex)
        {
            Output.Error(ex.Message);
            return 1;
        }

        if (!IpValidator.IsValidIp(ipAddress))
        {
            Output.Error($"The PLC_IP_ADDRESS '{ipAddress}' is not a valid IP address.");
            return 1;
        }

        if (!Directory.Exists("./hwc"))
        {
            Output.Error("Directory \"./hwc\" does not exist!!!");
            return 1;
        }

        var hwlFile = Path.Combine("hwc", $"{plcName}.hwl.yml");
        if (!File.Exists(hwlFile))
        {
            Output.Error($"Hardware configuration file {hwlFile} does not exist!!!");
            return 1;
        }

        var certFile = new PlcTarget(ipAddress, plcName, username, password).CertificatePath;
        if (!File.Exists(certFile))
        {
            Output.Error($"Certification file {certFile} does not exist!!!");
            return 1;
        }

        var result = await apax.HwldDownloadAsync(plcName, ipAddress, username, password, certFile, ct);
        if (!result.Success)
        {
            Output.Error("Downloading of the hardware configuration finished with an error!");
            return 1;
        }

        Output.Success("Hardware configuration has been successfully downloaded.");
        return 0;
    }
}
