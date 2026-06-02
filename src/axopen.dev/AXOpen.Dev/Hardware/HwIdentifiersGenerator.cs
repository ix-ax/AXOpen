using System.Text;
using System.Text.RegularExpressions;

namespace AXOpen.Dev.Hardware;

/// <summary>
/// Generates <c>HwIdentifiers.st</c> (ENUM-style TYPE) and <c>HwIdentifierList.st</c>
/// (ARRAY of UINT) from a compiled <c>&lt;PLC&gt;_HwIdentifiers.st</c> constants file.
/// Pure port of the awk program in <c>copy_hardware_ids.sh</c>: entries are read from the
/// <c>VAR_GLOBAL CONSTANT</c> block and sorted by value ascending; output uses LF endings.
/// </summary>
public static partial class HwIdentifiersGenerator
{
    [GeneratedRegex(@"^\s*([A-Za-z0-9_]+)\s*:\s*UINT\s*:=\s*UINT#([0-9]+)\s*;")]
    private static partial Regex ConstantLine();

    public static (string Identifiers, string IdentifierList) Generate(string @namespace, string inputContent)
    {
        var items = Parse(inputContent);

        // asorti(..., "@val_num_asc"): order keys by associated numeric value ascending.
        // Ties (not expected for HW ids) fall back to ordinal name order for determinism.
        var sorted = items
            .OrderBy(kvp => kvp.Value)
            .ThenBy(kvp => kvp.Key, StringComparer.Ordinal)
            .ToList();
        var n = sorted.Count;

        var identifiers = new StringBuilder();
        identifiers.Append("NAMESPACE ").Append(@namespace).Append('\n');
        identifiers.Append("    TYPE\n");
        identifiers.Append("        HwIdentifiers : UINT\n");
        identifiers.Append("        (\n");
        if (n == 0)
        {
            identifiers.Append("            NONE := UINT#0\n");
        }
        else
        {
            for (var i = 0; i < n; i++)
            {
                var comma = i == n - 1 ? "" : ",";
                identifiers.Append("            ").Append(sorted[i].Key)
                    .Append(" := UINT#").Append(sorted[i].Value).Append(comma).Append('\n');
            }
        }

        identifiers.Append("        );\n");
        identifiers.Append("    END_TYPE\n");
        identifiers.Append("END_NAMESPACE\n");
        identifiers.Append('\n'); // awk print appends ORS after the assembled string

        var list = new StringBuilder();
        list.Append("NAMESPACE ").Append(@namespace).Append('\n');
        list.Append("    TYPE HwIdentifierList : ARRAY[0..").Append(n - 1).Append("] OF UINT :=\n");
        list.Append("            [\n");
        for (var i = 0; i < n; i++)
        {
            var comma = i == n - 1 ? "" : ",";
            list.Append("                UINT#").Append(sorted[i].Value).Append(comma).Append('\n');
        }

        list.Append("    ];\n");
        list.Append("END_TYPE\n");
        list.Append("END_NAMESPACE\n");
        list.Append('\n');

        return (identifiers.ToString(), list.ToString());
    }

    private static Dictionary<string, ulong> Parse(string content)
    {
        var items = new Dictionary<string, ulong>(StringComparer.Ordinal);
        var inBlock = false;

        foreach (var raw in content.Split('\n'))
        {
            var line = raw.Replace("\r", string.Empty);

            if (line.Contains("VAR_GLOBAL CONSTANT", StringComparison.Ordinal))
            {
                inBlock = true;
                continue;
            }

            if (line.Contains("END_VAR", StringComparison.Ordinal))
            {
                inBlock = false;
                continue;
            }

            if (!inBlock)
            {
                continue;
            }

            var match = ConstantLine().Match(line);
            if (match.Success)
            {
                items[match.Groups[1].Value] = ulong.Parse(match.Groups[2].Value);
            }
        }

        return items;
    }
}
