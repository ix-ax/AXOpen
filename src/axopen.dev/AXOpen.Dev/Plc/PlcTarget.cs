namespace AXOpen.Dev.Plc;

/// <summary>A PLC connection target. Certificate path mirrors the bash convention.</summary>
public sealed record PlcTarget(string IpAddress, string Name, string Username, string Password)
{
    /// <summary><c>./certs/&lt;name&gt;/&lt;name&gt;.cer</c> — the per-PLC certificate location used by the scripts.</summary>
    public string CertificatePath => Path.Combine("./certs", Name, $"{Name}.cer");
}
