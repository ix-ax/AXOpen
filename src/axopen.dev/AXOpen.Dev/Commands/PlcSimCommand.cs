using System.Runtime.InteropServices;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Tools;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Starts the PLCSIM Advanced starter tool. Port of <c>plcsimadvanced.sh</c>. PLCSIM Advanced is
/// Windows-only, so on other platforms this is a no-op that warns and succeeds (so orchestrators
/// don't break).
/// </summary>
public sealed class PlcSimCommand(DotnetClient dotnet)
{
    private const string StarterProject =
        @"..\..\tools\src\PlcSimAdvancedStarter\PlcSimAdvancedStarterTool\PlcSimAdvancedStarterTool.csproj";

    public async Task<int> ExecuteAsync(string instanceName, string plcName, string ipAddress, CancellationToken ct = default)
    {
        try
        {
            ArgumentGuards.EnsureNotEmpty("INSTANCE_NAME", instanceName);
            ArgumentGuards.EnsureNotEmpty("PLC_NAME", plcName);
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

        if (!RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            Output.Warning("PLCSIM Advanced is only supported on Windows; skipping 'plcsim' on this OS.");
            return 0;
        }

        var result = await dotnet.RunProjectAsync(
            StarterProject,
            new[] { "startplcsim", "-x", instanceName, "-n", plcName, "-t", ipAddress },
            ct);
        return result.ExitCode;
    }
}
