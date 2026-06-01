using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Tests.Validation;

public class MacValidatorTests
{
    [Theory]
    [InlineData("00:1B:44:11:3A:B7")]
    [InlineData("00-1b-44-11-3a-b7")]
    [InlineData("aa:bb:cc:dd:ee:ff")]
    public void Valid_macs(string mac) => Assert.True(MacValidator.IsValid(mac));

    [Theory]
    [InlineData("00:1B:44:11:3A")]      // too short
    [InlineData("00:1B:44:11:3A:B7:C9")] // too long
    [InlineData("ZZ:1B:44:11:3A:B7")]    // non-hex
    [InlineData("001B.4411.3AB7")]       // wrong separators
    [InlineData("")]
    [InlineData(null)]
    public void Invalid_macs(string? mac) => Assert.False(MacValidator.IsValid(mac));
}
