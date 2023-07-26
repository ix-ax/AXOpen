using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Identity;
using Microsoft.JSInterop;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Linq;
using AxOpen.Security.Entities;
using AxOpen.Security.Models;
using AXSharp.Abstractions.Dialogs.AlertDialog;

namespace AxOpen.Security.Views
{
    public partial class UserManagementView
    {
        private class RoleData
        {
            public RoleData(Role role)
            {
                Role = role;
            }
            public Role Role { get; set; }
            public bool IsSelected { get; set; }
        }

        [Inject]
        private UserManager<User> _userManager { get; set; }

        [Inject]
        private IAlertDialogService _alertDialogService { get; set; }

        private User SelectedUser { get; set; }
        private UpdateUserModel _model { get; set; }

        private ObservableCollection<User> AllUsers {
            get {
                return new ObservableCollection<User>(_repositoryService.UserRepository.GetRecords());
            }
            }

        public void RowClicked(User user)
        {
            SelectedUser = user;

            _model.Username = user.UserName;
            _model.CanUserChangePassword = user.CanUserChangePassword;
            _model.Email = user.Email;
            _model.Group = user.Group;

            StateHasChanged();
        }

        public void CloseUserDetail()
        {
            SelectedUser = null;
        }

        public async Task DeleteUser(User user)
        {
            await _userManager.DeleteAsync(user);
            SelectedUser = null;
            _alertDialogService.AddAlertDialog("Success", Localizer["Deleted!"], Localizer["User succesfully deleted!"], 10);
            //TcoAppDomain.Current.Logger.Information($"User '{user.UserName}' deleted. {{@sender}}", new { UserName = user.UserName });
        }

        private async void OnValidUpdate()
        {
            if (_model.Group == "Choose group")
            {
                _model.Group = null;
            }
            SelectedUser.UserName = _model.Username;
            SelectedUser.CanUserChangePassword = _model.CanUserChangePassword;
            SelectedUser.Email = _model.Email;
            SelectedUser.Group = _model.Group;
            SelectedUser.Modified = DateTime.Now.ToString();
            if (_model.Password != null && _model.Password != "" && _model.ConfirmPassword != null && _model.ConfirmPassword == _model.Password)
            {
                SelectedUser.PasswordHash = _userManager.PasswordHasher.HashPassword(SelectedUser, _model.Password);
            }
            //SelectedUser.RoleHash = Hasher.CalculateHash(SelectedUser.Roles, _model.Username);
            var result = await _userManager.UpdateAsync(SelectedUser);
            if (result.Succeeded)
            {

                _alertDialogService.AddAlertDialog("Success", Localizer["Updated!"], Localizer["User succesfully updated"], 10);
                //TcoAppDomain.Current.Logger.Information($"User '{SelectedUser.UserName}' updated. {{@sender}}", new { UserName = SelectedUser.UserName, Group = SelectedUser.Roles });
            }
            else
            {
                _alertDialogService.AddAlertDialog("Warning", Localizer["Not updated!"], Localizer["User was not updated"], 10);
            }
        }

        protected override void OnInitialized()
        {
            _model = new UpdateUserModel();
        }
    }
}
