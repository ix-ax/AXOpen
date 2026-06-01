using AXOpen.Dev.Apax;
using AXOpen.Dev.Diagnostics;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Compares online (PLC) vs offline (compiled) software. Port of <c>compare_all.sh</c>: writes the
/// output to <c>./online_offline_compare_result.txt</c> and maps the apax exit code to 0/9/10/11
/// (see <see cref="CompareResult"/>).
/// </summary>
public sealed class CompareAllCommand(ApaxClient apax)
{
    public const string ResultFile = "./online_offline_compare_result.txt";

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

        if (File.Exists(ResultFile))
        {
            File.Delete(ResultFile);
        }

        var run = await apax.SldCompareAllAsync(ipAddress, platform, username, password, certFile, ct);
        await File.WriteAllTextAsync(ResultFile, run.StandardOutput, ct);
        Console.WriteLine($"exit_code: {run.ExitCode}");

        var result = CompareResult.FromApaxExitCode(run.ExitCode);
        if (result.IsIdentical)
        {
            Output.Success(result.Message);
        }
        else if (result.Outcome == CompareOutcome.Unspecified)
        {
            Output.Error(result.Message);
        }
        else
        {
            Output.Warning(result.Message);
        }

        return result.ProcessExitCode;
    }
}
