using AXOpen.Dev.Process;

namespace AXOpen.Dev.Tools;

/// <summary>
/// Wraps the external <c>openssl</c> CLI for the certificate-generation steps of
/// <c>setup_secure_communication.sh</c>. openssl is kept external (cross-platform) rather than
/// porting to .NET crypto so the produced artifacts match the original exactly.
/// All operations run with <paramref name="workingDirectory"/> as the CWD (the per-PLC certs dir).
/// </summary>
public sealed class OpensslClient(IProcessRunner runner)
{
    public const string Executable = "openssl";

    private Task<ProcessResult> Run(string workingDirectory, string[] args, CancellationToken ct)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = args,
            WorkingDirectory = workingDirectory,
        }, ct);

    /// <summary>openssl genrsa -out KEY BITS</summary>
    public Task<ProcessResult> GenerateRsaKeyAsync(string workingDirectory, string keyFile, int bits = 2048, CancellationToken ct = default)
        => Run(workingDirectory, new[] { "genrsa", "-out", keyFile, bits.ToString() }, ct);

    /// <summary>openssl req -new -x509 -days 3650 -key KEY -out CERT -config CFG -extensions v3_req</summary>
    public Task<ProcessResult> SelfSignAsync(string workingDirectory, string keyFile, string certFile, string configFile, CancellationToken ct = default)
        => Run(workingDirectory, new[] { "req", "-new", "-x509", "-days", "3650", "-key", keyFile, "-out", certFile, "-config", configFile, "-extensions", "v3_req" }, ct);

    /// <summary>openssl pkcs12 -export -in CERT -inkey KEY -out P12 -passout pass:PWD</summary>
    public Task<ProcessResult> ExportPkcs12Async(string workingDirectory, string certFile, string keyFile, string p12File, string password, CancellationToken ct = default)
        => Run(workingDirectory, new[] { "pkcs12", "-export", "-in", certFile, "-inkey", keyFile, "-out", p12File, "-passout", $"pass:{password}" }, ct);

    /// <summary>openssl pkcs12 -in P12 -out CRT -nokeys -passin pass:PWD</summary>
    public Task<ProcessResult> ExportCertificateOnlyAsync(string workingDirectory, string p12File, string crtFile, string password, CancellationToken ct = default)
        => Run(workingDirectory, new[] { "pkcs12", "-in", p12File, "-out", crtFile, "-nokeys", "-passin", $"pass:{password}" }, ct);
}
