using AXOpen.Core.Blazor.AxoDialogs;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using BlazorBootstrap;
using Humanizer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.ResponseCompression;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Diagnostics.Metrics;
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
            services.AddResponseCompression(opts =>
            {
                opts.MimeTypes = ResponseCompressionDefaults.MimeTypes.Concat(
                      new[] { "application/octet-stream" });
            });

            //services.UseResponseCompression();


            //services.MapHub<ChatHub>("/chathub");
            services.AddBlazorBootstrap(); // Add this line
        }

    }
}
