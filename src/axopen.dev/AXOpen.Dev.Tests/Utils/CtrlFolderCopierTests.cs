using AXOpen.Dev.Utils;

namespace AXOpen.Dev.Tests.Utils;

public sealed class CtrlFolderCopierTests : IDisposable
{
    private readonly string _root = Path.Combine(Path.GetTempPath(), $"axdev-ctrl-{Guid.NewGuid():N}");

    public CtrlFolderCopierTests()
    {
        // src/LibA/ctrl/a.st
        // src/LibA/ctrl/sub/b.st
        // src/LibB/inner/ctrl/c.st       (preserve LibB/inner relative path)
        // src/LibC/Ctrl/d.st             (case-insensitive match)
        // src/LibD/notctrl/e.st          (ignored)
        Make("src/LibA/ctrl/a.st");
        Make("src/LibA/ctrl/sub/b.st");
        Make("src/LibB/inner/ctrl/c.st");
        Make("src/LibC/Ctrl/d.st");
        Make("src/LibD/notctrl/e.st");
    }

    private string SourceRoot => Path.Combine(_root, "src");

    private void Make(string relative)
    {
        var full = Path.Combine(_root, relative.Replace('/', Path.DirectorySeparatorChar));
        Directory.CreateDirectory(Path.GetDirectoryName(full)!);
        File.WriteAllText(full, "x");
    }

    [Fact]
    public void Plan_finds_ctrl_directories_case_insensitively_preserving_structure()
    {
        var dest = Path.Combine(_root, "out");
        var ops = CtrlFolderCopier.Plan(SourceRoot, dest);

        Assert.Equal(3, ops.Count);
        Assert.All(ops, op => Assert.Equal("ctrl", Path.GetFileName(op.Source), ignoreCase: true));
        Assert.Contains(ops, op => op.Destination == Path.Combine(dest, "LibA", "ctrl"));
        Assert.Contains(ops, op => op.Destination == Path.Combine(dest, "LibB", "inner", "ctrl"));
        Assert.Contains(ops, op => op.Destination == Path.Combine(dest, "LibC", "Ctrl"));
    }

    [Fact]
    public void Plan_returns_empty_when_source_missing()
        => Assert.Empty(CtrlFolderCopier.Plan(Path.Combine(_root, "nope"), Path.Combine(_root, "out")));

    [Fact]
    public void Copy_replicates_files_preserving_nested_structure()
    {
        var dest = Path.Combine(_root, "out");
        var count = CtrlFolderCopier.Copy(SourceRoot, dest);

        Assert.Equal(3, count);
        Assert.True(File.Exists(Path.Combine(dest, "LibA", "ctrl", "a.st")));
        Assert.True(File.Exists(Path.Combine(dest, "LibA", "ctrl", "sub", "b.st")));
        Assert.True(File.Exists(Path.Combine(dest, "LibB", "inner", "ctrl", "c.st")));
        Assert.True(File.Exists(Path.Combine(dest, "LibC", "Ctrl", "d.st")));
        Assert.False(Directory.Exists(Path.Combine(dest, "LibD")));
    }

    public void Dispose()
    {
        if (Directory.Exists(_root))
        {
            Directory.Delete(_root, recursive: true);
        }
    }
}
