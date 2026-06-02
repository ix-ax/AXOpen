using System.Text;
using System.Text.RegularExpressions;

namespace AXOpen.Dev.Hardware;

/// <summary>Thrown when the IoAddresses input has no usable VAR_GLOBAL block.</summary>
public sealed class IoAddressesFormatException(string message) : Exception(message);

/// <summary>
/// Generates <c>Inputs.st</c>, <c>Outputs.st</c> and <c>IoStructures.st</c> from a compiled
/// <c>&lt;PLC&gt;_IoAddresses.st</c> file. Pure C# port of <c>copy_io_addresses_hwc_3_4_0.ps1</c>
/// (the hwc &gt;= 3.4.0 path; the legacy &lt; 3.4.0 awk path is intentionally dropped).
/// Output uses LF endings (the bash applied <c>dos2unix</c> afterwards).
/// Matches the source's case-insensitive regex semantics.
/// </summary>
public static class IoAddressesGenerator
{
    private const RegexOptions Opts = RegexOptions.IgnoreCase | RegexOptions.CultureInvariant;

    public static (string Inputs, string Outputs, string Structures) Generate(string @namespace, string inputContent)
    {
        var all = SplitLines(inputContent);

        // Locate the first VAR_GLOBAL ... END_VAR region.
        int? startVar = null;
        int? endVar = null;
        for (var i = 0; i < all.Length; i++)
        {
            if (startVar is null && Regex.IsMatch(all[i], @"^\s*VAR_GLOBAL\b", Opts))
            {
                startVar = i;
                continue;
            }

            if (startVar is not null && Regex.IsMatch(all[i], @"^\s*END_VAR\b", Opts))
            {
                endVar = i;
                break;
            }
        }

        if (startVar is null || endVar is null || endVar <= startVar)
        {
            throw new IoAddressesFormatException(
                "Could not locate a proper VAR_GLOBAL ... END_VAR block in the input.");
        }

        var varLines = all[(startVar.Value + 1)..endVar.Value];

        var sbIn = new StringBuilder()
            .Append("NAMESPACE ").Append(@namespace).Append('\n')
            .Append("    TYPE\n")
            .Append("        {S7.extern=ReadWrite}\n")
            .Append("        {#ix-attr:[Container(Layout.Wrap)]}\n")
            .Append("        Inputs : STRUCT\n");
        var sbOut = new StringBuilder()
            .Append("NAMESPACE ").Append(@namespace).Append('\n')
            .Append("    TYPE\n")
            .Append("        {S7.extern=ReadWrite}\n")
            .Append("        {#ix-attr:[Container(Layout.Wrap)]}\n")
            .Append("        Outputs : STRUCT\n");
        var sbStruct = new StringBuilder()
            .Append("NAMESPACE ").Append(@namespace).Append('\n');

        var containsInputs = false;
        var containsOutputs = false;

        var idx = 0;
        while (idx < varLines.Length)
        {
            var line = varLines[idx];
            if (Regex.IsMatch(line, @"^\s*$") || Regex.IsMatch(line, @"^\s*//"))
            {
                idx++;
                continue;
            }

            var decl = new StringBuilder();

            // Attach the immediately preceding line if it is a comment.
            var prevIdx = idx - 1;
            if (prevIdx >= 0)
            {
                var prev = "\t" + varLines[prevIdx];
                if (Regex.IsMatch(prev, @"^\s*//"))
                {
                    decl.Append(prev).Append('\n');
                }
            }

            // Accumulate until a line containing a semicolon.
            while (idx < varLines.Length)
            {
                var l = "\t" + varLines[idx];
                decl.Append(l).Append('\n');
                if (l.Contains(';'))
                {
                    idx++;
                    break;
                }

                idx++;
            }

            var declText = decl.ToString();
            // The PowerShell source does `$sb.AppendLine($normalized)` where $normalized already
            // ends with a newline, so each declaration block is followed by a blank line. Match
            // that exactly (verified against the showcase's shipped Inputs.st/Outputs.st).
            if (Regex.IsMatch(declText, @"AT\s*%I", Opts))
            {
                sbIn.Append(Regex.Replace(declText, @"AT\s*%I", "AT %", Opts)).Append('\n');
                containsInputs = true;
            }
            else if (Regex.IsMatch(declText, @"AT\s*%Q", Opts))
            {
                sbOut.Append(Regex.Replace(declText, @"AT\s*%Q", "AT %", Opts)).Append('\n');
                containsOutputs = true;
            }
        }

        if (!containsInputs)
        {
            sbIn.Append("            noInputsFoundInTheHwConfig AT %B0:  BYTE;\n");
        }

        if (!containsOutputs)
        {
            sbOut.Append("            noOutputsFoundInTheHwConfig AT %B0:  BYTE;\n");
        }

        // Re-emit the first TYPE section into the structures file, injecting the ix attributes
        // immediately after each TYPE line.
        int? startType = null;
        for (var i = endVar.Value; i < all.Length; i++)
        {
            if (Regex.IsMatch(all[i], @"^\s*TYPE\b", Opts))
            {
                startType = i;
                break;
            }
        }

        if (startType is not null)
        {
            for (var i = startType.Value; i < all.Length; i++)
            {
                sbStruct.Append('\t').Append(all[i]).Append('\n');
                if (Regex.IsMatch(all[i], @"^\s*TYPE\b", Opts))
                {
                    sbStruct.Append("        {S7.extern=ReadWrite}\n");
                    sbStruct.Append("        {#ix-attr:[Container(Layout.Wrap)]}\n");
                }
            }
        }

        sbIn.Append("        END_STRUCT;\n    END_TYPE\nEND_NAMESPACE\n");
        sbOut.Append("        END_STRUCT;\n    END_TYPE\nEND_NAMESPACE\n");
        sbStruct.Append("END_NAMESPACE\n");

        return (sbIn.ToString(), sbOut.ToString(), sbStruct.ToString());
    }

    private static string[] SplitLines(string content)
    {
        var lines = content.Split('\n');
        for (var i = 0; i < lines.Length; i++)
        {
            lines[i] = lines[i].TrimEnd('\r');
        }

        // Get-Content drops a trailing empty line produced by a final newline.
        if (lines.Length > 0 && lines[^1].Length == 0)
        {
            return lines[..^1];
        }

        return lines;
    }
}
