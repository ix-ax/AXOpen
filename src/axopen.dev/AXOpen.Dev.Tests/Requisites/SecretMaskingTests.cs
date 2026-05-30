using AXOpen.Dev.Requisites;

namespace AXOpen.Dev.Tests.Requisites;

public sealed class SecretMaskingTests
{
    [Theory]
    [InlineData("ghp_ABCDEFGH", "ghp_A******H")] // len 12 > 6: first5 + 6 stars + last1
    [InlineData("123456", "******")]            // len 6: all stars
    [InlineData("", "")]
    public void MaskToken(string token, string expected)
        => Assert.Equal(expected, SecretMasking.MaskToken(token));

    [Theory]
    [InlineData("octocat", "o*****t")] // len 7 > 2: first1 + 5 stars + last1
    [InlineData("ab", "**")]           // len 2: all stars
    [InlineData("a", "*")]
    public void MaskUserName(string userName, string expected)
        => Assert.Equal(expected, SecretMasking.MaskUserName(userName));
}
