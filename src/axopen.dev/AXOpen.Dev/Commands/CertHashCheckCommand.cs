using AXOpen.Dev.Apax;
using AXOpen.Dev.Certs;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Plc;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Compares the SHA1 of the stored certificate against the certificate currently on the PLC.
/// Port of <c>is_cert_hash_sha1_equal.sh</c> (certutil replaced by .NET X509).
/// </summary>
public sealed class CertHashCheckCommand(ApaxClient apax)
{
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
        }
        catch (ArgumentValidationException ex)
        {
            Output.Error(ex.Message);
            return 1;
        }

        if (!File.Exists(target.CertificatePath))
        {
            Output.Error($"Certificate file {target.CertificatePath} does not exist!!!");
            return 1;
        }

        var temp = Path.Combine(Path.GetTempPath(), $"axdev-plccert-{Guid.NewGuid():N}.cer");
        try
        {
            var pull = await apax.PullCertificateAsync(target.IpAddress, temp, ct);
            if (!pull.Success || !File.Exists(temp))
            {
                Output.Error("Failed to retrieve the certificate from the PLC.");
                return 1;
            }

            var storedHash = CertService.ComputeSha1Thumbprint(target.CertificatePath);
            var plcHash = CertService.ComputeSha1Thumbprint(temp);
            Console.WriteLine(storedHash);
            Console.WriteLine(plcHash);

            if (CertService.AreEqual(storedHash, plcHash))
            {
                Output.Success($"The hash of the stored certificate file and the certificate inside the PLC with IP address {target.IpAddress} are equal.");
                return 0;
            }

            Output.Error($"The hash of the stored certificate file and the certificate inside the PLC with IP address {target.IpAddress} are different.");
            return 1;
        }
        finally
        {
            if (File.Exists(temp))
            {
                File.Delete(temp);
            }
        }
    }
}
