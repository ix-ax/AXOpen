using System.Security.Claims;
using System.Text.Json;
using AxOpen.Security.Entities;
using Microsoft.AspNetCore.Antiforgery;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;

namespace Microsoft.AspNetCore.Routing
{
    public static class IdentityComponentsEndpointRouteBuilderExtensions
    {
        // These endpoints are required by the Identity Razor components defined in the /Components/Account/Pages directory of this project.
        public static IEndpointRouteBuilder MapAdditionalIdentityEndpoints(this IEndpointRouteBuilder endpoints)
        {
            ArgumentNullException.ThrowIfNull(endpoints);

            endpoints.MapPost("/Login", async (
                HttpContext context,
                [FromServices] SignInManager<User> signInManager) =>
            {
                try
                {
                    var formCollection = await context.Request.ReadFormAsync();
                    var username = formCollection["username"].ToString();
                    var password = formCollection["password"].ToString();
                    var rememberMe = formCollection["rememberMe"].ToString() == "true";
                    var returnUrl = formCollection["returnUrl"].ToString();
                    
                    if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
                    {
                        return TypedResults.LocalRedirect($"/Security/Login?error=invalid&returnUrl={Uri.EscapeDataString(returnUrl ?? "/")}");
                    }
                    
                    var result = await signInManager.PasswordSignInAsync(username, password, rememberMe, lockoutOnFailure: false);

                    if (result.Succeeded)
                    {
                        // Sanitize returnUrl to ensure it's a local relative path
                        if (string.IsNullOrEmpty(returnUrl))
                        {
                            return TypedResults.LocalRedirect("/");
                        }
                        
                        // If it's an absolute URL, extract just the path
                        if (Uri.TryCreate(returnUrl, UriKind.Absolute, out var absoluteUri))
                        {
                            returnUrl = absoluteUri.PathAndQuery;
                        }
                        
                        // Ensure it starts with / and doesn't start with //
                        if (!returnUrl.StartsWith("/"))
                        {
                            returnUrl = "/" + returnUrl;
                        }
                        else if (returnUrl.StartsWith("//"))
                        {
                            returnUrl = "/" + returnUrl.TrimStart('/');
                        }
                        
                        return TypedResults.LocalRedirect(returnUrl);
                    }
                    else
                    {
                        // Redirect back to login with error
                        return TypedResults.LocalRedirect($"/Security/Login?error=invalid&returnUrl={Uri.EscapeDataString(returnUrl ?? "/")}");
                    }
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
                
                await signInManager.SignOutAsync();
                return TypedResults.LocalRedirect(string.IsNullOrEmpty(returnUrl) ? "/" : $"/{returnUrl}");
            });

            return endpoints;
        }
    }
}
