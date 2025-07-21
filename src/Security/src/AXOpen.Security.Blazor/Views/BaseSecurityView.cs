
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Identity;
using System.Security.Principal;
using AxOpen.Security.Entities;
using AxOpen.Security.Services;
using AXOpen;
using AXOpen.Base.Dialogs;
using Microsoft.Extensions.Localization;
using Operon.Components.Toast;

namespace AxOpen.Security.Views
{
    public class BaseSecurityView : Microsoft.AspNetCore.Components.ComponentBase
    {
        [Inject]
        protected UserManager<User> _userManager { get; set; }
        [Inject]
        protected SignInManager<User> _signInManager { get; set; }

        [Inject]
        protected NavigationManager _navigationManager { get; set; }

        [Inject]
        protected AuthenticationStateProvider _authenticationStateProvider { get; set; }

        [Inject]
        protected IRepositoryService _repositoryService { get; set; }

        [Inject]
        protected IToastService? _toastService { get; set; }

        protected async Task<IIdentity> GetCurrentIdentity()
        {
            if (_authenticationStateProvider == null)
            {
                return new GenericIdentity("Unknown");
            }
            else
            {
                var context = await _authenticationStateProvider.GetAuthenticationStateAsync();

                if (context != null)
                {
                    return context.User.Identity;
                }
                else return new GenericIdentity("Unknown");
            }
        }
    }
}