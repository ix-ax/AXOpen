namespace AXOpen.Dev.Assets;

/// <summary>A planned file copy (source absolute path → destination absolute path).</summary>
public sealed record CopyOperation(string Source, string Destination);

/// <summary>
/// Discovers asset files under <c>.apax/**/assets</c> and plans their copies.
/// Pure port of the discovery in <c>copy_and_install_gsd.sh</c> (GSDML*.xml → flat layout)
/// and <c>copy_hwl_templates.sh</c> (*.hwl.json / *.hwl.yml → preserved subfolders).
/// Results are sorted by source path for deterministic behavior.
/// </summary>
public static class AssetDiscovery
{
    public static IReadOnlyList<string> FindAssetsDirectories(string apaxDirectory)
    {
        if (!Directory.Exists(apaxDirectory))
        {
            return Array.Empty<string>();
        }

        return Directory
            .EnumerateDirectories(apaxDirectory, "assets", SearchOption.AllDirectories)
            .OrderBy(d => d, StringComparer.Ordinal)
            .ToList();
    }

    /// <summary>Flat copy plan for GSDML*.xml (case-insensitive) into a single destination folder.</summary>
    public static IReadOnlyList<CopyOperation> PlanGsdCopies(string apaxDirectory, string destinationDirectory)
        => PlanCopies(
            apaxDirectory,
            name => name.StartsWith("GSDML", StringComparison.OrdinalIgnoreCase)
                    && name.EndsWith(".xml", StringComparison.OrdinalIgnoreCase),
            (_, file) => Path.Combine(destinationDirectory, Path.GetFileName(file)));

    /// <summary>Subfolder-preserving copy plan for *.hwl.json / *.hwl.yml.</summary>
    public static IReadOnlyList<CopyOperation> PlanHwlCopies(string apaxDirectory, string destinationDirectory)
        => PlanCopies(
            apaxDirectory,
            name => name.EndsWith(".hwl.json", StringComparison.OrdinalIgnoreCase)
                    || name.EndsWith(".hwl.yml", StringComparison.OrdinalIgnoreCase),
            (assetsDir, file) => Path.Combine(destinationDirectory, Path.GetRelativePath(assetsDir, file)));

    /// <summary>Destination file names that more than one source maps to (overwrite warnings).</summary>
    public static IReadOnlyCollection<string> FlatCollisions(IReadOnlyList<CopyOperation> operations)
        => operations
            .GroupBy(op => Path.GetFileName(op.Destination), StringComparer.OrdinalIgnoreCase)
            .Where(g => g.Count() > 1)
            .Select(g => g.Key)
            .ToList();

    private static IReadOnlyList<CopyOperation> PlanCopies(
        string apaxDirectory,
        Func<string, bool> nameMatches,
        Func<string, string, string> destinationFor)
    {
        var operations = new List<CopyOperation>();
        foreach (var assetsDir in FindAssetsDirectories(apaxDirectory))
        {
            foreach (var file in Directory.EnumerateFiles(assetsDir, "*", SearchOption.AllDirectories))
            {
                if (nameMatches(Path.GetFileName(file)))
                {
                    operations.Add(new CopyOperation(file, destinationFor(assetsDir, file)));
                }
            }
        }

        return operations.OrderBy(op => op.Source, StringComparer.Ordinal).ToList();
    }
}
