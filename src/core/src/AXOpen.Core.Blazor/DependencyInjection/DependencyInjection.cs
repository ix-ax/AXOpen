using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoAlertDialog;
using AXOpen.Core.Blazor.AxoDialogs;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.ResponseCompression;
using Microsoft.Extensions.DependencyInjection;
using Operon.Components.Toast;


namespace AXOpen.Core
{
    public static class DependencyInjection
    {
        public static void AddAxoCoreServices(this IServiceCollection services)
        {
            services.AddSingleton<AxoDialogAndAlertContainer>();
            services.AddScoped<IToastService, ToastService>();


            services.AddResponseCompression(opts =>
            {
                opts.MimeTypes = ResponseCompressionDefaults.MimeTypes.Concat(
                      new[] { "application/octet-stream" });
            });
        }

    }
}
