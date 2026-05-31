using System.Security.Cryptography.X509Certificates;

namespace AXOpen.Dev.Certs;

/// <summary>
/// Certificate SHA1 thumbprint computation and comparison. Replaces the
/// <c>certutil -dump | grep "Cert Hash(sha1)"</c> pipeline in <c>is_cert_hash_sha1_equal.sh</c>
/// with cross-platform .NET X509 APIs.
/// </summary>
public static class CertService
{
    /// <summary>SHA1 thumbprint of a certificate file, as uppercase hex without separators.</summary>
    public static string ComputeSha1Thumbprint(string certificatePath)
    {
        if (!File.Exists(certificatePath))
        {
            throw new FileNotFoundException("Certificate file does not exist.", certificatePath);
        }

        using var cert = X509CertificateLoader.LoadCertificateFromFile(certificatePath);
        return cert.Thumbprint; // .NET computes the SHA1 thumbprint, uppercase hex, no separators
    }

    /// <summary>
    /// Compares two SHA1 hashes ignoring case and any whitespace/colon separators
    /// (certutil prints space-separated bytes; .NET prints contiguous hex).
    /// </summary>
    public static bool AreEqual(string? a, string? b)
    {
        var na = Normalize(a);
        var nb = Normalize(b);
        return na.Length > 0 && string.Equals(na, nb, StringComparison.Ordinal);
    }

    private static string Normalize(string? hash)
    {
        if (string.IsNullOrWhiteSpace(hash))
        {
            return string.Empty;
        }

        Span<char> buffer = hash.Length <= 256 ? stackalloc char[hash.Length] : new char[hash.Length];
        var count = 0;
        foreach (var c in hash)
        {
            if (c is ' ' or ':' or '\t' or '\r' or '\n' or '-')
            {
                continue;
            }

            buffer[count++] = char.ToUpperInvariant(c);
        }

        return new string(buffer[..count]);
    }
}
