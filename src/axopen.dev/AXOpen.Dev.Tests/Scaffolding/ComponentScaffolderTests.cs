using AXOpen.Dev.Scaffolding;

namespace AXOpen.Dev.Tests.Scaffolding;

public sealed class ComponentScaffolderTests : IDisposable
{
    private readonly string _root = Path.Combine(Path.GetTempPath(), $"axdev-scaffold-{Guid.NewGuid():N}");
    private readonly string _template;

    public ComponentScaffolderTests()
    {
        _template = Path.Combine(_root, "template", "TemplateComponent");
        Write("TemplateComponent.st", "NAMESPACE Template.Axolibrary\nCLASS TemplateComponent\nEND_CLASS\n");
        Write(Path.Combine("sub", "TemplateComponentThing.cs"),
            "namespace Template.Axolibrary;\npublic class TemplateComponentThing {}\n");
        Write("static.txt", "no markers here");
    }

    private void Write(string relative, string content)
    {
        var full = Path.Combine(_template, relative);
        Directory.CreateDirectory(Path.GetDirectoryName(full)!);
        File.WriteAllText(full, content);
    }

    [Fact]
    public void Scaffold_renames_tree_and_replaces_tokens()
    {
        var dest = Path.Combine(_root, "out");
        var final = ComponentScaffolder.Scaffold(_template, dest, "MyComp", "AXOpen.MyLib");

        Assert.Equal(Path.Combine(dest, "MyComp"), final);
        Assert.True(File.Exists(Path.Combine(final, "MyComp.st")));
        Assert.True(File.Exists(Path.Combine(final, "sub", "MyCompThing.cs")));
        Assert.False(Directory.Exists(Path.Combine(dest, "TemplateComponent")));

        var st = File.ReadAllText(Path.Combine(final, "MyComp.st"));
        Assert.Contains("NAMESPACE AXOpen.MyLib", st);
        Assert.Contains("CLASS MyComp", st);
        Assert.DoesNotContain("TemplateComponent", st);

        var cs = File.ReadAllText(Path.Combine(final, "sub", "MyCompThing.cs"));
        Assert.Contains("namespace AXOpen.MyLib;", cs);
        Assert.Contains("class MyCompThing", cs);

        Assert.Equal("no markers here", File.ReadAllText(Path.Combine(final, "static.txt")));
    }

    [Fact]
    public void Scaffold_throws_when_source_missing()
        => Assert.Throws<DirectoryNotFoundException>(
            () => ComponentScaffolder.Scaffold(Path.Combine(_root, "nope"), Path.Combine(_root, "out"), "MyComp", "AXOpen.MyLib"));

    [Fact]
    public void Scaffold_throws_when_destination_exists()
    {
        var dest = Path.Combine(_root, "out");
        Directory.CreateDirectory(Path.Combine(dest, "MyComp"));
        Assert.Throws<IOException>(
            () => ComponentScaffolder.Scaffold(_template, dest, "MyComp", "AXOpen.MyLib"));
    }

    public void Dispose()
    {
        if (Directory.Exists(_root))
        {
            Directory.Delete(_root, recursive: true);
        }
    }
}
