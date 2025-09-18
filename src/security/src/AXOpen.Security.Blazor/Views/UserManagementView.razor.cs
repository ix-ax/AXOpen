using AxOpen.Security.Entities;
using AxOpen.Security.Entities;
using AxOpen.Security.Models;
using AxOpen.Security.Services;
using AXOpen;
using AXOpen;
using AXOpen.Base.Dialogs;
using AXOpen.Base.Dialogs;
using AXOpen.Security;
using AXOpen.Security.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Localization;
using Operon.Components.Toast;
using System.Collections.ObjectModel;
using System.Text;
using static System.Net.Mime.MediaTypeNames;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace AxOpen.Security.Views
{
    public partial class UserManagementView : BaseSecurityView, IDisposable
    {
        private User SelectedUser { get; set; }

        private UpdateUserModel _model { get; set; }

        private ObservableCollection<User> AllUsers
        {
            get
            {
                var users = new ObservableCollection<User>(_repositoryService.UserRepository.GetRecords());

                return users;
            }
        }

        [Inject]
        private ISerialService _serialService { get; set; }

        protected override void OnInitialized()
        {
            _model = new UpdateUserModel();

            _serialService.SerialError += OnSerialError;
            _serialService.DataReceived += OnSerialDataReceived;
        }

        public void Dispose()
        {
            _serialService.DataReceived -= OnSerialDataReceived;
            _serialService.SerialError -= OnSerialError;
        }

        private void OnSerialError()
        {
            _serialService.DataReceived -= OnSerialDataReceived;
            Console.WriteLine("Serial port error");
        }

        private void OnSerialDataReceived(byte[] data)
        {
            if (SelectedUser != null)
                _model.ExternalAuthId = Encoding.ASCII.GetString(System.Security.Cryptography.SHA512.HashData(Encoding.ASCII.GetBytes(Encoding.ASCII.GetString(data).Trim())));

            _toastService?.AddToast(eToastType.Success, Localizer["Updated!"], "The external token has been updated", 10);
            StateHasChanged();
        }

        private void ClearExternalAuthId()
        {
            _model.ExternalAuthId = null;
        }

        public void RowClicked(User user)
        {
            SelectedUser = user;

            _model.Username = user.UserName;
            _model.CanUserChangePassword = user.CanUserChangePassword;
            _model.Email = user.Email;
            _model.Group = user.Group;
            _model.EnableAutoLogOut = user.EnableAutoLogOut;
            _model.AutoLogOutTimeOutMinutes = user.AutoLogOutTimeOutMinutes;
            _model.ExternalAuthId = user.ExternalAuthId;

            StateHasChanged();
        }

        public string GetBaseUri()
        {
            var path = this._navigationManager.ToBaseRelativePath(_navigationManager.Uri);
            return path;
        }

        public void CloseUserDetail()
        {
            SelectedUser = null;
        }

        public async Task DeleteUser(User user)
        {
            var deletedUserName = user.UserName;

            var result = await _userManager.DeleteAsync(user);

            if (result.Succeeded)
            {
                SelectedUser = null;

                string msg = Localizer["User \"{0}\" succesfully deleted!", deletedUserName];

                _toastService?.AddToast(eToastType.Success, Localizer["Deleted!"], msg, 10);
                AxoApplication.Current.Logger.Information(msg, await GetCurrentIdentity());
            }
            else
            {
                string msg = Localizer["User \"{0}\" was not deleted!", deletedUserName] + $" {result.ToString()}";

                _toastService?.AddToast(eToastType.Success, Localizer["Deleted!"], msg, 10);
                AxoApplication.Current.Logger.Warning(msg, await GetCurrentIdentity());
            }
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
            SelectedUser.Modified = DateTime.Now;
            SelectedUser.EnableAutoLogOut = _model.EnableAutoLogOut;
            SelectedUser.AutoLogOutTimeOutMinutes = _model.AutoLogOutTimeOutMinutes;

            if (SelectedUser.ExternalAuthId != _model.ExternalAuthId)
            {
                if (!string.IsNullOrEmpty(_model.ExternalAuthId))
                {
                    List<User> users = _repositoryService.UserRepository.GetRecords().Where(user => user.ExternalAuthId != null && user.ExternalAuthId.Equals(_model.ExternalAuthId)).ToList();
                    if (users.Any())
                    {
                        _toastService?.AddToast(eToastType.Danger, Localizer["Not updated!"], "User was not updated, because externalId has using diferent user!", 10);
                        return;
                    }

                    string externalAuthIdHashed = _model.ExternalAuthId;
                    SelectedUser.ExternalAuthId = externalAuthIdHashed;
                }
                else
                {
                    SelectedUser.ExternalAuthId = null;
                }
            }
            
            if (SelectedUser.Group != _model.Group)
            {
                SelectedUser.Group = _model.Group;
                SelectedUser.SecurityStamp = Guid.NewGuid().ToString(); //due to a change of sensitive information
            }

            if (_model.Password != null && _model.Password != "" && _model.ConfirmPassword != null && _model.ConfirmPassword == _model.Password)
            {
                SelectedUser.PasswordHash = _userManager.PasswordHasher.HashPassword(SelectedUser, _model.Password);

                SelectedUser.SecurityStamp = Guid.NewGuid().ToString(); //due to a change of sensitive information
            }

            //SelectedUser.RoleHash = Hasher.CalculateHash(SelectedUser.Roles, _model.Username);
            var result = await _userManager.UpdateAsync(SelectedUser);

            if (result.Succeeded)
            {
                string msg = Localizer["User \"{0}\" succesfully updated!", _model.Username];

                _toastService?.AddToast(eToastType.Success, Localizer["Updated!"], msg, 10);
                AxoApplication.Current.Logger.Information(msg, await GetCurrentIdentity());
            }
            else
            {
                string msg = Localizer["User \"{0}\" was not updated!", _model.Username] + $" {result.ToString()}";
                _toastService?.AddToast(eToastType.Warning, Localizer["Not updated!"], msg, 10);

                AxoApplication.Current.Logger.Warning(msg, await GetCurrentIdentity());
            }
        }
    }
}