using AxOpen.Security;
using AxOpen.Security.Entities;
using AxOpen.Security.Services;
using AxOpen.Security.Stores;
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
        private InMemoryRepository<User> _inMemoryRepoUser;
        private InMemoryRepository<Group> _inMemoryRepoGroup;
        private RoleGroupManager _roleGroupManager;
        public BlazorSecurityTestsFixture()
        {
            _inMemoryRepoUser = new InMemoryRepository<User>();
            _inMemoryRepoGroup = new InMemoryRepository<Group>();
            _roleGroupManager = new RoleGroupManager(_inMemoryRepoGroup);
            //Repository = new RepositoryService(_inMemoryRepoUser, _roleGroupManager);

            SeedData = new Seed(new PasswordHasher<User>());

            _inMemoryRepoUser.Create(SeedData.ExistUser.UserName, SeedData.ExistUser);
            _inMemoryRepoUser.Create(SeedData.RemoveUser.UserName, SeedData.RemoveUser);
            _inMemoryRepoUser.Create(SeedData.UpdateUser.UserName, SeedData.UpdateUser);
            _inMemoryRepoUser.Create(SeedData.AdminUser.UserName, SeedData.AdminUser);
            _inMemoryRepoUser.Create(SeedData.DefaultUser.UserName, SeedData.DefaultUser);

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

            Repository = new RepositoryService(_inMemoryRepoUser, _roleGroupManager);
            UserStore = new UserStore(Repository);
        }
        public IRepositoryService Repository { get; set; }
        public UserStore UserStore { get; set; }
        public Seed SeedData { get; set; }

        public void Dispose()
        {
            _inMemoryRepoUser = new InMemoryRepository<User>();
            _inMemoryRepoGroup = new InMemoryRepository<Group>();
            _roleGroupManager = new RoleGroupManager(_inMemoryRepoGroup);
            Repository = new RepositoryService(_inMemoryRepoUser, _roleGroupManager);
        }
    }
}
