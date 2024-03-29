using AXOpen;
using axopen_integrations_blazor.Data;
using axopen_integrations;
using AXSharp.Connector;
using AXOpen.Data.Json;
using AXOpen.Logging;
using AXSharp.Presentation.Blazor.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Pocos.IntegrationAxoDataFramentsExchange;
using Serilog;
using AXOpen.Core;

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

            var repository = AXOpen.Data.Json.Repository.Factory(new AXOpen.Data.Json.JsonRepositorySettings<Pocos.AxoDataExamples.AxoProductionData>(Path.Combine(Environment.CurrentDirectory, "data", "processdata")));
            var repository2 = AXOpen.Data.Json.Repository.Factory(new AXOpen.Data.Json.JsonRepositorySettings<Pocos.AxoDataExamples.AxoTestData>(Path.Combine(Environment.CurrentDirectory, "data", "testdata")));
            //inherited IxProductionData
            //var repository = Ix.Repository.Json.Repository.Factory(new AXOpen.Data.Json.JsonRepositorySettings<Pocos.AxoDataExamples.AxoProductionDataInherited>(Path.Combine(Environment.CurrentDirectory, "data", "processdata")));

            // Entry.Plc.process_data_manager.InitializeRepository(repository);

            Entry.Plc.MainContext.process_data_manager.InitializeRemoteDataExchange(repository);
            Entry.Plc.MainContext.test_data_manager.InitializeRemoteDataExchange(repository2);


            Entry.Plc.Integrations.DM
                .InitializeRemoteDataExchange(
                   AXOpen.Data.Json.
                        Repository.Factory
                            (new AXOpen.Data.Json.JsonRepositorySettings<Pocos.IntegrationLightDirect.DataSet>(Path.Combine(Environment.CurrentDirectory, "data", "processdata1"))));

            var pdfBuilder =
                Entry.Plc.Integrations.DataFragmentContext.PD.CreateBuilder<IntegrationAxoDataFramentsExchange.ProcessData>();

            pdfBuilder.Set.SetRepository(new JsonRepository<Pocos.IntegrationAxoDataFramentsExchange.SharedProductionData>(
                new AXOpen.Data.Json.JsonRepositorySettings<Pocos.IntegrationAxoDataFramentsExchange.SharedProductionData>(Path.Combine(Environment.CurrentDirectory, "bin", "data-framents", "set"))));
            pdfBuilder.Manip.SetRepository(
                new JsonRepository<Pocos.IntegrationAxoDataFramentsExchange.FragmentProcessData>(new AXOpen.Data.Json.JsonRepositorySettings<Pocos.IntegrationAxoDataFramentsExchange.FragmentProcessData>(Path.Combine(Environment.CurrentDirectory, "bin", "data-framents", "fm"))));


            //<AxoDataExampleDocuIntialization>
            var exampleRepositorySettings =
                new AXOpen.Data.Json.JsonRepositorySettings<Pocos.AxoDataExamplesDocu.AxoProductionData>(
                    Path.Combine(Environment.CurrentDirectory, "exampledata"));

            var exampleRepository =
                AXOpen.Data.Json.Repository.Factory(exampleRepositorySettings);

            Entry.Plc.AxoDataExamplesDocu.DataManager.InitializeRemoteDataExchange(exampleRepository);
            //</AxoDataExampleDocuIntialization>


            //<AxoDataFragmentedExampleDocuIntialization>

            var scatteredDataBuilder =
                Entry.Plc.AxoDataFragmentExchangeContext.ProcessData.CreateBuilder<AxoDataFramentsExchangeDocuExample.ProcessDataManager>();

            // Setting up repositories
            scatteredDataBuilder.SharedHeader.SetRepository(new JsonRepository<Pocos.AxoDataFramentsExchangeDocuExample.SharedDataHeaderData>(
                new AXOpen.Data.Json.JsonRepositorySettings<Pocos.AxoDataFramentsExchangeDocuExample.SharedDataHeaderData>(Path.Combine(Environment.CurrentDirectory, "bin", "data-framents-docu", "set"))));
            scatteredDataBuilder.Station_1.SetRepository(
                new JsonRepository<Pocos.AxoDataFramentsExchangeDocuExample.Station_1_Data>(
                    new AXOpen.Data.Json.JsonRepositorySettings<Pocos.AxoDataFramentsExchangeDocuExample.Station_1_Data>(Path.Combine(Environment.CurrentDirectory, "bin", "data-framents", "fm"))));
            //</AxoDataFragmentedExampleDocuIntialization>


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
            Entry.Plc.AxoLoggers.LoggerTwo.StartDequeuing(AxoApplication.Current.Logger, 250); 
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

            app.MapBlazorHub();
            app.MapFallbackToPage("/_Host");

            #region InitializeRemoteTask
            Entry.Plc.AxoRemoteTasks._remoteTask.Initialize(() => Console.WriteLine($"Remote task executed PLC sent this string: '{Entry.Plc.AxoRemoteTasks._remoteTask.Message.GetAsync().Result}'"));
            #endregion

            app.Run();



        }
    }
}