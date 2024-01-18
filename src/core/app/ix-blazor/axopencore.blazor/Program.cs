using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using System.Reflection;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Services;
using AXOpen;
using AXOpen.Data.Json;
using axopen_integrations_blazor.Data;
using AXOpen.Logging;
using Serilog;
using AXOpen.Core;
using axopencore;
using AXOpen.Base.Data;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AxOpen.Security;
using AxOpen.Security.Services;
using AxOpen.Security.Entities;

namespace axopen_integrations_blazor
{
    public class Program
    {
        public static async Task Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.ConfigureAxBlazorSecurity(PrepareUserRepository(), axopen_integrations_blazor.Roles.CreateRoles());
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
            app.MapHub<SignalRDialogHub>(AXOpen.Core.Blazor.AxoDialogs.Hubs.SignalRDialogHub.HUB_URL_SUFFIX);
            app.MapFallbackToPage("/_Host");

            #region InitializeRemoteTask

            Entry.Plc.AxoRemoteTasks._remoteTask.Initialize(() => Console.WriteLine($"Remote task executed PLC sent this string: '{Entry.Plc.AxoRemoteTasks._remoteTask.Message.GetAsync().Result}'"));

            #endregion InitializeRemoteTask

            app.Run();
        }
        private static (IRepository<User>, IRepository<Group>) PrepareUserRepository()
        {
            var repoPath = Environment.GetEnvironmentVariable("AX_JSON_REPOSITORY");

            if (!Directory.Exists(repoPath))
            {
                Directory.CreateDirectory(repoPath);
            }

            IRepository<User> userRepo = new JsonRepository<User>(new JsonRepositorySettings<User>(Path.Combine(repoPath, "Users")));
            IRepository<Group> groupRepo = new JsonRepository<Group>(new JsonRepositorySettings<Group>(Path.Combine(repoPath, "Groups")));

            return (userRepo, groupRepo);
        }
    }

    internal static class Roles
    {
        public static List<Role> CreateRoles()
        {
            var roles = new List<Role>
        {
            new Role(process_settings_access),
            new Role(process_traceability_access),
            new Role(can_run_ground_mode),
            new Role(can_run_automat_mode),
            new Role(can_run_service_mode),
            new Role(can_skip_steps_in_sequence),
        };

            return roles;
        }

        public const string can_run_ground_mode = nameof(can_run_ground_mode);
        public const string can_run_automat_mode = nameof(can_run_automat_mode);
        public const string can_run_service_mode = nameof(can_run_service_mode);
        public const string process_settings_access = nameof(process_settings_access);
        public const string process_traceability_access = nameof(process_traceability_access);
        public const string can_skip_steps_in_sequence = nameof(can_skip_steps_in_sequence);
    }
}