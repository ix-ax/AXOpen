using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Identity;
using AxOpen.Security.Entities;
using AxOpen.Security.Models;
using AxOpen.Security.Services;
using AxOpen;
using AXOpen;
using Microsoft.AspNetCore.Components.Authorization;
using System.Security.Principal;
using Microsoft.Extensions.Localization;
using AXOpen.Security.Blazor.Resources;

namespace AxOpen.Security.Areas.Identity.Pages.Account
{
    [AllowAnonymous]
    internal class LoginModel : PageModel
    {
        private readonly UserManager<User> _userManager;
        private readonly SignInManager<User> _signInManager;
        public readonly IStringLocalizer<BlazorResources> _localizer;

        public LoginModel(SignInManager<User> signInManager,
            ILogger<LoginModel> logger,
            UserManager<User> userManager,
            IStringLocalizer<BlazorResources> localizer
            )
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _localizer = localizer;
        }

        [BindProperty]
        public LoginUserModel Input { get; set; }

        public string ReturnUrl { get; set; }

        [TempData]
        public string ErrorMessage { get; set; }

        public async Task OnGetAsync(string returnUrl = null)
        {
            if (!string.IsNullOrEmpty(ErrorMessage))
            {
                ModelState.AddModelError(string.Empty, ErrorMessage);
            }

            returnUrl ??= Url.Content("~/");

            // Clear the existing external cookie to ensure a clean login process
            await HttpContext.SignOutAsync(IdentityConstants.ExternalScheme);

            ReturnUrl = returnUrl;
        }

        public async Task<IActionResult> OnPostAsync(string returnUrl = null)
        {
            returnUrl ??= Url.Content("~/");

            string msg = "";

            if (ModelState.IsValid)
            {
                var user = await _userManager.FindByNameAsync(Input.Username);

                if (user == null)
                {
                    msg = _localizer["User \"{0}\" does not exit!", Input?.Username];

                    AxoApplication.Current.Logger.Warning(msg, new GenericIdentity("unknown"));

                    ModelState.AddModelError(string.Empty, msg);
                    return Page();
                }

                var passIsValid = await _userManager.CheckPasswordAsync(user, Input.Password);

                if (!passIsValid)
                {
                    msg = _localizer["Invalid password for the user \"{0}\" !", Input?.Username];

                    AxoApplication.Current.Logger.Warning(msg, new GenericIdentity("unknown"));

                    ModelState.AddModelError(string.Empty, msg);
                    return Page();
                }

                AuthenticationProperties authProperties;

                if (user.EnableAutoLogOut)
                {
                    authProperties = new AuthenticationProperties
                    {
                        IsPersistent = true,
                        ExpiresUtc = DateTimeOffset.UtcNow.AddMinutes(user.AutoLogOutTimeOutMinutes),
                        AllowRefresh = true,
                    };
                }
                else
                {
                    authProperties = new AuthenticationProperties
                    {
                        IsPersistent = true,
                        ExpiresUtc = DateTimeOffset.UtcNow.AddDays(14),
                        AllowRefresh = true,
                    };
                }

                // Sign in with custom expiration
                await _signInManager.SignInAsync(user, authProperties);

                msg = _localizer["User \"{0}\", has been logged in.", Input.Username];
                AxoApplication.Current.Logger.Information(msg, new GenericIdentity(Input.Username));

                return LocalRedirect(returnUrl);
            }

            return Page();
        }
    }
}