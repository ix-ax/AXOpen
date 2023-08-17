using AXOpen;
using axopen_components_cognex_vision_integrations;
using AXSharp.Connector;
using AXOpen.Data.Json;
using AXOpen.Logging;
using AXSharp.Presentation.Blazor.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Serilog;
using AXOpen.Core;

namespace axopen_components_cognex_vision_integrations_blazor
{
    public class Program
    {
        public static async Task Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddRazorPages();
            builder.Services.AddServerSideBlazor();
            builder.Services.AddAxoCoreServices();
            builder.Services.AddIxBlazorServices();


            AxoApplication.CreateBuilder().ConfigureLogger(new SerilogLogger(new LoggerConfiguration()
                .WriteTo.Console().MinimumLevel.Debug()
                .CreateLogger()));

            Entry.Plc.Connector.SetLoggerConfiguration(new LoggerConfiguration()
                                                        .WriteTo
                                                        .Console()
                                                        .WriteTo
                                                        .File($"connector.log",
                                                            outputTemplate: "{Timestamp:yyyy-MMM-dd HH:mm:ss} [{Level}] {Message}{NewLine}{Exception}",
                                                            fileSizeLimitBytes: 100000)
                                                        .MinimumLevel.Debug()
                                                        .CreateLogger());

            Entry.Plc.Connector.ReadWriteCycleDelay = 250;
            Entry.Plc.Connector.BuildAndStart();

            Entry.Plc.Connector.ExceptionBehaviour = CommExceptionBehaviour.Ignore;



            Entry.Plc.Connector.SubscriptionMode = AXSharp.Connector.ReadSubscriptionMode.Polling;

            await Entry.Plc.Connector.IdentityProvider.ConstructIdentitiesAsync();
            //<AxoAppBuilder>
            var axoAppBuilder = AxoApplication.CreateBuilder();
            //</AxoAppBuilder>


            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            app.UseHttpsRedirection();

            app.UseStaticFiles();

            app.UseRouting();

            app.MapBlazorHub();
            app.MapFallbackToPage("/_Host");

            app.Run();



        }
    }
}