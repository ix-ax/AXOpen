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
using Microsoft.AspNetCore.Components.Authorization;

namespace AxOpen.Security.Services
{
    public static class ServicesConfiguration
    {
        public static void ConfigureAxBlazorSecurity(this IServiceCollection services,
            (IRepository<User> userRepo, IRepository<Group> groupRepo) repos,
            List<Role>? roles = null, bool addAllRolesToAdminGroup = false)
        {
            services.AddTransient<IUserStore<User>, UserStore>();
            services.AddTransient<IRoleStore<Role>, RoleStore>();

            services.ConfigureApplicationCookie(options =>
                        {
                            options.Cookie.HttpOnly = true;
                            options.SlidingExpiration = true;
                            options.ExpireTimeSpan = TimeSpan.FromDays(1);
                        });

            services.AddScoped<AuthenticationStateProvider, IdentityRevalidatingAuthenticationStateProvider>();

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
                if (addAllRolesToAdminGroup)
                {
                    List<string> currentAdminRoles = roleGroupManager.GetRolesFromGroup("AdminGroup").Where(c => !c.Equals("Administrator")).ToList();
                    List<string?>? requiredAdminRoles = roles.Select(c => c.Name).ToList();
                    List<string?>? adminRolesToAdd = requiredAdminRoles?.Where(p => currentAdminRoles.All(p2 => p2 != p)).ToList();
                    List<string>? adminRolesToRemove = currentAdminRoles?.Where(p => requiredAdminRoles.All(p2 => p2 != p)).ToList();

                    roleGroupManager.AddRolesToGroup("AdminGroup", adminRolesToAdd);
                    roleGroupManager.RemoveRolesFromGroup("AdminGroup", adminRolesToRemove);
                }
            }

            //services.AddScoped<AuthenticationStateProvider, RevalidatingIdentityAuthenticationStateProvider<IdentityUser>>();
            services.AddScoped<IRepositoryService, RepositoryService>(provider => new RepositoryService(repos.userRepo, roleGroupManager));
        }
    }
}