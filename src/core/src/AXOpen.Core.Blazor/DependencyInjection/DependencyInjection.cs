using AXOpen.Base.Abstractions.Dialogs;
using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoAlertDialog;
using AXOpen.Core.Blazor.AxoDialogs;
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
            services.AddSingleton<AxoAlertDialogProxyService>();
            services.AddResponseCompression(opts =>
            {
                opts.MimeTypes = ResponseCompressionDefaults.MimeTypes.Concat(
                      new[] { "application/octet-stream" });
            });
        }

    }
}
