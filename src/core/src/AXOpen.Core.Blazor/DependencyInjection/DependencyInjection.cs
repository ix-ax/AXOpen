using AXOpen.Core.Blazor.AxoDialogs;
using BlazorBootstrap;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core
{
    public static class DependencyInjection
    {
        public static void AddAxoCoreServices(this IServiceCollection services)
        {
            services.AddSingleton<AxoDialogProxyService>();
            services.AddBlazorBootstrap(); // Add this line
        }
    }
}
