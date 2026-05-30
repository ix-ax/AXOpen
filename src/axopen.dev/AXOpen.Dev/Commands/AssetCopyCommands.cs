using AXOpen.Dev.Apax;
using AXOpen.Dev.Assets;
using AXOpen.Dev.Observability;

namespace AXOpen.Dev.Commands;

/// <summary>
/// Copies GSDML*.xml from <c>.apax/**/assets</c> into a flat <c>./gsd/source</c> folder and
/// installs everything under <c>./gsd</c> via apax. Port of <c>copy_and_install_gsd.sh</c>.
/// </summary>
public sealed class GsdInstallCommand(ApaxClient apax)
{
    private const string ApaxDir = "./.apax";
    private const string Destination = "./gsd/source";
    private const string GsdDir = "./gsd";

    public async Task<int> ExecuteAsync(CancellationToken ct = default)
    {
        if (Directory.Exists(ApaxDir))
        {
            Directory.CreateDirectory(Destination);
            var operations = AssetDiscovery.PlanGsdCopies(ApaxDir, Destination);
            foreach (var collision in AssetDiscovery.FlatCollisions(operations))
            {
                Output.Warning($"Warning: overwriting existing {collision} in {Destination}");
            }

            foreach (var op in operations)
            {
                File.Copy(op.Source, op.Destination, overwrite: true);
            }

            Output.Success($"{operations.Count} file(s) copied to {Destination} (flat layout).");
        }
        else
        {
            Output.Error("Directory ./.apax does not exist!!!");
        }

        Directory.CreateDirectory(Destination);

        var installable = Directory.Exists(GsdDir)
            ? Directory.EnumerateFiles(GsdDir, "*", SearchOption.AllDirectories)
                .Count(f =>
                {
                    var n = Path.GetFileName(f);
                    return n.StartsWith("GSDML", StringComparison.OrdinalIgnoreCase)
                           && n.EndsWith(".xml", StringComparison.OrdinalIgnoreCase);
                })
            : 0;

        if (installable == 0)
        {
            Output.Warning($"No GSDML*.xml files found in '{GsdDir}'.");
            return 0;
        }

        var result = await apax.HwcInstallGsdAsync(GsdDir, ct);
        if (!result.Success)
        {
            Output.Error("The installation of the gsdml files finished with an error!");
            return 1;
        }

        Output.Success($"{installable} file(s) installed.");
        return 0;
    }
}

/// <summary>
/// Copies *.hwl.json / *.hwl.yml from <c>.apax/**/assets</c> into <c>./hwc/library_templates</c>
/// preserving subfolders. Port of <c>copy_hwl_templates.sh</c>.
/// </summary>
public sealed class HwlCopyCommand
{
    private const string ApaxDir = "./.apax";
    private const string Destination = "./hwc/library_templates";

    public int Execute()
    {
        if (!Directory.Exists(ApaxDir))
        {
            Output.Error("Directory ./.apax does not exist!");
            return 0; // mirrors the bash, which prints and exits 0
        }

        Directory.CreateDirectory(Destination);
        var operations = AssetDiscovery.PlanHwlCopies(ApaxDir, Destination);
        foreach (var op in operations)
        {
            var dir = Path.GetDirectoryName(op.Destination);
            if (!string.IsNullOrEmpty(dir))
            {
                Directory.CreateDirectory(dir);
            }

            File.Copy(op.Source, op.Destination, overwrite: true);
        }

        Output.Success($"{operations.Count} file(s) copied to {Destination} (subfolders preserved).");
        return 0;
    }
}
