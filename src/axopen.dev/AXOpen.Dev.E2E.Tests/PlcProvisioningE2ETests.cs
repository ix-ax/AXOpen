using AXOpen.Dev.Apax;
using AXOpen.Dev.Commands;
using AXOpen.Dev.Process;
using AXOpen.Dev.Tools;

namespace AXOpen.Dev.E2E.Tests;

/// <summary>
/// DESTRUCTIVE end-to-end provisioning of a blank PLC: secure-comm setup + first HW download +
/// SW build/download/restart. Overwrites the PLC and the local certs. Enable with
/// AXDEV_E2E_PLC_DESTRUCTIVE=1 plus the AX_* connection env vars.
/// </summary>
public class PlcProvisioningE2ETests
{
    private static ApaxClient Apax() => new(new ProcessRunner());

    [E2EFact(E2E.ProvisionFlag)]
    public async Task Full_first_setup_provisions_the_plc()
    {
        E2E.EnterAppDirectory();

        // Force-clean prior security artifacts so setup-secure-communication can run fresh.
        var certsDir = Path.Combine("certs", E2E.PlcName);
        if (Directory.Exists(certsDir))
        {
            Directory.Delete(certsDir, recursive: true);
        }

        var securityConfig = Path.Combine("hwc", "hwc.gen", $"{E2E.PlcName}.SecurityConfiguration.json");
        if (File.Exists(securityConfig))
        {
            File.Delete(securityConfig);
        }

        // HW: gsd + templates + secure comms + compile + first download + cert pull.
        var hw = await new HwFirstDownloadCommand(Apax(), new OpensslClient(new ProcessRunner()))
            .ExecuteAsync(E2E.Namespace, E2E.PlcName, E2E.Target, E2E.Username, E2E.Password);
        Assert.Equal(0, hw);

        Assert.True(File.Exists(Path.Combine(certsDir, $"{E2E.PlcName}.cer")),
            "The PLC certificate should have been pulled to ./certs/<plc>/<plc>.cer.");

        // SW: apax build + dotnet ixc + full download + restart.
        var sw = await new SwBuildDownloadFullCommand(Apax(), new DotnetClient(new ProcessRunner()))
            .ExecuteAsync(E2E.PlcName, E2E.Target, E2E.Platform, E2E.Username, E2E.Password);
        Assert.Equal(0, sw);
    }
}
