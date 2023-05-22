using AxOpen.Security.Entities;
using AxOpen.Security.Stores;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;



namespace AxOpen.Security.Extensions
{
    public static class IdentityBuilderExtensions
    {
        public static IdentityBuilder AddCustomStores(this IdentityBuilder builder)
        {
            builder.Services.AddTransient<IUserStore<User>, UserStore>();
            builder.Services.AddTransient<IRoleStore<Role>, RoleStore>();
            return builder;
        }
    }
}
