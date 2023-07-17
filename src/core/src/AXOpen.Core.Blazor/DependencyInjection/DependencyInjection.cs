using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoAlertDialog;
using AXOpen.Core.Blazor.AxoDialogs;
using BlazorBootstrap;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.ResponseCompression;
using Microsoft.Extensions.DependencyInjection;


namespace AXOpen.Core
{
    public static class DependencyInjection
    {
        public static void AddAxoCoreServices(this IServiceCollection services)
        {
            services.AddSingleton<AxoDialogContainer>();
            services.AddScoped<IAlertDialogService, AxoAlertDialogService>();
            //services.AddSingleton<IAxoDialogProxyServiceSingleton, AxoDialogProxyService>();
            services.AddResponseCompression(opts =>
            {
                opts.MimeTypes = ResponseCompressionDefaults.MimeTypes.Concat(
                      new[] { "application/octet-stream" });
            });

          
            services.AddBlazorBootstrap(); // Add this line
        }

    }
}
