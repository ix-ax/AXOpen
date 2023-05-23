using AxOpen.Security.Entities;
using AxOpen.Security.Services;
using Microsoft.AspNetCore.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AxOpen.Security.Views
{
    public partial class GroupManagementView
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
        private IRepositoryService _repositoryService { get; set; }

        private RoleGroupManager _roleGroupManager { get { return _repositoryService.RoleGroupManager; } }

        private IList<RoleData> AvailableRoles { get; set; }
        private IList<RoleData> AssignedRoles { get; set; }

        public Group SelectedGroupN { get; set; }
        public string newGroupName { get; set; }

        public void AssignRoles()
        {
            _roleGroupManager.AddRolesToGroup(SelectedGroupN.Name, AvailableRoles.Where(x => x.IsSelected == true).Select(x => x.Role.Name));
            GroupClicked(SelectedGroupN);
        }

        public void ReturnRoles()
        {
            _roleGroupManager.RemoveRolesFromGroup(SelectedGroupN.Name, AssignedRoles.Where(x => x.IsSelected == true).Select(x => x.Role.Name));
            GroupClicked(SelectedGroupN);
        }

        public void GroupClicked(Group group)
        {
            SelectedGroupN = group;
            AssignedRoles = _roleGroupManager.GetRolesFromGroup(group.Name).Select(x => new RoleData(_roleGroupManager.inAppRoleCollection.Where(x1 => x1.Name == x).FirstOrDefault())).ToList();
            AvailableRoles = _roleGroupManager.inAppRoleCollection.Where(x => !AssignedRoles.Select(x => x.Role.Name).Contains(x.Name)).Select(x => new RoleData(x)).ToList();
            StateHasChanged();
        }

        public void CloseGroupDetail()
        {
            SelectedGroupN = null;
        }

        public void CreateGroup()
        {
            if(newGroupName == null || newGroupName == "")
            {
                //WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Warning", "Name!", "Wrong group name", 10)));
                return;
            }
            var result = _roleGroupManager.CreateGroup(newGroupName);
            if (result.Succeeded)
            {
                //WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Created!", "Group successfully created!", 10)));
            }
            else
            {
                //WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Warning", "Not created!", "Group was not created.", 10)));
            }
            StateHasChanged();
        }

        public void DeleteGroup(Group group)
        {
            SelectedGroupN = null;
            var result = _roleGroupManager.DeleteGroup(group.Name);
            if (result.Succeeded)
            {
                //WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Success", "Deleted!", "Group successfully deleted", 10)));
            }
            else
            {
                //WeakReferenceMessenger.Default.Send(new ToastMessage(new Toast("Warning", "Not deleted!", "Group was not deleted.", 10)));
            }
            StateHasChanged();
        }
    }
}