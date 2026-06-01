using System.Text;
using System.Text.RegularExpressions;

namespace AXOpen.Dev.Scaffolding;

/// <summary>
/// Converts an apax-style namespace into the PascalCase component namespace.
/// Port of the bash logic in <c>create_complex_component.sh</c>: drop everything up to and
/// including the first '/', split on '.', capitalize each segment's first letter (preserving
/// the rest), with a special case mapping any-case "axopen" to "AXOpen".
/// </summary>
public static class NamespaceConverter
{
    public static string ToComponentNamespace(string @namespace)
    {
        var afterSlash = @namespace.Contains('/')
            ? @namespace[(@namespace.IndexOf('/') + 1)..]
            : @namespace;

        var builder = new StringBuilder();
        foreach (var part in afterSlash.Split('.'))
        {
            if (string.Equals(part, "axopen", StringComparison.OrdinalIgnoreCase))
            {
                builder.Append("AXOpen.");
            }
            else if (part.Length > 0)
            {
                builder.Append(char.ToUpperInvariant(part[0])).Append(part[1..]).Append('.');
            }
            else
            {
                builder.Append('.');
            }
        }

        return builder.ToString().TrimEnd('.');
    }
}

/// <summary>Component name validation: must start upper-case, then letters/digits/underscore.</summary>
public static partial class ComponentName
{
    [GeneratedRegex(@"^[A-Z][a-zA-Z0-9_]*$")]
    private static partial Regex Pattern();

    public static bool IsValid(string? name) => !string.IsNullOrEmpty(name) && Pattern().IsMatch(name);
}
