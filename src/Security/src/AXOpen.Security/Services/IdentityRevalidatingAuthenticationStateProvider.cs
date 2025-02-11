using System.Security.Claims;
using System.Security.Principal;
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
    public sealed class IdentityRevalidatingAuthenticationStateProvider : RevalidatingServerAuthenticationStateProvider, IDisposable
    {
        protected ILoggerFactory loggerFactory;
        protected IServiceScopeFactory scopeFactory;
        protected IUserStore<User> userStore;
        protected IOptions<IdentityOptions> options;

        public IdentityRevalidatingAuthenticationStateProvider
        (
            ILoggerFactory loggerFactory,
            IServiceScopeFactory scopeFactory,
            IUserStore<User> userStore,
            IOptions<IdentityOptions> options
        ) : base(loggerFactory)
        {
            this.loggerFactory = loggerFactory;
            this.scopeFactory = scopeFactory;
            this.userStore = userStore;
            this.options = options;
        }

        UpperInvariantLookupNormalizer Normalizer = new UpperInvariantLookupNormalizer();

        protected override TimeSpan RevalidationInterval => TimeSpan.FromSeconds(30);

        protected override async Task<bool> ValidateAuthenticationStateAsync(
            AuthenticationState authenticationState, CancellationToken cancellationToken)
        {
            try
            {
                // Get the user manager from a new scope to ensure it fetches fresh data
                await using var scope = scopeFactory.CreateAsyncScope();

                var userManager = scope.ServiceProvider.GetRequiredService<UserManager<User>>();

                ClaimsPrincipal userPrincipal = (authenticationState.User as ClaimsPrincipal);

                if (cancellationToken.IsCancellationRequested) return false;

                if (userPrincipal == null)
                {
                    AxoApplication.Current.Logger.Information($"Ivalid user principals, will be logged out!", new GenericIdentity("Unknown"));
                    return false;
                }

                var user = await userStore.FindByNameAsync(Normalizer.NormalizeName(userPrincipal.Identity.Name), cancellationToken);

                if (user == null)
                {
                    AxoApplication.Current.Logger.Warning($"User '{userPrincipal.Identity.Name}' does not found in the database. Will be logged out!", userPrincipal.Identity);
                    return false;
                }

                if (cancellationToken.IsCancellationRequested) return false;

                if (user.EnableAutoLogOut)
                {
                    var httpContext = scope.ServiceProvider.GetRequiredService<IHttpContextAccessor>().HttpContext;

                    if (httpContext == null)
                    {
                        AxoApplication.Current.Logger.Warning($"Http context does not exist. User '{user.UserName}' will be logged out!", userPrincipal.Identity);

                        return false;
                    }

                    var ticket = await httpContext.AuthenticateAsync(IdentityConstants.ApplicationScheme);

                    if (!ticket.Succeeded)
                    {
                        AxoApplication.Current.Logger.Warning($"User ticket does not exist for '{user.UserName}' and the user will be logged out!", userPrincipal.Identity);

                        return false;
                    }

                    var expire = ticket.Properties.ExpiresUtc.Value;

                    if (DateTime.UtcNow > expire)
                    {
                        AxoApplication.Current.Logger.Information($"User '{user.UserName}' has reached the logout timeout '{expire}' and will be logged out!", userPrincipal.Identity);
                        return false;
                    }
                }

                if (cancellationToken.IsCancellationRequested) return false;

                return await ValidateSecurityStampAsync(userManager, authenticationState.User, user);
            }
            catch (Exception ex)
            {
                throw new Exception("Revalidation failed", ex);
            }
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