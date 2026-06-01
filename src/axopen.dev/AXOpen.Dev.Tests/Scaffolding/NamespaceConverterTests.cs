using AXOpen.Dev.Scaffolding;

namespace AXOpen.Dev.Tests.Scaffolding;

public class NamespaceConverterTests
{
    [Theory]
    [InlineData("org.inxton.mylib.components", "Org.Inxton.Mylib.Components")]
    [InlineData("@inxton/axopen.components.foo", "AXOpen.Components.Foo")]
    [InlineData("x/AxOpen", "AXOpen")]
    [InlineData("axopen", "AXOpen")]
    [InlineData("vendor/myLib.Thing", "MyLib.Thing")] // first letter capitalized, rest preserved
    public void Converts_to_component_namespace(string input, string expected)
        => Assert.Equal(expected, NamespaceConverter.ToComponentNamespace(input));

    [Theory]
    [InlineData("Foo")]
    [InlineData("Foo1_bar")]
    [InlineData("F")]
    public void Valid_component_names(string name) => Assert.True(ComponentName.IsValid(name));

    [Theory]
    [InlineData("foo")]   // must start upper
    [InlineData("1Foo")]
    [InlineData("Foo Bar")]
    [InlineData("Foo-Bar")]
    [InlineData("")]
    [InlineData(null)]
    public void Invalid_component_names(string? name) => Assert.False(ComponentName.IsValid(name));
}
