using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Identity;
using Microsoft.JSInterop;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Linq;
using AXOpen.Core.blazor.Toaster;
using AXOpen.Core;
using CommunityToolkit.Mvvm.Messaging;

namespace Security
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

        private User SelectedUser { get; set; }
        private RegisterUserModel _model { get; set; }

        private ObservableCollection<UserData> AllUsers {
            get {
                return new ObservableCollection<UserData>(_blazorAuthenticationStateProvider.UserRepository.GetRecords());
            }
            }

        public void RowClicked(UserData user)
        {
            SelectedUser = new User(user);
            //_model = new RegisterUserModel();

            _model.Username = user.UserName;
            _model.Password = "password";
            _model.ConfirmPassword = "password";
            _model.CanUserChangePassword = user.CanUserChangePassword;
            _model.Email = user.Email;
            _model.Group = user.Roles[0];

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
            WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Deleted!", "User succesfully deleted!", 10)));
            //TcoAppDomain.Current.Logger.Information($"User '{user.UserName}' deleted. {{@sender}}", new { UserName = user.UserName });
        }

        private async void OnValidUpdate()
        {
            if (_model.Password != "password")
            {
                SelectedUser.PasswordHash = Hasher.CalculateHash(_model.Password, _model.Username);
            }
            if (_model.Group == "Choose group")
            {
                _model.Group = null;
            }
            SelectedUser.UserName = _model.Username;
            SelectedUser.CanUserChangePassword = _model.CanUserChangePassword;
            SelectedUser.Email = _model.Email;
            SelectedUser.Roles = new string[1] { _model.Group };
            SelectedUser.RoleHash = Hasher.CalculateHash(SelectedUser.Roles, _model.Username);
            var result = await _userManager.UpdateAsync(SelectedUser);
            if (result.Succeeded)
            {
                WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Updated!", "User succesfully updated!", 10)));
                //TcoAppDomain.Current.Logger.Information($"User '{SelectedUser.UserName}' updated. {{@sender}}", new { UserName = SelectedUser.UserName, Group = SelectedUser.Roles });
            }
            else
            {
                WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Warning", "Not updated!", "User was not updated!", 10)));
            }
        }

        protected override void OnInitialized()
        {
            _model = new RegisterUserModel();
        }
    }
}
