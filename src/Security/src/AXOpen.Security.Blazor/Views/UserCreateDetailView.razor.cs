using AxOpen.Security.Entities;
using AxOpen.Security.Models;
using AxOpen.Security.Services;
using AXOpen;
using AXOpen.Base.Dialogs;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Identity;
using Operon.Components.Toast;
using System.Security.Principal;

namespace AxOpen.Security.Views
{
    public partial class UserCreateDetailView : BaseSecurityView
    {
        [Parameter]
        public string? ReturnUrl { set; get; } // todo check it and fix it

        [Inject]
        protected NavigationManager _navigationManager { get; set; }

        private CreateUserModel _model { get; set; }
        private User _user { get; set; }

        private async void OnValidSubmit()
        {
            _user = new User(_model.Username, _model.Email, _model.Group, _model.CanUserChangePassword, _model.EnableAutoLogOut, _model.AutoLogOutTimeOutMinutes);

            _user.SecurityStamp = Guid.NewGuid().ToString();

            var result = await _userManager.CreateAsync(_user, _model.Password);

            if (result.Succeeded)
            {
                var msg = Localizer["User \"{0}\" successfully created.", _model.Username];
                _toastService?.AddToast(eToastType.Success, Localizer["Created!"], msg, 10);
                AxoApplication.Current.Logger.Information(msg, await GetCurrentIdentity());

                if (!string.IsNullOrEmpty(ReturnUrl))
                {
                    _navigationManager.NavigateTo(ReturnUrl);
                }
                else
                {
                    this._model = new CreateUserModel();
                }
            }
            else
            {
                var msg = Localizer["User \"{0}\" was not created.", _model.Username] + $" {result.ToString()}";

                _toastService?.AddToast(eToastType.Warning, Localizer["Not created!"], msg, 10);
                AxoApplication.Current.Logger.Warning(msg, await GetCurrentIdentity());
            }
        }

        protected override void OnInitialized()
        {
            _model = new CreateUserModel();
        }
    }
}