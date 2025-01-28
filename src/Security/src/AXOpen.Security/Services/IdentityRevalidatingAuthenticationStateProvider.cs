using System.Security.Claims;
using AxOpen.Security.Entities;
using AXOpen;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Server;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace AxOpen.Security.Services
{
    //Server-side AuthenticationStateProvider that revalidates the security stamp for the connected user
    // every 30 seconds an interactive circuit is connected.
    internal sealed class IdentityRevalidatingAuthenticationStateProvider(
            ILoggerFactory loggerFactory,
            IServiceScopeFactory scopeFactory,
            IUserStore<User> userStore,
            IOptions<IdentityOptions> options
        )
        : RevalidatingServerAuthenticationStateProvider(loggerFactory)
    {
        protected override TimeSpan RevalidationInterval => TimeSpan.FromSeconds(30);

        protected override async Task<bool> ValidateAuthenticationStateAsync(
            AuthenticationState authenticationState, CancellationToken cancellationToken)
        {
            // Get the user manager from a new scope to ensure it fetches fresh data
            await using var scope = scopeFactory.CreateAsyncScope();

            var userManager = scope.ServiceProvider.GetRequiredService<UserManager<User>>();

            ClaimsPrincipal userPrincipal = (authenticationState.User as ClaimsPrincipal);

            if (userPrincipal == null) { return false; }

            var c = new CancellationTokenSource();

            var user = await userStore.FindByNameAsync(userPrincipal.Identity.Name, c.Token);

            if (user == null) return false; // user was deleted

            if (user.EnableAutoLogOut)
            {
                var httpContext = scope.ServiceProvider.GetRequiredService<IHttpContextAccessor>().HttpContext;

                if (httpContext == null) return false;

                var ticket = await httpContext.AuthenticateAsync("Identity.Application");

                if (!ticket.Succeeded)
                {
                    AxoApplication.Current.Logger.Warning($"User ticket does not exist for '{user.UserName}' and the user will be logged out!", userPrincipal.Identity);

                    return false;
                }

                var start = ticket.Properties.IssuedUtc.Value;

                //todo - fix
                if (DateTime.UtcNow > (start + TimeSpan.FromMinutes(user.AutoLogOutTimeOutMinutes)))
                {
                    AxoApplication.Current.Logger.Information($"User '{user.UserName}' has reached the logout timeout and will be logged out!", userPrincipal.Identity);
                    return false;
                }
            }

            return await ValidateSecurityStampAsync(userManager, authenticationState.User, user);
        }

        /// <summary>
        /// check user if user have changed sensitive information (password, role ....)
        /// </summary>
        /// <param name="userManager"></param>
        /// <param name="principal"></param>
        /// <param name="user"></param>
        /// <returns></returns>
        private async Task<bool> ValidateSecurityStampAsync(UserManager<User> userManager, ClaimsPrincipal principal, User user)
        {
            var principalStamp = principal.FindFirstValue(options.Value.ClaimsIdentity.SecurityStampClaimType);

            if (principal.Identity is not { IsAuthenticated: true })
            {
                return false;
            }

            // !!! BUG !!! - tcopen repo do not find user =>  record key Tcopen/Sql? => EntityId / Id
            // var user = await userManager.GetUserAsync(principal);

            if (user is null)
            {
                return false;
            }
            else if (!userManager.SupportsUserSecurityStamp)
            {
                return true;
            }
            else
            {
                var userStamp = await userManager.GetSecurityStampAsync(user);

                var equals = principalStamp == userStamp;
                if (!equals)
                {
                    AxoApplication.Current.Logger.Warning($"User security stamp was changed for '{user.UserName}', and the user will be logged out!", principal.Identity);
                }

                return equals;
            }
        }
    }
}