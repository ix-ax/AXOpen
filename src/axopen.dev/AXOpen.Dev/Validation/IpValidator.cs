using System.Text.RegularExpressions;

namespace AXOpen.Dev.Validation;

/// <summary>
/// IPv4 / CIDR validation. Ports <c>validate_ip.sh</c> and <c>validate_ip_cidr.sh</c>:
/// four dot-separated 1-3 digit octets each in 0..255, with an optional /0..32 prefix for CIDR.
/// </summary>
public static partial class IpValidator
{
    [GeneratedRegex(@"^([0-9]{1,3}\.){3}[0-9]{1,3}$")]
    private static partial Regex IpShape();

    [GeneratedRegex(@"^([0-9]{1,3}\.){3}[0-9]{1,3}\/([0-9]|[12][0-9]|3[0-2])$")]
    private static partial Regex CidrShape();

    public static bool IsValidIp(string? value)
    {
        if (string.IsNullOrEmpty(value) || !IpShape().IsMatch(value))
        {
            return false;
        }

        return OctetsInRange(value);
    }

    public static bool IsValidCidr(string? value)
    {
        if (string.IsNullOrEmpty(value) || !CidrShape().IsMatch(value))
        {
            return false;
        }

        var ip = value[..value.IndexOf('/')];
        return OctetsInRange(ip);
    }

    private static bool OctetsInRange(string ip)
    {
        foreach (var octet in ip.Split('.'))
        {
            if (!int.TryParse(octet, out var n) || n < 0 || n > 255)
            {
                return false;
            }
        }

        return true;
    }
}
