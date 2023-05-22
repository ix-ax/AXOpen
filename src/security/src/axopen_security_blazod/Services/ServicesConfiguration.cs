using AxOpen.Security.Entities;
using AxOpen.Security.Extensions;
using AXOpen.Base.Data;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace AxOpen.Security.Services
{
    public static class ServicesConfiguration
    {

        public static void AddVortexBlazorSecurity(this IServiceCollection services,
            (IRepository<User> userRepo, IRepository<Group> groupRepo) repos,
            List<Role>? roles = null)
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
            .AddCustomStores()
            .AddDefaultTokenProviders();

            RoleGroupManager roleGroupManager = new RoleGroupManager(repos.groupRepo);
            if (roles != null)
            {
                roleGroupManager.CreateRoles(roles);
            }

            var allUsers = repos.userRepo.GetRecords("*", Convert.ToInt32(repos.userRepo.Count + 1), 0).ToList();
            if (!allUsers.Any())
            {
                //create default admin user
                var user = new User("admin", null, "AdminGroup", false);
                user.SecurityStamp = Guid.NewGuid().ToString();
                user.PasswordHash = new PasswordHasher<User>().HashPassword(user, "admin");
                user.Group = "AdminGroup";

                repos.userRepo.Create(user.NormalizedUserName, user);
            }
             services.AddScoped<RoleGroupManager>(p=> roleGroupManager);
             services.AddScoped<IRepositoryService, RepositoryService>(provider => new RepositoryService(repos.userRepo, roleGroupManager));
             services.AddScoped<AuthenticationStateProvider, RevalidatingIdentityAuthenticationStateProvider<User>>();

        }

        
    }
}
