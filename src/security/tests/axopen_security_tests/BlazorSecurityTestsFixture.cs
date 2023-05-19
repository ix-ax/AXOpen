using AxOpen.Security;
using AXOpen.Data.InMemory;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AxOpen.Security.Tests
{
    public class BlazorSecurityTestsFixture : IDisposable
    {
        private InMemoryRepository<UserData> _inMemoryRepoUser;
        private InMemoryRepository<GroupData> _inMemoryRepoGroup;
        private RoleGroupManager _roleGroupManager;
        public BlazorSecurityTestsFixture()
        {
            _inMemoryRepoUser = new InMemoryRepository<UserData>();
            _inMemoryRepoGroup = new InMemoryRepository<GroupData>();
            _roleGroupManager = new RoleGroupManager(_inMemoryRepoGroup);
            //Repository = new RepositoryService(_inMemoryRepoUser, _roleGroupManager);
           

            _inMemoryRepoUser.Create(SeedData.ExistUser.UserName, new UserData(SeedData.ExistUser));
            _inMemoryRepoUser.Create(SeedData.RemoveUser.UserName, new UserData(SeedData.RemoveUser));
            _inMemoryRepoUser.Create(SeedData.UpdateUser.UserName, new UserData(SeedData.UpdateUser));
            _inMemoryRepoUser.Create(SeedData.AdminUser.UserName, new UserData(SeedData.AdminUser));
            _inMemoryRepoUser.Create(SeedData.DefaultUser.UserName, new UserData(SeedData.DefaultUser));

            _roleGroupManager.CreateRole(new Role("RemoveRole"));
            _roleGroupManager.CreateRole(new Role("UpdateRole"));
            _roleGroupManager.CreateRole(new Role("Administrator"));
            _roleGroupManager.CreateRole(new Role("Default"));

            _roleGroupManager.CreateGroup("RemoveGroup");
            _roleGroupManager.CreateGroup("RemoveRolesGroup");
            _roleGroupManager.CreateGroup("UpdateGroup");
            _roleGroupManager.CreateGroup("DefaultGroup");

            _roleGroupManager.AddRolesToGroup("DefaultGroup", new string[] { "Administrator", "Default" });
            _roleGroupManager.AddRolesToGroup("RemoveRolesGroup", new string[] { "Administrator", "Default" });

            Basp = new BlazorAuthenticationStateProvider(_inMemoryRepoUser, _roleGroupManager);
            UserStore = new UserStore(Basp);
            SeedData = new Seed();
        }

        public UserStore UserStore { get; set; }
        public Seed SeedData { get; set; }

        //public IRepositoryService Repository { get; set; }
        public BlazorAuthenticationStateProvider Basp { get; set; }
        public void Dispose()
        {
            _inMemoryRepoUser = new InMemoryRepository<UserData>();
            Basp = new BlazorAuthenticationStateProvider(_inMemoryRepoUser, _roleGroupManager);
        }
    }
}
