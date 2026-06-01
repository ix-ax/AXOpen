using AXOpen.Dev.Assets;

namespace AXOpen.Dev.Tests.Assets;

public sealed class AssetDiscoveryTests : IDisposable
{
    private readonly string _root = Path.Combine(Path.GetTempPath(), $"axdev-assets-{Guid.NewGuid():N}");

    public AssetDiscoveryTests()
    {
        // .apax/pkgA/assets/GSDML-foo.xml
        // .apax/pkgA/assets/sub/GSDML-bar.XML        (case-insensitive match)
        // .apax/pkgA/assets/templates/a.hwl.json
        // .apax/pkgA/assets/b.hwl.yml
        // .apax/pkgA/assets/ignore.txt               (ignored by both)
        // .apax/pkgB/nested/assets/GSDML-foo.xml      (flat-collision with pkgA)
        Make("pkgA/assets/GSDML-foo.xml");
        Make("pkgA/assets/sub/GSDML-bar.XML");
        Make("pkgA/assets/templates/a.hwl.json");
        Make("pkgA/assets/b.hwl.yml");
        Make("pkgA/assets/ignore.txt");
        Make("pkgB/nested/assets/GSDML-foo.xml");
    }

    private string ApaxDir => Path.Combine(_root, ".apax");

    private void Make(string relativeUnderApax)
    {
        var full = Path.Combine(ApaxDir, relativeUnderApax.Replace('/', Path.DirectorySeparatorChar));
        Directory.CreateDirectory(Path.GetDirectoryName(full)!);
        File.WriteAllText(full, "x");
    }

    [Fact]
    public void Finds_all_assets_directories()
    {
        var dirs = AssetDiscovery.FindAssetsDirectories(ApaxDir);
        Assert.Equal(2, dirs.Count);
        Assert.All(dirs, d => Assert.Equal("assets", Path.GetFileName(d)));
    }

    [Fact]
    public void Gsd_plan_is_flat_and_matches_gsdml_xml_case_insensitively()
    {
        var dest = Path.Combine(_root, "gsd", "source");
        var ops = AssetDiscovery.PlanGsdCopies(ApaxDir, dest);

        // GSDML-foo.xml (pkgA), GSDML-bar.XML (pkgA/sub), GSDML-foo.xml (pkgB) => 3 sources
        Assert.Equal(3, ops.Count);
        Assert.All(ops, op => Assert.Equal(dest, Path.GetDirectoryName(op.Destination)));
        Assert.DoesNotContain(ops, op => op.Source.EndsWith("ignore.txt", StringComparison.Ordinal));
        Assert.Contains(ops, op => Path.GetFileName(op.Destination) == "GSDML-bar.XML");
    }

    [Fact]
    public void Gsd_flat_collisions_are_detected_by_destination_basename()
    {
        var dest = Path.Combine(_root, "gsd", "source");
        var ops = AssetDiscovery.PlanGsdCopies(ApaxDir, dest);
        var collisions = AssetDiscovery.FlatCollisions(ops);

        Assert.Contains("GSDML-foo.xml", collisions);
        Assert.DoesNotContain("GSDML-bar.XML", collisions);
    }

    [Fact]
    public void Hwl_plan_preserves_relative_subfolders()
    {
        var dest = Path.Combine(_root, "hwc", "library_templates");
        var ops = AssetDiscovery.PlanHwlCopies(ApaxDir, dest);

        Assert.Equal(2, ops.Count);
        Assert.Contains(ops, op => op.Destination == Path.Combine(dest, "templates", "a.hwl.json"));
        Assert.Contains(ops, op => op.Destination == Path.Combine(dest, "b.hwl.yml"));
    }

    [Fact]
    public void Missing_apax_dir_yields_empty_plans()
    {
        var missing = Path.Combine(_root, "does-not-exist");
        Assert.Empty(AssetDiscovery.FindAssetsDirectories(missing));
        Assert.Empty(AssetDiscovery.PlanGsdCopies(missing, "dest"));
        Assert.Empty(AssetDiscovery.PlanHwlCopies(missing, "dest"));
    }

    public void Dispose()
    {
        if (Directory.Exists(_root))
        {
            Directory.Delete(_root, recursive: true);
        }
    }
}
