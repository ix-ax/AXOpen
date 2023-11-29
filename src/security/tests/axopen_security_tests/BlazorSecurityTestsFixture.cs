using AxOpen.Security;
using AxOpen.Security.Entities;
using AxOpen.Security.Services;
using AxOpen.Security.Stores;
using AXOpen.Base.Data;
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
        private IRepository<User> _RepoUser;
        private IRepository<Group> _RepoGroup;

        private AXOpen.Data.InMemory.InMemoryRepository<User> _inMemoryRepoUser;
        private AXOpen.Data.InMemory.InMemoryRepository<Group> _inMemoryRepoGroup;

        private AXOpen.Data.Json.JsonRepository<User> _inJsonRepoUser;
        private AXOpen.Data.Json.JsonRepository<Group> _inJsonRepoGroup;

        private AXOpen.Data.MongoDb.MongoDbRepository<User> _inMongoRepoUser;
        private AXOpen.Data.MongoDb.MongoDbRepository<Group> _inMongRepoGroup;

        private RoleGroupManager _roleGroupManager;
        public BlazorSecurityTestsFixture()
        {
            var MongoConnectionString = "mongodb://localhost:27017";
            var MongoDatabaseName = "TestingSeurity";

            // initialize factory - store connection and credentials
            AXOpen.Data.MongoDb.Repository.InitializeFactory(MongoConnectionString, MongoDatabaseName, "user", "userpwd");

            _RepoUser = AXOpen.Data.MongoDb.Repository.Factory<User>("Users", t => t.Id);
            _RepoGroup = AXOpen.Data.MongoDb.Repository.Factory<Group>("UsersGroups");


            _roleGroupManager = new RoleGroupManager(_RepoGroup);
            //Repository = new RepositoryService(_inMemoryRepoUser, _roleGroupManager);

            SeedData = new Seed(new PasswordHasher<User>());

            _RepoUser.Create(SeedData.ExistUser.UserName, SeedData.ExistUser);
            _RepoUser.Create(SeedData.RemoveUser.UserName, SeedData.RemoveUser);
            _RepoUser.Create(SeedData.UpdateUser.UserName, SeedData.UpdateUser);
            _RepoUser.Create(SeedData.AdminUser.UserName, SeedData.AdminUser);
            _RepoUser.Create(SeedData.DefaultUser.UserName, SeedData.DefaultUser);

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

            Repository = new RepositoryService(_RepoUser, _roleGroupManager);
            UserStore = new UserStore(Repository);
        }
        public IRepositoryService Repository { get; set; }
        public UserStore UserStore { get; set; }
        public Seed SeedData { get; set; }

        public void Dispose()
        {

            var allUsers = _RepoUser.GetRecords();
            var allGroups = _RepoGroup.GetRecords();

            foreach (var user in allUsers)
            {
                _RepoUser.Delete(user.DataEntityId);
            }

            foreach (var group in allGroups)
            {
                _RepoGroup.Delete(group.DataEntityId);
            }

            _roleGroupManager = new RoleGroupManager(_RepoGroup);
            Repository = new RepositoryService(_RepoUser, _roleGroupManager);
        }
    }
}
