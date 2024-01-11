using AXOpen;
using axopen_integrations_blazor.Data;
using AXSharp.Connector;
using AXOpen.Data.Json;
using AXOpen.Logging;
using AXSharp.Presentation.Blazor.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Serilog;
using AXOpen.Core;
using axopencore;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;

namespace axopen_integrations_blazor
{
    public class Program
    {
        public static async Task Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddRazorPages();
            builder.Services.AddServerSideBlazor();
            builder.Services.AddSingleton<WeatherForecastService>();
            builder.Services.AddAxoCoreServices();
            builder.Services.AddIxBlazorServices();
            builder.Services.AddLocalization();

            //builder.Services.AddScoped<IAlertDialogService, ToasterService>();

            //builder.Services.AddTcoCoreExtensions();

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

            //<AxoLoggerConfiguration>

            // Creates serilog logger with single sink to Console window.
            
            axoAppBuilder.ConfigureLogger(new SerilogLogger(new LoggerConfiguration()
                .WriteTo.Console().MinimumLevel.Verbose()
                .CreateLogger()));
            //</AxoLoggerConfiguration>

            //<AxoLoggerInitialization>
            Entry.Plc.AxoLoggers.LoggerOne.StartDequeuing(AxoApplication.Current.Logger, 250);
            //</AxoLoggerInitialization>



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

            var supportedCultures = new[] { "en-US", "sk-SK", "es-ES" };
            var localizationOptions = new RequestLocalizationOptions()
                .AddSupportedCultures(supportedCultures)
                .AddSupportedUICultures(supportedCultures);

            app.UseRequestLocalization(localizationOptions);


            app.MapBlazorHub();
            app.MapHub<DialogHub>("/dialoghub");
            app.MapFallbackToPage("/_Host");

            #region InitializeRemoteTask
            Entry.Plc.AxoRemoteTasks._remoteTask.Initialize(() => Console.WriteLine($"Remote task executed PLC sent this string: '{Entry.Plc.AxoRemoteTasks._remoteTask.Message.GetAsync().Result}'"));
            #endregion

            app.Run();



        }
    }
}