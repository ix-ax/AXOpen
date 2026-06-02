using AXOpen.Dev.Apax;
using AXOpen.Dev.Observability;
using AXOpen.Dev.Process;
using AXOpen.Dev.Tools;
using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Generates a self-signed certificate (via openssl) and configures secure TLS communication on
/// the PLC's hardware configuration. Port of <c>setup_secure_communication.sh</c>.
/// Paths are relative to the current working directory (the app folder).
/// </summary>
public sealed class SetupSecureCommunicationCommand(ApaxClient apax, OpensslClient openssl)
{
    public async Task<int> ExecuteAsync(string plcName, string username, string password, string ipAddress, CancellationToken ct = default)
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
            Output.Error($"The IP_ADDRESS '{ipAddress}' is not a valid IP address.");
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

        var certsDir = Path.Combine("certs", plcName);
        const string alreadyConfigured = "If you want to change the security configuration, you must delete it manually before triggering this command.";

        var securityConfig = Path.Combine("hwc", "hwc.gen", $"{plcName}.SecurityConfiguration.json");
        foreach (var guard in new[]
                 {
                     securityConfig,
                     Path.Combine(certsDir, "containerWithPublicAndPrivateKeys_x509.p12"),
                     Path.Combine(certsDir, "reference_x509.crt"),
                     Path.Combine(certsDir, $"{plcName}.cer"),
                 })
        {
            if (File.Exists(guard))
            {
                Output.Warning($"File '{guard}' already exists. {alreadyConfigured}");
                return 1;
            }
        }

        Directory.CreateDirectory(certsDir);
        const string keyFile = "privateKey.pem";
        const string certFile = "server.cert.pem";
        const string configFile = "server_cert_ext.cnf";
        const string p12File = "containerWithPublicAndPrivateKeys_x509.p12";
        const string crtFile = "reference_x509.crt";

        foreach (var leftover in new[] { keyFile, certFile, configFile })
        {
            var p = Path.Combine(certsDir, leftover);
            if (File.Exists(p)) File.Delete(p);
        }

        await File.WriteAllTextAsync(Path.Combine(certsDir, configFile), BuildOpenSslConfig(ipAddress), ct);

        // ---- openssl: key -> self-signed cert -> pkcs12 -> cert-only crt ----
        if (!await OkAsync(openssl.GenerateRsaKeyAsync(certsDir, keyFile, 2048, ct), "Generating private key")) return 1;
        if (!await OkAsync(openssl.SelfSignAsync(certsDir, keyFile, certFile, configFile, ct), "Generating self-signed certificate")) return 1;
        if (!await OkAsync(openssl.ExportPkcs12Async(certsDir, certFile, keyFile, p12File, password, ct), "Exporting to PKCS12")) return 1;
        if (!await OkAsync(openssl.ExportCertificateOnlyAsync(certsDir, p12File, crtFile, password, ct), "Exporting certificate (crt)")) return 1;

        foreach (var leftover in new[] { keyFile, certFile, configFile })
        {
            var p = Path.Combine(certsDir, leftover);
            if (File.Exists(p)) File.Delete(p);
        }

        // ---- apax hwc: setup secure comm, import cert (TLS + WebServer), passwords ----
        var p12Path = $"./certs/{plcName}/{p12File}";
        if (!await OkAsync(apax.HwcSetupSecureCommunicationAsync(plcName, password, ct), "apax hwc setup-secure-communication")) return 1;
        if (!await OkAsync(apax.HwcImportCertificateAsync(plcName, p12Path, password, "TLS", ct), "apax hwc import-certificate (TLS)")) return 1;
        if (!await OkAsync(apax.HwcImportCertificateAsync(plcName, p12Path, password, "WebServer", ct), "apax hwc import-certificate (WebServer)")) return 1;
        if (!await OkAsync(apax.HwcSetAccessProtectionPasswordAsync(plcName, password, ct), "apax hwc set-accessprotection-password")) return 1;
        if (!await OkAsync(apax.HwcSetUserPasswordAsync(plcName, username, password, ct), "apax hwc manage-users set-password")) return 1;

        Output.Success("Secure communication configured successfully.");
        return 0;
    }

    private static async Task<bool> OkAsync(Task<ProcessResult> task, string what)
    {
        var result = await task;
        if (!result.Success)
        {
            Output.Error($"{what} failed. Please check the details above.");
            return false;
        }

        return true;
    }

    // Mirrors the heredoc in setup_secure_communication.sh. DNSNAME and URI are intentionally
    // empty (as in the source); CN falls back to "localhost".
    private static string BuildOpenSslConfig(string ipAddress) =>
        "[ req ]\n" +
        "default_bits       = 2048\n" +
        "default_md         = sha256\n" +
        "distinguished_name = dn\n" +
        "x509_extensions    = v3_req\n" +
        "prompt             = no\n" +
        "\n" +
        "[ dn ]\n" +
        "C  = XX\n" +
        "ST = StateName\n" +
        "L  = CityName\n" +
        "O  = CompanyName\n" +
        "OU = CompanySectionName\n" +
        "CN = localhost\n" +
        "\n" +
        "[ v3_req ]\n" +
        "basicConstraints = CA:FALSE\n" +
        "keyUsage = critical, digitalSignature, nonRepudiation, keyCertSign, keyCertSign, keyEncipherment, dataEncipherment\n" +
        "extendedKeyUsage = serverAuth,clientAuth\n" +
        "subjectAltName = @alt_names\n" +
        "subjectKeyIdentifier = hash\n" +
        "authorityKeyIdentifier = keyid:always,issuer:always\n" +
        "\n" +
        "[ alt_names ]\n" +
        "DNS.1 = \n" +
        $"IP.1 = {ipAddress}\n" +
        "URI.1 = \n";
}
