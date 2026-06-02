using AXOpen.Dev.Requisites;

namespace AXOpen.Dev.Tests.Requisites;

public class RequisiteCheckerTests
{
    private const string Url = "https://npm.pkg.github.com/";

    [Fact]
    public void AuthJson_with_registry_and_token_is_detected()
    {
        var json = $$"""
        { "{{Url}}": { "registryToken": "ghp_abc123", "userName": "someone" } }
        """;
        Assert.True(RequisiteChecker.AuthJsonHasRegistry(json, Url));
    }

    [Theory]
    [InlineData("{ \"https://other/\": { \"registryToken\": \"x\" } }")] // different registry
    [InlineData("{ \"https://npm.pkg.github.com/\": { \"registryToken\": \"\" } }")] // empty token
    [InlineData("{ \"https://npm.pkg.github.com/\": { \"userName\": \"x\" } }")] // no token
    [InlineData("not json")]
    [InlineData("{}")]
    public void AuthJson_without_valid_registry_is_rejected(string json)
        => Assert.False(RequisiteChecker.AuthJsonHasRegistry(json, Url));
}
