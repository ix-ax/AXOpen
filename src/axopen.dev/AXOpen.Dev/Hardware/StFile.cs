using System.Text;

namespace AXOpen.Dev.Hardware;

/// <summary>Writes generated ST files with LF endings and no BOM (mirrors the bash dos2unix result).</summary>
public static class StFile
{
    private static readonly UTF8Encoding Utf8NoBom = new(encoderShouldEmitUTF8Identifier: false);

    /// <param name="trailingNewline">
    /// When true, append a final newline to match PowerShell <c>Set-Content</c> (used for the
    /// IoAddresses outputs so regenerated files are byte-identical to the shipped ones).
    /// </param>
    public static void Write(string path, string content, bool trailingNewline = false)
    {
        var directory = Path.GetDirectoryName(path);
        if (!string.IsNullOrEmpty(directory))
        {
            Directory.CreateDirectory(directory);
        }

        File.WriteAllText(path, trailingNewline ? content + "\n" : content, Utf8NoBom);
    }
}
