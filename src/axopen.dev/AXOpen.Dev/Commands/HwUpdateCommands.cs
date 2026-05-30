using AXOpen.Dev.Apax;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Compile HW, regenerate ST id/address files, then download with certificate auth.
/// Port of <c>hw_compile_and_download.sh</c>.
/// </summary>
public sealed class HwCompileAndDownloadCommand(ApaxClient apax)
{
    public async Task<int> ExecuteAsync(string @namespace, string plcName, string ipAddress, string username, string password, CancellationToken ct = default)
    {
        try
        {
            ArgumentGuards.EnsureNotEmpty("NAMESPACE", @namespace);
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

        if (await new HwCompileCommand(apax).ExecuteAsync(ct) != 0) return 1;
        if (new CopyHardwareIdsCommand().Execute(@namespace, plcName) != 0) return 1;
        if (new CopyIoAddressesCommand().Execute(@namespace, plcName) != 0) return 1;
        return await new HwDownloadOnlyCommand(apax).ExecuteAsync(plcName, ipAddress, username, password, ct);
    }
}

/// <summary>
/// Update HW: install GSD, copy templates, then compile + download with certificate.
/// Port of <c>hw_update.sh</c>.
/// </summary>
public sealed class HwUpdateCommand(ApaxClient apax)
{
    public async Task<int> ExecuteAsync(string @namespace, string plcName, string ipAddress, string username, string password, CancellationToken ct = default)
    {
        if (await new GsdInstallCommand(apax).ExecuteAsync(ct) != 0) return 1;
        if (new HwlCopyCommand().Execute() != 0) return 1;
        return await new HwCompileAndDownloadCommand(apax).ExecuteAsync(@namespace, plcName, ipAddress, username, password, ct);
    }
}
