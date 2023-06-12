using AXSharp.Presentation.Blazor.Controls.Dialogs.ActionDialog;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Core.Blazor.Dialogs.ActionDialog
{
    public static class TcoCoreExtensionServices
    {
        public static void AddTcoCoreExtensions(this IServiceCollection services)
        {
            //sservices.AddBlazm();
            services.AddScoped<JsInteropDialog>();
        }
    }
}
