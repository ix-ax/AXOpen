using AXOpen.Dev.Apax;
using AXOpen.Dev.Commands;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Process;

namespace AXOpen.Dev.E2E.Tests;

/// <summary>
/// Read-only end-to-end checks against a PROVISIONED PLC (certificate already present locally and
/// on the device). Enable with AXDEV_E2E_PLC=1 plus AX_TARGET / AX_PLC_NAME / AX_USERNAME /
/// AX_TARGET_PWD.
/// </summary>
/// <remarks>
/// apax shares one PLC connection session across commands run in the same process. The first
/// command establishes that session, so the authenticated command (hw-diag) must run before the
/// unauthenticated one (plc-cert / cert-check); otherwise hw-diag would reuse a credential-less
/// shared session and be denied. The two checks therefore live in one ordered test.
/// </remarks>
public class PlcReadOnlyE2ETests
{
    private static PlcTarget Target() => new(E2E.Target, E2E.PlcName, E2E.Username, E2E.Password);

    private static ApaxClient Apax() => new(new ProcessRunner());

    [E2EFact(E2E.PlcFlag)]
    public async Task HwDiag_then_cert_check_succeed()
    {
        E2E.EnterAppDirectory();

        // Authenticated command first (establishes the shared connection session).
        var diag = await new HwDiagListCommand(Apax()).ExecuteAsync(Target());
        Assert.Equal(0, diag);

        var cert = await new CertHashCheckCommand(Apax()).ExecuteAsync(Target());
        Assert.Equal(0, cert);
    }
}
