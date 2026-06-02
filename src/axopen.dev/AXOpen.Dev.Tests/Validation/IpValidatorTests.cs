using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Tests.Validation;

public class IpValidatorTests
{
    [Theory]
    [InlineData("0.0.0.0")]
    [InlineData("192.168.1.1")]
    [InlineData("10.10.10.120")]
    [InlineData("255.255.255.255")]
    [InlineData("1.2.3.4")]
    public void Valid_ipv4_addresses_pass(string ip)
        => Assert.True(IpValidator.IsValidIp(ip));

    [Theory]
    [InlineData("256.0.0.1")]      // octet > 255
    [InlineData("192.168.1")]      // only 3 octets
    [InlineData("192.168.1.1.1")]  // 5 octets
    [InlineData("192.168.1.1234")] // 4-digit group
    [InlineData("abc.def.ghi.jkl")]
    [InlineData("192.168.1.")]
    [InlineData("")]
    [InlineData("192.168.1.1/24")] // CIDR is not a bare IP
    public void Invalid_ipv4_addresses_fail(string ip)
        => Assert.False(IpValidator.IsValidIp(ip));

    [Theory]
    [InlineData("192.168.1.0/24")]
    [InlineData("10.0.0.0/8")]
    [InlineData("1.2.3.4/0")]
    [InlineData("1.2.3.4/32")]
    [InlineData("172.16.0.0/29")]
    public void Valid_cidr_pass(string cidr)
        => Assert.True(IpValidator.IsValidCidr(cidr));

    [Theory]
    [InlineData("192.168.1.0/33")] // prefix > 32
    [InlineData("192.168.1.0")]    // no prefix
    [InlineData("256.1.1.1/24")]   // bad octet
    [InlineData("192.168.1.0/")]
    [InlineData("192.168.1.0/-1")]
    public void Invalid_cidr_fail(string cidr)
        => Assert.False(IpValidator.IsValidCidr(cidr));
}
