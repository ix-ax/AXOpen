using AXOpen.Dev.Apax;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Tools;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>apax sld load --mode delta. Port of <c>sw_download_delta.sh</c>.</summary>
public sealed class SwDownloadDeltaCommand(ApaxClient apax)
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

        var result = await apax.SldLoadDeltaAsync(ipAddress, platform, username, password, certFile, ct);
        if (!result.Success)
        {
            Output.Error("Downloading of the software using security certificate finished with an error!");
            return 1;
        }

        Output.Success("Software has been successfully downloaded using security certificate.");
        return 0;
    }
}

/// <summary>apax build + dotnet ixc + delta SW download. Port of <c>sw_build_and_download_delta.sh</c>.</summary>
public sealed class SwBuildDownloadDeltaCommand(ApaxClient apax, DotnetClient dotnet)
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

        return await new SwDownloadDeltaCommand(apax).ExecuteAsync(plcName, ipAddress, platform, username, password, ct);
    }
}
