namespace AXOpen.Dev.Utils;

/// <summary>A planned directory copy (source absolute path → destination absolute path).</summary>
public sealed record DirectoryCopyOperation(string Source, string Destination);

/// <summary>
/// Recursively finds directories named <c>ctrl</c> (case-insensitive) under a source root and copies
/// each into a destination root, preserving the relative folder hierarchy. Pure port of
/// <c>scripts/copy-ctrl-folders.ps1</c>. The plan is sorted by source path for deterministic behavior.
/// </summary>
public static class CtrlFolderCopier
{
    public const string CtrlDirectoryName = "ctrl";

    public static IReadOnlyList<DirectoryCopyOperation> Plan(string sourceRoot, string destinationRoot)
    {
        if (!Directory.Exists(sourceRoot))
        {
            return Array.Empty<DirectoryCopyOperation>();
        }

        return Directory
            .EnumerateDirectories(sourceRoot, "*", SearchOption.AllDirectories)
            .Where(d => string.Equals(Path.GetFileName(d), CtrlDirectoryName, StringComparison.OrdinalIgnoreCase))
            .OrderBy(d => d, StringComparer.Ordinal)
            .Select(d => new DirectoryCopyOperation(d, Path.Combine(destinationRoot, Path.GetRelativePath(sourceRoot, d))))
            .ToList();
    }

    /// <summary>Plans then executes the copies. Returns the number of ctrl directories copied.</summary>
    public static int Copy(string sourceRoot, string destinationRoot)
    {
        var operations = Plan(sourceRoot, destinationRoot);
        foreach (var op in operations)
        {
            CopyDirectory(op.Source, op.Destination);
        }

        return operations.Count;
    }

    private static void CopyDirectory(string source, string destination)
    {
        Directory.CreateDirectory(destination);
        foreach (var file in Directory.EnumerateFiles(source, "*", SearchOption.AllDirectories))
        {
            var target = Path.Combine(destination, Path.GetRelativePath(source, file));
            Directory.CreateDirectory(Path.GetDirectoryName(target)!);
            File.Copy(file, target, overwrite: true);
        }
    }
}
