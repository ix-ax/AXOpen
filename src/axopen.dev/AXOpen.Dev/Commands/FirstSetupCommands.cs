using AXOpen.Dev.Apax;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Tools;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>apax hwc compile. Port of <c>hw_compile.sh</c>.</summary>
public sealed class HwCompileCommand(ApaxClient apax)
{
    public async Task<int> ExecuteAsync(CancellationToken ct = default)
    {
        var result = await apax.HwcCompileAsync(ct);
        if (!result.Success)
        {
            Output.Error("The compilation of the hardware configuration finished with an error!");
            return 1;
        }

        Output.Success("Hardware configuration compiled successfully.");
        return 0;
    }
}

/// <summary>
/// Compile HW, generate ST id/address files, first-download HW with the master password and pull
/// the PLC certificate. Port of <c>hw_first_compile_and_first_download.sh</c>.
/// </summary>
public sealed class HwFirstCompileAndDownloadCommand(ApaxClient apax)
{
    public async Task<int> ExecuteAsync(string @namespace, string plcName, string ipAddress, string password, CancellationToken ct = default)
    {
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

        if (await new HwCompileCommand(apax).ExecuteAsync(ct) != 0) return 1;
        if (new CopyHardwareIdsCommand().Execute(@namespace, plcName) != 0) return 1;
        if (new CopyIoAddressesCommand().Execute(@namespace, plcName) != 0) return 1;

        var download = await apax.HwldFirstDownloadAsync(plcName, ipAddress, password, ct);
        if (!download.Success)
        {
            Output.Error("Downloading of the hardware configuration finished with an error!");
            return 1;
        }

        Output.Success("Hardware configuration has been successfully downloaded.");

        var certFile = $"./certs/{plcName}/{plcName}.cer";
        var pull = await apax.PullCertificateToFileAsync(ipAddress, certFile, ct);
        if (!pull.Success)
        {
            Output.Error("Uploading of the security certificate finished with an error!");
            return 1;
        }

        Output.Success("Security certificate has been successfully uploaded.");
        return 0;
    }
}

/// <summary>
/// First HW download using the master password, then pull the PLC certificate. Assumes the HW is
/// already compiled and secure comms configured. Port of <c>hw_first_download_only.sh</c>.
/// </summary>
public sealed class HwFirstDownloadOnlyCommand(ApaxClient apax)
{
    public async Task<int> ExecuteAsync(string plcName, string ipAddress, string password, CancellationToken ct = default)
    {
        try
        {
            ArgumentGuards.EnsureNotEmpty("PLC_NAME", plcName);
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

        var download = await apax.HwldFirstDownloadAsync(plcName, ipAddress, password, ct);
        if (!download.Success)
        {
            Output.Error("Downloading of the hardware configuration finished with an error!");
            return 1;
        }

        Output.Success("Hardware configuration has been successfully downloaded.");

        var certFile = $"./certs/{plcName}/{plcName}.cer";
        var pull = await apax.PullCertificateToFileAsync(ipAddress, certFile, ct);
        if (!pull.Success)
        {
            Output.Error("Uploading of the security certificate finished with an error!");
            return 1;
        }

        Output.Success("Security certificate has been successfully uploaded.");
        return 0;
    }
}

/// <summary>
/// Full first-time HW provisioning: install GSD, copy HWL templates, set up secure communication,
/// then compile + first-download HW and pull the certificate. Port of <c>hw_first_download.sh</c>.
/// (Assumes apax dependencies are already installed.)
/// </summary>
public sealed class HwFirstDownloadCommand(ApaxClient apax, OpensslClient openssl)
{
    public async Task<int> ExecuteAsync(string @namespace, string plcName, string ipAddress, string username, string password, CancellationToken ct = default)
    {
        if (await new GsdInstallCommand(apax).ExecuteAsync(ct) != 0) return 1;
        if (new HwlCopyCommand().Execute() != 0) return 1;
        if (await new SetupSecureCommunicationCommand(apax, openssl).ExecuteAsync(plcName, username, password, ipAddress, ct) != 0) return 1;
        if (await new HwFirstCompileAndDownloadCommand(apax).ExecuteAsync(@namespace, plcName, ipAddress, password, ct) != 0) return 1;

        Output.Success("Hardware configuration has been successfully compiled and downloaded.");
        return 0;
    }
}

/// <summary>apax sld load --mode FULL --restart, using certificate auth. Port of <c>sw_download_full.sh</c>.</summary>
public sealed class SwDownloadFullCommand(ApaxClient apax)
{
    public async Task<int> ExecuteAsync(string plcName, string ipAddress, string platform, string username, string password, CancellationToken ct = default)
    {
        try
        {
            ArgumentGuards.EnsureNotEmpty("PLC_NAME", plcName);
            ArgumentGuards.EnsureNotEmpty("PLATFORM", platform);
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

        var certFile = new PlcTarget(ipAddress, plcName, username, password).CertificatePath;
        if (!File.Exists(certFile))
        {
            Output.Error($"Certification file {certFile} does not exist!!!");
            return 1;
        }

        var result = await apax.SldLoadFullAsync(ipAddress, platform, username, password, certFile, ct);
        if (!result.Success)
        {
            Output.Error("Downloading of the software using security certificate finished with an error!");
            return 1;
        }

        Output.Success("Software has been successfully downloaded using security certificate.");
        return 0;
    }
}

/// <summary>apax build + dotnet ixc + full SW download. Port of <c>sw_build_and_download_full.sh</c>.</summary>
public sealed class SwBuildDownloadFullCommand(ApaxClient apax, DotnetClient dotnet)
{
    public async Task<int> ExecuteAsync(string plcName, string ipAddress, string platform, string username, string password, CancellationToken ct = default)
    {
        if (!(await apax.BuildAsync(ct)).Success)
        {
            Output.Error("apax build finished with an error!");
            return 1;
        }

        if (!(await dotnet.IxcAsync(ct)).Success)
        {
            Output.Error("dotnet ixc finished with an error!");
            return 1;
        }

        return await new SwDownloadFullCommand(apax).ExecuteAsync(plcName, ipAddress, platform, username, password, ct);
    }
}
