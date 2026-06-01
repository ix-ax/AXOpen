using System.Text.RegularExpressions;

namespace AXOpen.Dev.Validation;

/// <summary>MAC address validation. Port of the regex in <c>dcp_utility_discover.sh</c>.</summary>
public static partial class MacValidator
{
    [GeneratedRegex(@"^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")]
    private static partial Regex Pattern();

    public static bool IsValid(string? mac) => !string.IsNullOrEmpty(mac) && Pattern().IsMatch(mac);
}
