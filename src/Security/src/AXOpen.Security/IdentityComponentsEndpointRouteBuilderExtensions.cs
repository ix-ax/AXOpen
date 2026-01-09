using AxOpen.Security.Entities;
using AXOpen.Security.Services;
using Microsoft.AspNetCore.Antiforgery;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Primitives;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Security.Policy;
using System.Text;
using System.Text.Json;

namespace Microsoft.AspNetCore.Routing
{
    public static class IdentityComponentsEndpointRouteBuilderExtensions
    {
        public delegate Task LoginHandler(string username, string group, IList<string> roles, string ipAddress);
        public delegate Task LogoutHandler(string username, string ipAddress);

        // These endpoints are required by the Identity Razor components defined in the /Components/Account/Pages directory of this project.
        public static IEndpointRouteBuilder MapAdditionalIdentityEndpoints(this IEndpointRouteBuilder endpoints, LoginHandler? loginHandler = null, LogoutHandler? logoutHandler = null)
        {
            ArgumentNullException.ThrowIfNull(endpoints);

            endpoints.MapPost("/Login", async (
                HttpContext context,
                [FromServices] SignInManager<User> signInManager,
                [FromServices] UserManager<User> userManager) =>
            {
                try
                {
                    var formCollection = await context.Request.ReadFormAsync();
                    var username = formCollection["username"].ToString();
                    var password = formCollection["password"].ToString();
                    var returnUrl = formCollection["returnUrl"].ToString();
                    
                    if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
                        return TypedResults.LocalRedirect($"/Security/Login?error=invalid&returnUrl={Uri.EscapeDataString(returnUrl ?? "/")}");
                    
                    var result = await signInManager.PasswordSignInAsync(username, password, false, lockoutOnFailure: false);

                    if (result.Succeeded)
                    {
                        // Get user details for the login handler
                        var user = await userManager.FindByNameAsync(username);
                        if (user != null && loginHandler != null)
                        {
                            var roles = await userManager.GetRolesAsync(user);
                            string ipAddress = GetClientIpAddress(context);
                            await loginHandler(username, user.Group, roles, ipAddress);
                        }

                        return TypedResults.LocalRedirect(string.IsNullOrEmpty(returnUrl) ? "/" : !returnUrl.StartsWith("/") ? "/" + returnUrl : returnUrl.StartsWith("//") ? "/" + returnUrl.TrimStart('/') : returnUrl);
                    }
                    else // Redirect back to login with error
                        return TypedResults.LocalRedirect($"/Security/Login?error=invalid&returnUrl={Uri.EscapeDataString(returnUrl ?? "/")}");
                }
                catch (Exception ex)
                {
                    // Log the exception and redirect to login with error
                    Console.WriteLine($"Login error: {ex.Message}");
                    return TypedResults.LocalRedirect("/Security/Login?error=exception");
                }
            });

            endpoints.MapPost("/Logout", async (
                HttpContext context,
                [FromServices] SignInManager<User> signInManager) =>
            {
                var formCollection = await context.Request.ReadFormAsync();
                var returnUrl = formCollection["ReturnUrl"].ToString();

                // Get username before signing out
                string? username = context.User.Identity?.Name;
                
                if (!string.IsNullOrEmpty(username) && logoutHandler != null)
                {
                    string ipAddress = GetClientIpAddress(context);
                    await logoutHandler(username, ipAddress);
                }
                
                await signInManager.SignOutAsync();
                return TypedResults.LocalRedirect(string.IsNullOrEmpty(returnUrl) ? "/" : !returnUrl.StartsWith("/") ? "/" + returnUrl : returnUrl.StartsWith("//") ? "/" + returnUrl.TrimStart('/') : returnUrl);
            });

            endpoints.MapPost("/ExternalLogin", async (
                HttpContext context,
                [FromServices] SignInManager<User> signInManager,
                [FromServices] UserManager<User> userManager) =>
            {
                try
                {
                    var formCollection = await context.Request.ReadFormAsync();
                    var externalAuthId = formCollection["externalAuthId"].ToString();
                    var returnUrl = formCollection["returnUrl"].ToString();

                    if (string.IsNullOrEmpty(externalAuthId))
                        return TypedResults.LocalRedirect(string.IsNullOrEmpty(returnUrl) ? "/" : !returnUrl.StartsWith("/") ? "/" + returnUrl : returnUrl.StartsWith("//") ? "/" + returnUrl.TrimStart('/') : returnUrl);

                    // Check if there's a currently logged-in user
                    User? currentUser = null;
                    if (context.User.Identity?.Name != null)
                        currentUser = await userManager.FindByNameAsync(context.User.Identity.Name);

                    // Find user by hashed external auth ID
                    var users = userManager.Users.Where(u => TokenHasher.VerifyToken(externalAuthId, u.ExternalAuthId)).ToList();
                    if (!users.Any() || users.Count > 1)
                        return TypedResults.LocalRedirect(string.IsNullOrEmpty(returnUrl) ? "/" : !returnUrl.StartsWith("/") ? "/" + returnUrl : returnUrl.StartsWith("//") ? "/" + returnUrl.TrimStart('/') : returnUrl);

                    var user = users.First();

                    if (currentUser != null)
                    {
                        // User is already logged in
                        if (TokenHasher.VerifyToken(externalAuthId, currentUser.ExternalAuthId))
                        {
                            // Same user - log out
                            if (logoutHandler != null)
                            {
                                string ipAddress = GetClientIpAddress(context);
                                await logoutHandler(currentUser.UserName!, ipAddress);
                            }
                            await signInManager.SignOutAsync();
                            return TypedResults.LocalRedirect(string.IsNullOrEmpty(returnUrl) ? "/" : !returnUrl.StartsWith("/") ? "/" + returnUrl : returnUrl.StartsWith("//") ? "/" + returnUrl.TrimStart('/') : returnUrl);
                        }
                        else
                        {
                            // Different user - log out current and log in new
                            if (logoutHandler != null)
                            {
                                string ipAddress = GetClientIpAddress(context);
                                await logoutHandler(currentUser.UserName!, ipAddress);
                            }
                            await signInManager.SignOutAsync();
                        }
                    }

                    // Sign in the user
                    await signInManager.SignInAsync(user, isPersistent: false);

                    // Invoke the login handler
                    if (loginHandler != null)
                    {
                        var roles = await userManager.GetRolesAsync(user);
                        string ipAddress = GetClientIpAddress(context);
                        await loginHandler(user.UserName!, user.Group, roles, ipAddress);
                    }

                    if (!string.IsNullOrEmpty(returnUrl))
                    {
                        string[] split = returnUrl.Split('?');
                        if (split.Length > 1)
                        {
                            int returnUrlIndex = split[1].IndexOf("returnUrl=", StringComparison.OrdinalIgnoreCase);
                            if (returnUrlIndex >= 0)
                                returnUrl = Uri.UnescapeDataString(split[1].Substring(returnUrlIndex + "returnUrl=".Length));
                        }
                    }

                    return TypedResults.LocalRedirect(string.IsNullOrEmpty(returnUrl) ? "/" : !returnUrl.StartsWith("/") ? "/" + returnUrl : returnUrl.StartsWith("//") ? "/" + returnUrl.TrimStart('/') : returnUrl);
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"External login error: {ex.Message}");
                    return TypedResults.LocalRedirect("/");
                }
            });

            return endpoints;
        }

        private static string GetClientIpAddress(HttpContext context)
        {
            // Try to get IP from X-Forwarded-For header (for reverse proxy scenarios)
            var forwardedFor = context.Request.Headers["X-Forwarded-For"].FirstOrDefault();
            if (!string.IsNullOrEmpty(forwardedFor))
            {
                // X-Forwarded-For can contain multiple IPs, take the first one
                var ips = forwardedFor.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
                if (ips.Length > 0)
                    return ips[0];
            }

            // Try X-Real-IP header
            var realIp = context.Request.Headers["X-Real-IP"].FirstOrDefault();
            if (!string.IsNullOrEmpty(realIp))
                return realIp;

            // Fall back to RemoteIpAddress
            return context.Connection.RemoteIpAddress?.ToString() ?? "Unknown";
        }
    }
}
