using System.Security.Claims;

namespace AxOpen.Security.Tests
{
    public class BlazorAuthenticationTests : IClassFixture<BlazorSecurityTestsFixture>
    {
        private readonly BlazorSecurityTestsFixture _fixture;
        public BlazorAuthenticationTests(BlazorSecurityTestsFixture fixture)
        {
            _fixture = fixture;
            System.Threading.Thread.CurrentPrincipal = new AppIdentity.AppPrincipal();
        }

        [Fact]
        public void Authenticate_AdminUser_Success()
        {
            //arange
            var name = _fixture.SeedData.AdminUser.UserName;
            var password = "admin";
            //act
            
            var user = _fixture.Basp.AuthenticateUser(name, password);
            //assert
            Assert.NotNull(user);
            Assert.Equal(name,user.UserName);
            Assert.Equal(true, Thread.CurrentPrincipal?.Identity?.IsAuthenticated);
        }

        [Fact]
        public void DeAuthenticate_AdminUser_Success()
        {
            //arange
            var name = _fixture.SeedData.AdminUser.UserName;
            var password = "admin";
            _fixture.Basp.AuthenticateUser(name, password);

            //act
            _fixture.Basp.DeAuthenticateCurrentUser();

            //assert

            Assert.Equal(false, Thread.CurrentPrincipal?.Identity?.IsAuthenticated);
        }

        [Fact]
        public void GetAuthenticationState_AdminUser_Success()
        {
            //arange
            var name = _fixture.SeedData.AdminUser.UserName;
            var password = "admin";
            _fixture.Basp.AuthenticateUser(name, password);

            //act
            var authState = _fixture.Basp.GetAuthenticationStateAsync().Result;

            //assert
            var nameClaim = authState.User.Claims.Where(p => p.Type == ClaimTypes.Name).FirstOrDefault();
            var roleClaim = authState.User.Claims.Where(p => p.Type == ClaimTypes.Role).FirstOrDefault(); ;


            Assert.NotNull(authState.User);
            Assert.NotNull(nameClaim);
            Assert.NotNull(roleClaim);
            Assert.Equal("admin",nameClaim.Value);
            Assert.Equal("Administrator", roleClaim.Value);
        }
    }
}