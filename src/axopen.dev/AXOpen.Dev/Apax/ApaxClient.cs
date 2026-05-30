using AXOpen.Dev.Process;

namespace AXOpen.Dev.Apax;

public enum PlcMode
{
    Stop,
    Run,
}

public enum ResetScope
{
    /// <summary>apax <c>--reset-plc KeepOnlyIP</c> — clears everything except the IP.</summary>
    KeepOnlyIp,

    /// <summary>apax <c>--reset-plc All</c> — full factory reset.</summary>
    All,
}

/// <summary>
/// Thin, cross-platform wrapper over the <c>apax</c> CLI. Each method maps 1:1 to the command
/// lines used by the bash scripts so behavior is preserved. Process execution is delegated to
/// <see cref="IProcessRunner"/> so callers are unit-testable with a fake.
/// </summary>
public sealed class ApaxClient(IProcessRunner runner)
{
    public const string Executable = "apax";

    /// <summary>The underlying process runner (used to build sibling clients like the requisite checker).</summary>
    public IProcessRunner Runner => runner;

    /// <summary>apax plc-info set-mode {STOP|RUN} --target IP --username U --password P --certificate CERT --no-input</summary>
    public Task<ProcessResult> SetModeAsync(PlcMode mode, string ipAddress, string username, string password, string certificatePath, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "plc-info", "set-mode", mode == PlcMode.Stop ? "STOP" : "RUN",
                "--target", ipAddress,
                "--username", username,
                "--password", password,
                "--certificate", certificatePath,
                "--no-input",
            },
        }, ct);

    /// <summary>apax hw-diag list --target IP --username U --password P --certificate CERT</summary>
    public Task<ProcessResult> HwDiagListAsync(string ipAddress, string username, string password, string certificatePath, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "hw-diag", "list",
                "--target", ipAddress,
                "--username", username,
                "--password", password,
                "--certificate", certificatePath,
            },
        }, ct);

    /// <summary>apax plc-cert -t IP -o OUTPUT — pulls the PLC's public certificate.</summary>
    public Task<ProcessResult> PullCertificateAsync(string ipAddress, string outputPath, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[] { "plc-cert", "-t", ipAddress, "-o", outputPath },
        }, ct);

    /// <summary>echo y | apax hwld load --target IP --reset-plc {KeepOnlyIP|All} --username U --password P --accept-security-disclaimer</summary>
    public Task<ProcessResult> ResetAsync(ResetScope scope, string ipAddress, string username, string password, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "hwld", "load",
                "--target", ipAddress,
                "--reset-plc", scope == ResetScope.KeepOnlyIp ? "KeepOnlyIP" : "All",
                "--username", username,
                "--password", password,
                "--accept-security-disclaimer",
            },
            StandardInput = "y\n",
        }, ct);

    // ---- Hardware configuration ------------------------------------------------------------

    /// <summary>apax hwc compile -i .\hwc -o bin/hwc/</summary>
    public Task<ProcessResult> HwcCompileAsync(CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[] { "hwc", "compile", "-i", ".\\hwc", "-o", "bin/hwc/" },
        }, ct);

    /// <summary>apax hwc install-gsd --input ./gsd</summary>
    public Task<ProcessResult> HwcInstallGsdAsync(string gsdDirectory, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[] { "hwc", "install-gsd", "--input", gsdDirectory },
        }, ct);

    // ---- Secure communication --------------------------------------------------------------

    /// <summary>apax hwc setup-secure-communication --module-name X --no-input --input .\hwc --master-password P</summary>
    public Task<ProcessResult> HwcSetupSecureCommunicationAsync(string plcName, string masterPassword, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "hwc", "setup-secure-communication",
                "--module-name", plcName,
                "--no-input",
                "--input", ".\\hwc",
                "--master-password", masterPassword,
            },
        }, ct);

    /// <summary>apax hwc import-certificate --module-name X --input .\hwc --certificate P12 --passphrase P --purpose TLS|WebServer</summary>
    public Task<ProcessResult> HwcImportCertificateAsync(string plcName, string certificatePath, string passphrase, string purpose, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "hwc", "import-certificate",
                "--module-name", plcName,
                "--input", ".\\hwc",
                "--certificate", certificatePath,
                "--passphrase", passphrase,
                "--purpose", purpose,
            },
        }, ct);

    /// <summary>apax hwc set-accessprotection-password --module-name X --input .\hwc --level FullAccess --password P</summary>
    public Task<ProcessResult> HwcSetAccessProtectionPasswordAsync(string plcName, string password, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "hwc", "set-accessprotection-password",
                "--module-name", plcName,
                "--input", ".\\hwc",
                "--level", "FullAccess",
                "--password", password,
            },
        }, ct);

    /// <summary>apax hwc manage-users --module-name X --input .\hwc set-password --username U --password P</summary>
    public Task<ProcessResult> HwcSetUserPasswordAsync(string plcName, string username, string password, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "hwc", "manage-users",
                "--module-name", plcName,
                "--input", ".\\hwc",
                "set-password",
                "--username", username,
                "--password", password,
            },
        }, ct);

    // ---- Download / certificate ------------------------------------------------------------

    /// <summary>echo y | apax hwld load --input bin/hwc/X --target IP --master-password P --accept-security-disclaimer --log Information</summary>
    public Task<ProcessResult> HwldFirstDownloadAsync(string plcName, string ipAddress, string masterPassword, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "hwld", "load",
                "--input", $"bin/hwc/{plcName}",
                "--target", ipAddress,
                "--master-password", masterPassword,
                "--accept-security-disclaimer",
                "--log", "Information",
            },
            StandardInput = "y\n",
        }, ct);

    /// <summary>apax plc-cert --target IP --output OUTPUT — retrieves the PLC certificate to a file.</summary>
    public Task<ProcessResult> PullCertificateToFileAsync(string ipAddress, string outputPath, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[] { "plc-cert", "--target", ipAddress, "--output", outputPath },
        }, ct);

    /// <summary>apax sld load --mode FULL --target IP --input PLATFORM --username U --password P --certificate CERT --restart --accept-security-disclaimer</summary>
    public Task<ProcessResult> SldLoadFullAsync(string ipAddress, string platform, string username, string password, string certificatePath, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "sld", "load",
                "--mode", "FULL",
                "--target", ipAddress,
                "--input", platform,
                "--username", username,
                "--password", password,
                "--certificate", certificatePath,
                "--restart",
                "--accept-security-disclaimer",
            },
        }, ct);

    /// <summary>apax sld load ... --accept-reinit-variables --restart --mode delta</summary>
    public Task<ProcessResult> SldLoadDeltaAsync(string ipAddress, string platform, string username, string password, string certificatePath, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "sld", "load",
                "--accept-security-disclaimer",
                "--target", ipAddress,
                "--input", platform,
                "--username", username,
                "--password", password,
                "--certificate", certificatePath,
                "--accept-reinit-variables",
                "--restart",
                "--mode", "delta",
            },
        }, ct);

    /// <summary>apax hwld load --input bin/hwc/X --target IP --username U --password P --certificate CERT --no-input --accept-security-disclaimer --log Information --restart</summary>
    public Task<ProcessResult> HwldDownloadAsync(string plcName, string ipAddress, string username, string password, string certificatePath, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "hwld", "load",
                "--input", $"bin/hwc/{plcName}",
                "--target", ipAddress,
                "--username", username,
                "--password", password,
                "--certificate", certificatePath,
                "--no-input",
                "--accept-security-disclaimer",
                "--log", "Information",
                "--restart",
            },
        }, ct);

    /// <summary>apax dcp-utility discover --source-mac MAC --timeout 30000 (stdout captured for export).</summary>
    public Task<ProcessResult> DcpDiscoverAsync(string sourceMac, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[] { "dcp-utility", "discover", "--source-mac", sourceMac, "--timeout", "30000" },
            EchoToConsole = false,
        }, ct);

    /// <summary>apax dcp-utility list-interfaces -f JSON (stdout captured for export).</summary>
    public Task<ProcessResult> DcpListInterfacesAsync(CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[] { "dcp-utility", "list-interfaces", "-f", "JSON" },
            EchoToConsole = false,
        }, ct);

    /// <summary>apax sld compare --mode all --target IP --input PLATFORM --username U --password P --certificate CERT --log Information</summary>
    public Task<ProcessResult> SldCompareAllAsync(string ipAddress, string platform, string username, string password, string certificatePath, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = new[]
            {
                "sld", "compare",
                "--mode", "all",
                "--target", ipAddress,
                "--input", platform,
                "--username", username,
                "--password", password,
                "--certificate", certificatePath,
                "--log", "Information",
            },
        }, ct);

    /// <summary>apax build</summary>
    public Task<ProcessResult> BuildAsync(CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest { Executable = Executable, Arguments = new[] { "build" } }, ct);

    /// <summary>apax clean</summary>
    public Task<ProcessResult> CleanAsync(CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest { Executable = Executable, Arguments = new[] { "clean" } }, ct);

    /// <summary>apax install [--catalog]</summary>
    public Task<ProcessResult> InstallAsync(bool catalog = false, CancellationToken ct = default)
        => runner.RunAsync(new ProcessRequest
        {
            Executable = Executable,
            Arguments = catalog ? new[] { "install", "--catalog" } : new[] { "install" },
        }, ct);
}
