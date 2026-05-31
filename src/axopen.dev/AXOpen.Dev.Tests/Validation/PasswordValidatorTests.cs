using AXOpen.Dev.Validation;

namespace AXOpen.Dev.Tests.Validation;

public class PasswordValidatorTests
{
    [Theory]
    [InlineData("Qwerty123456+")] // the showcase password — '+' is allowed
    [InlineData("Abc123-_=.~")]
    [InlineData("PlainPassword1")]
    // $ & ( ) * are endorsed by the configure-secrets complexity set, so they are allowed.
    [InlineData("dollar$ign")]
    [InlineData("amper&sand")]
    [InlineData("paren(s)here")]
    [InlineData("star*power")]
    public void Safe_passwords_pass(string pwd) => Assert.True(PasswordValidator.IsSafe(pwd));

    [Theory]
    [InlineData("has space")]
    [InlineData("back`tick")]
    [InlineData("pipe|d")]
    [InlineData("semi;colon")]
    [InlineData("quote\"d")]
    [InlineData("brace{}")]
    [InlineData("angle<gt>")]
    [InlineData("quest?ion")]
    [InlineData("")]
    [InlineData(null)]
    public void Unsafe_passwords_fail(string? pwd) => Assert.False(PasswordValidator.IsSafe(pwd));
}
