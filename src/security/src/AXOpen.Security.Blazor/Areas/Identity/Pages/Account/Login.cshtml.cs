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

            if (ModelState.IsValid)
            {
                var result = await _signInManager.PasswordSignInAsync(Input.Username, Input.Password, false, lockoutOnFailure: false);

                if (result.Succeeded)
                {
                    var msg = _localizer["User \"{0}\", has been logged in.", Input.Username];
                    AxoApplication.Current.Logger.Information(msg, new GenericIdentity(Input.Username));

                    return LocalRedirect(returnUrl);
                }
                else
                {
                    var msg = _localizer["Invalid credentials entered for user \"{0}\"!", Input.Username];

                    ModelState.AddModelError(string.Empty, msg);
                    AxoApplication.Current.Logger.Information(msg, new GenericIdentity(Input.Username));

                    return Page();
                }
            }

            // If we got this far, something failed, redisplay form
            return Page();
        }
    }
}