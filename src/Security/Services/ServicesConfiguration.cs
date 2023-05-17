﻿using AXOpen.Base.Data;
using AXOpen.Data.Json;
using AXOpen.Data.MongoDb;
using AXOpen.Data.RavenDb;
using AXOpen.Data.InMemory;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using System.Reflection;
using Microsoft.AspNetCore.Authentication;

namespace Security
{
    public static class ServicesConfiguration
    {
        public static void AddVortexBlazorSecurity(this IServiceCollection services,
            (IRepository<UserData> userRepo, IRepository<GroupData> groupRepo) repos)
        {
            services.AddIdentity<User, Role>(identity =>
            {
                identity.Password.RequireDigit = false;
                identity.Password.RequireLowercase = false;
                identity.Password.RequireNonAlphanumeric = false;
                identity.Password.RequireUppercase = false;
                identity.Password.RequiredLength = 0;
                identity.Password.RequiredUniqueChars = 0;
            }
            )
            //.AddCustomStores()
            .AddDefaultTokenProviders();

            services.AddTransient<IUserStore<User>, UserStore>();
            services.AddTransient<IRoleStore<Role>, RoleStore>();

            RoleGroupManager roleGroupManager = new RoleGroupManager(repos.groupRepo);

            BlazorAuthenticationStateProvider blazorAuthenticationStateProvider = new BlazorAuthenticationStateProvider(repos.userRepo, roleGroupManager);

            //blazorAuthenticationStateProvider.ExternalAuthorization = ExternalTokenAuthorization.CreatePlcTokenReader("sff", true);

            SecurityManager.Create(blazorAuthenticationStateProvider, repos.userRepo);

            services.AddScoped<RoleGroupManager>(p => roleGroupManager);
            
            services.AddScoped<IRepositoryService, RepositoryService>(provider => new RepositoryService(repos.userRepo, roleGroupManager));
            //services.AddScoped<AuthenticationStateProvider, RevalidatingIdentityAuthenticationStateProvider<User>>();
            services.AddScoped<AuthenticationStateProvider, BlazorAuthenticationStateProvider>(p => blazorAuthenticationStateProvider);
        }

        public static (IRepository<UserData>, IRepository<GroupData>) SetUpJSon(string path = "..\\..\\..\\..\\..\\JSONREPOS\\")
        {
            var executingAssemblyFile = new FileInfo(Assembly.GetExecutingAssembly().Location);
            var repositoryDirectory = Path.GetFullPath($"{executingAssemblyFile.Directory}{path}");

            if (!Directory.Exists(repositoryDirectory))
            {
                Directory.CreateDirectory(repositoryDirectory);
            }


            IRepository<UserData> userRepo = new JsonRepository<UserData>(new JsonRepositorySettings<UserData>(Path.Combine(repositoryDirectory, "Users")));
            IRepository<GroupData> groupRepo = new JsonRepository<GroupData>(new JsonRepositorySettings<GroupData>(Path.Combine(repositoryDirectory, "Groups")));

            return (userRepo, groupRepo);
        }

        public static (IRepository<UserData>, IRepository<GroupData>) SetUpMongo(string path = "Blazor")
        {
            var mongoUri = "mongodb://localhost:27017";

            IRepository<UserData> userRepo = new MongoDbRepository<UserData>(new MongoDbRepositorySettings<UserData>(mongoUri, path, "Users"));
            IRepository<GroupData> groupRepo = new MongoDbRepository<GroupData>(new MongoDbRepositorySettings<GroupData>(mongoUri, path, "Groups"));

            return (userRepo, groupRepo);
        }

        public static (IRepository<UserData>, IRepository<GroupData>) SetUpRavenDB(string[] urls, string path = "Blazor", string certPath = "", string certPass = "")
        {
            IRepository<UserData> userRepo = new RavenDbRepository<UserData>(new RavenDbRepositorySettings<UserData>(urls, path, certPath, certPass));
            IRepository<GroupData> groupRepo = new RavenDbRepository<GroupData>(new RavenDbRepositorySettings<GroupData>(urls, path, certPath, certPass));

            return (userRepo, groupRepo);
        }

        public static (IRepository<UserData>, IRepository<GroupData>) SetUpInMemory()
        {
            IRepository<UserData> userRepo = new InMemoryRepository<UserData>(new InMemoryRepositorySettings<UserData>());
            IRepository<GroupData> groupRepo = new InMemoryRepository<GroupData>(new InMemoryRepositorySettings<GroupData>());

            return (userRepo, groupRepo);
        }
    }
}
