using AxOpen.Security.Entities;
using AxOpen.Security.Stores;
using AXOpen.Base.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen;


namespace AxOpen.Security.Services
{
    public static class ServicesConfiguration
    {
        public static void ConfigureAxBlazorSecurity(this IServiceCollection services,
            (IRepository<User> userRepo, IRepository<Group> groupRepo) repos,
            List<Role>? roles = null)
        {
            services.AddTransient<IUserStore<User>, UserStore>();
            services.AddTransient<IRoleStore<Role>, RoleStore>();

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
            .AddDefaultTokenProviders();

            
            RoleGroupManager roleGroupManager = new RoleGroupManager(repos.groupRepo);
            if (roles != null)
            {
                roleGroupManager.CreateRoles(roles);
            }

            services.AddScoped<IRepositoryService, RepositoryService>(provider => new RepositoryService(repos.userRepo, roleGroupManager));
        }
    }
}
