using AxOpen.Security.Entities;
using AxOpen.Security.Services;
using AXOpen;
using AXOpen.Base.Dialogs;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Operon.Components.Toast;
using System.Security.Principal;

namespace AxOpen.Security.Views
{
    public partial class GroupManagementView : BaseSecurityView
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

        private RoleGroupManager _roleGroupManager
        {
            get
            {
                return _repositoryService.RoleGroupManager;
            }
        }

        private IList<RoleData> AvailableRoles { get; set; }
        private IList<RoleData> AssignedRoles { get; set; }

        private bool selectAllAvailable;

        public bool SelectAllAvailable
        {
            get { return selectAllAvailable; }
            set
            {
                selectAllAvailable = value;
                foreach (RoleData role in AvailableRoles)
                {
                    role.IsSelected = selectAllAvailable;
                }
            }
        }

        private bool selectAllAssigned;

        public bool SelectAllAssigned
        {
            get { return selectAllAssigned; }
            set
            {
                selectAllAssigned = value;
                foreach (RoleData role in AssignedRoles)
                {
                    role.IsSelected = selectAllAssigned;
                }
            }
        }

        public Group SelectedGroupN { get; set; }
        public string newGroupName { get; set; }

        public async void AssignRoles()
        {
            var result = _roleGroupManager.AddRolesToGroup(SelectedGroupN.Name, AvailableRoles.Where(x => x.IsSelected == true).Select(x => x.Role.Name));
            if (result.Succeeded)
            {
                string msg = Localizer["Group \"{0}\" successfully updated.", SelectedGroupN.Name];

                _toastService?.AddToast(eToastType.Success, Localizer["Updated!"], msg, 10);
                AxoApplication.Current.Logger.Information(msg, await GetCurrentIdentity());
            }
            else
            {
                string msg = Localizer["Group \"{0}\" was not updated!", SelectedGroupN.Name] + $" {result.ToString()}";

                _toastService?.AddToast(eToastType.Warning, Localizer["Not updated!"], msg, 10);
                AxoApplication.Current.Logger.Warning(msg, await GetCurrentIdentity());
            }
            GroupClicked(SelectedGroupN);
            SelectAllAvailable = false;
        }

        public async void ReturnRoles()
        {
            // get current user identity

            var result = _roleGroupManager.RemoveRolesFromGroup(SelectedGroupN.Name, AssignedRoles.Where(x => x.IsSelected == true).Select(x => x.Role.Name));
            if (result.Succeeded)
            {
                string msg = Localizer["Group \"{0}\" successfully updated.", SelectedGroupN.Name];

                _toastService?.AddToast(eToastType.Success, Localizer["Updated!"], msg, 10);
                AxoApplication.Current.Logger.Information(msg, await GetCurrentIdentity());
            }
            else
            {
                string msg = Localizer["Group \"{0}\" was not updated!", SelectedGroupN.Name] + $" {result.ToString()}";
                _toastService?.AddToast(eToastType.Warning, Localizer["Not updated!"], msg, 10);
                AxoApplication.Current.Logger.Warning(msg, await GetCurrentIdentity());
            }
            GroupClicked(SelectedGroupN);
            SelectAllAssigned = false;
        }

        public void GroupClicked(Group group)
        {
            SelectedGroupN = group;
            AssignedRoles = _roleGroupManager.GetRolesFromGroup(group.Name).Select(x => new RoleData(_roleGroupManager.inAppRoleCollection.Where(x1 => x1.Name == x).FirstOrDefault())).ToList();
            AvailableRoles = _roleGroupManager.inAppRoleCollection.Where(x => !AssignedRoles.Select(x => x.Role.Name).Contains(x.Name)).Select(x => new RoleData(x)).ToList();
            StateHasChanged();
        }

        public async void CreateGroup()
        {
            if (newGroupName == null || newGroupName == "")
            {
                _toastService?.AddToast(eToastType.Warning, Localizer["Wrong name!"], Localizer["Wrong group name"], 10);

                return;
            }
            var result = _roleGroupManager.CreateGroup(newGroupName);
            if (result.Succeeded)
            {
                string msg = Localizer["Group \"{0}\" successfully created!", newGroupName];

                _toastService?.AddToast(eToastType.Success, Localizer["Created!"], msg, 10);
                AxoApplication.Current.Logger.Information(msg, await GetCurrentIdentity());
            }
            else
            {
                string msg = Localizer["Group \"{0}\" was not created!", newGroupName] + $" {result.ToString()}";

                _toastService?.AddToast(eToastType.Warning, Localizer["Not created!"], msg, 10);
                AxoApplication.Current.Logger.Warning(msg, await GetCurrentIdentity());
            }
            StateHasChanged();
        }

        public async void DeleteGroup(Group group)
        {
            SelectedGroupN = null;
            var result = _roleGroupManager.DeleteGroup(group.Name);

            if (result.Succeeded)
            {
                string msg = Localizer["Group \"{0}\" successfully deleted!", group.Name];

                _toastService?.AddToast(eToastType.Success, Localizer["Deleted!"], Localizer["Group successfully deleted"], 10);
                AxoApplication.Current.Logger.Information(msg, await GetCurrentIdentity());
            }
            else
            {
                string msg = Localizer["Group \"{0}\" was not deleted!", group.Name] + $" {result.ToString()}";

                _toastService?.AddToast(eToastType.Warning, Localizer["Not deleted!"], msg, 10);
                AxoApplication.Current.Logger.Information(msg, await GetCurrentIdentity());
            }
            StateHasChanged();
        }
    }
}