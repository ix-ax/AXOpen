using AXOpen.Dev.Apax;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Requisites;
using AXOpen.Dev.Tools;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>Shared helpers for the top-level orchestrators.</summary>
internal static class Orchestration
{
    public static async Task<bool> RequisitesOkAsync(RequisiteChecker checker, CancellationToken ct)
        => await checker.CheckApaxAsync(ct) && await checker.CheckNugetAsync(ct) && checker.CheckCustomRegistry();

    /// <summary>Delete the contents of a folder (like <c>rm -rf "$folder/"*</c>), keeping the folder.</summary>
    public static void CleanContents(string directory)
    {
        if (!Directory.Exists(directory))
        {
            return;
        }

        foreach (var file in Directory.GetFiles(directory))
        {
            File.Delete(file);
        }

        foreach (var sub in Directory.GetDirectories(directory))
        {
            Directory.Delete(sub, recursive: true);
        }
    }
}

/// <summary>
/// Full initial bring-up of a (blank) PLC: requisites → optional PLCSIM → clean/install →
/// optional force-clean of certs → reset PLC → first HW download → SW build + full download.
/// Port of <c>all_first.sh</c>.
/// </summary>
public sealed class AllFirstCommand(ApaxClient apax, OpensslClient openssl, DotnetClient dotnet)
{
    public async Task<int> ExecuteAsync(string @namespace, string plcName, string ipAddress, string platform, string username, string password, bool usePlcSim, bool force, CancellationToken ct = default)
    {
        try
        {
            ArgumentGuards.EnsureNotEmpty("NAMESPACE", @namespace);
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

        if (!PasswordValidator.IsSafe(password))
        {
            Output.Error("The PASSWORD contains problematic characters. Cannot use: $ ` \\ \" ' & | ; < > ( ) * ? [ ] { } or whitespace");
            return 1;
        }

        if (!await Orchestration.RequisitesOkAsync(new RequisiteChecker(apax.Runner), ct))
        {
            return 1;
        }

        if (usePlcSim)
        {
            await new PlcSimCommand(dotnet).ExecuteAsync(@namespace, plcName, ipAddress, ct);
        }

        await apax.CleanAsync(ct);
        await apax.InstallAsync(catalog: true, ct);
        await apax.InstallAsync(catalog: false, ct);

        if (force)
        {
            Orchestration.CleanContents("./certs");
            Orchestration.CleanContents("./hwc/hwc.gen");
        }

        // clean_plc (reset keeping only IP); the bash ignores its result.
        await new ResetPlcCommand(apax).ExecuteAsync(ResetScope.KeepOnlyIp, ipAddress, username, password, ct);

        if (await new HwFirstDownloadCommand(apax, openssl).ExecuteAsync(@namespace, plcName, ipAddress, username, password, ct) != 0)
        {
            return 1;
        }

        if (await new SwBuildDownloadFullCommand(apax, dotnet).ExecuteAsync(plcName, ipAddress, platform, username, password, ct) != 0)
        {
            return 1;
        }

        Output.Success("Software has been successfully compiled and downloaded.");
        return 0;
    }
}

/// <summary>
/// Compile everything (HW + SW) and pull the PLC certificate, without downloading to the PLC.
/// Port of <c>compile_all.sh</c>.
/// </summary>
/// <remarks>
/// The bash calls setup_secure_communication with only 3 args (missing the IP), which makes that
/// script fail its argument check; this port passes the IP so the step actually works.
/// </remarks>
public sealed class CompileAllCommand(ApaxClient apax, OpensslClient openssl, DotnetClient dotnet)
{
    public async Task<int> ExecuteAsync(string @namespace, string plcName, string ipAddress, string platform, string username, string password, bool usePlcSim, CancellationToken ct = default)
    {
        try
        {
            ArgumentGuards.EnsureNotEmpty("NAMESPACE", @namespace);
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

        await apax.InstallAsync(catalog: false, ct);

        if (!await Orchestration.RequisitesOkAsync(new RequisiteChecker(apax.Runner), ct))
        {
            return 1;
        }

        if (usePlcSim)
        {
            await new PlcSimCommand(dotnet).ExecuteAsync(@namespace, plcName, ipAddress, ct);
        }

        await apax.CleanAsync(ct);
        await apax.InstallAsync(catalog: true, ct);
        await apax.InstallAsync(catalog: false, ct);

        if (await new GsdInstallCommand(apax).ExecuteAsync(ct) != 0) return 1;
        if (new HwlCopyCommand().Execute() != 0) return 1;
        if (await new SetupSecureCommunicationCommand(apax, openssl).ExecuteAsync(plcName, username, password, ipAddress, ct) != 0) return 1;
        if (await new HwCompileCommand(apax).ExecuteAsync(ct) != 0) return 1;
        if (new CopyHardwareIdsCommand().Execute(@namespace, plcName) != 0) return 1;
        if (new CopyIoAddressesCommand().Execute(@namespace, plcName) != 0) return 1;

        var certFile = $"./certs/{plcName}/{plcName}.cer";
        Directory.CreateDirectory(Path.Combine("certs", plcName));
        if (!(await apax.PullCertificateToFileAsync(ipAddress, certFile, ct)).Success)
        {
            Output.Error("Uploading of the security certificate finished with an error!");
            return 1;
        }

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

        return 0;
    }
}

/// <summary>
/// Smart update dispatcher. Port of <c>all.sh</c>:
/// <list type="bullet">
/// <item>force = true: requires existing cert artifacts, then gsd + hwl + first-compile-download + SW.</item>
/// <item>force = false, no cert: full <see cref="AllFirstCommand"/>.</item>
/// <item>force = false, cert present but hash differs from PLC: full <see cref="AllFirstCommand"/>.</item>
/// <item>force = false, cert matches PLC: fast path — <see cref="HwUpdateCommand"/> + SW.</item>
/// </list>
/// </summary>
/// <remarks>
/// CAVEAT: the fast path runs the unauthenticated cert-hash check (apax plc-cert) before the
/// authenticated hw_update. The bash ran these as separate processes; in-process they share one
/// apax connection session, so the authenticated step can be denied (see the connection-sharing
/// note). Verify on hardware; prefer force/alf if the fast path is denied.
/// </remarks>
public sealed class AllCommand(ApaxClient apax, OpensslClient openssl, DotnetClient dotnet)
{
    public async Task<int> ExecuteAsync(string @namespace, string plcName, string ipAddress, string platform, string username, string password, bool usePlcSim, bool force, CancellationToken ct = default)
    {
        try
        {
            ArgumentGuards.EnsureNotEmpty("NAMESPACE", @namespace);
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

        var certsDir = $"./certs/{plcName}";
        var certFile = $"{certsDir}/{plcName}.cer";
        var checker = new RequisiteChecker(apax.Runner);

        if (force)
        {
            foreach (var (path, label) in new[]
                     {
                         (certFile, "Certification file"),
                         ($"{certsDir}/containerWithPublicAndPrivateKeys_x509.p12", "Public/private key container file"),
                         ($"{certsDir}/reference_x509.crt", "Reference file"),
                     })
            {
                if (!File.Exists(path))
                {
                    Output.Error($"{label} {path} does not exist.");
                    return 1;
                }
            }

            if (!await Orchestration.RequisitesOkAsync(checker, ct)) return 1;
            if (usePlcSim) await new PlcSimCommand(dotnet).ExecuteAsync(@namespace, plcName, ipAddress, ct);
            if (await new GsdInstallCommand(apax).ExecuteAsync(ct) != 0) return 1;
            if (new HwlCopyCommand().Execute() != 0) return 1;
            if (await new HwFirstCompileAndDownloadCommand(apax).ExecuteAsync(@namespace, plcName, ipAddress, password, ct) != 0) return 1;
            return await new SwBuildDownloadFullCommand(apax, dotnet).ExecuteAsync(plcName, ipAddress, platform, username, password, ct);
        }

        if (!File.Exists(certFile))
        {
            return await new AllFirstCommand(apax, openssl, dotnet)
                .ExecuteAsync(@namespace, plcName, ipAddress, platform, username, password, usePlcSim, force: false, ct);
        }

        if (!await Orchestration.RequisitesOkAsync(checker, ct)) return 1;
        if (usePlcSim) await new PlcSimCommand(dotnet).ExecuteAsync(@namespace, plcName, ipAddress, ct);

        await apax.CleanAsync(ct);
        await apax.InstallAsync(catalog: true, ct);
        await apax.InstallAsync(catalog: false, ct);

        var hashEqual = await new CertHashCheckCommand(apax)
            .ExecuteAsync(new PlcTarget(ipAddress, plcName, username, password), ct) == 0;

        if (!hashEqual)
        {
            Output.Warning($"Certificate {certFile} exists but its SHA1 differs from the PLC's; regenerating via first setup.");
            return await new AllFirstCommand(apax, openssl, dotnet)
                .ExecuteAsync(@namespace, plcName, ipAddress, platform, username, password, usePlcSim, force: false, ct);
        }

        Output.Success($"Certificate {certFile} matches the PLC; performing a fast update.");
        if (await new HwUpdateCommand(apax).ExecuteAsync(@namespace, plcName, ipAddress, username, password, ct) != 0) return 1;
        return await new SwBuildDownloadFullCommand(apax, dotnet).ExecuteAsync(plcName, ipAddress, platform, username, password, ct);
    }
}

/// <summary>Compile everything then compare online vs offline. Port of <c>compile_all_compare_all.sh</c>.</summary>
public sealed class CompileAllCompareAllCommand(ApaxClient apax, OpensslClient openssl, DotnetClient dotnet)
{
    public async Task<int> ExecuteAsync(string @namespace, string plcName, string ipAddress, string platform, string username, string password, bool usePlcSim, CancellationToken ct = default)
    {
        if (await new CompileAllCommand(apax, openssl, dotnet).ExecuteAsync(@namespace, plcName, ipAddress, platform, username, password, usePlcSim, ct) != 0)
        {
            return 1;
        }

        return await new CompareAllCommand(apax).ExecuteAsync(plcName, ipAddress, platform, username, password, ct);
    }
}
