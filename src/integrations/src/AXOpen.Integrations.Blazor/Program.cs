using axopen_integrations_blazor.Data;
using axopen_integrations;
using AXSharp.Connector;
using AXOpen.Core.blazor.Toaster;
using AXSharp.Presentation.Blazor.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using AXOpen.Data.DependencyInjection;
using static System.Formats.Asn1.AsnWriter;

namespace axopen_integrations_blazor
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            builder.Services.AddRazorPages();
            builder.Services.AddServerSideBlazor();
            builder.Services.AddSingleton<WeatherForecastService>();
            
            builder.Services.AddIxBlazorServices();

            builder.Services.RegisterIxDataServices();
            builder.Services.AddSingleton<ToastService>();

            Entry.Plc.Connector.BuildAndStart();

            Entry.Plc.Connector.ExceptionBehaviour = CommExceptionBehaviour.Ignore;

            Entry.Plc.Connector.SubscriptionMode = AXSharp.Connector.ReadSubscriptionMode.Polling;


            var repository = Ix.Repository.Json.Repository.Factory(new AXOpen.Data.Json.JsonRepositorySettings<Pocos.AxoDataExamples.AxoProductionData>(Path.Combine(Environment.CurrentDirectory, "data", "processdata")));
            var repository2 = Ix.Repository.Json.Repository.Factory(new AXOpen.Data.Json.JsonRepositorySettings<Pocos.AxoDataExamples.AxoTestData>(Path.Combine(Environment.CurrentDirectory, "data", "testdata")));
            //inherited IxProductionData
            //var repository = Ix.Repository.Json.Repository.Factory(new AXOpen.Data.Json.JsonRepositorySettings<Pocos.AxoDataExamples.AxoProductionDataInherited>(Path.Combine(Environment.CurrentDirectory, "data", "processdata")));

            // Entry.Plc.process_data_manager.InitializeRepository(repository);

            Entry.Plc.MainContext.process_data_manager.InitializeRemoteDataExchange(repository);
            Entry.Plc.MainContext.test_data_manager.InitializeRemoteDataExchange(repository2);

            
            Entry.Plc.Integrations.DM.InitializeRemoteDataExchange(Ix.Repository.Json.Repository.Factory(new AXOpen.Data.Json.JsonRepositorySettings<Pocos.IntegrationLightDirect.DataSet>(Path.Combine(Environment.CurrentDirectory, "data", "processdata1"))));

            //<AxoDataExampleDocuIntialization>
            var exampleRepositorySettings =
                new AXOpen.Data.Json.JsonRepositorySettings<Pocos.AxoDataExamplesDocu.AxoProductionData>(
                    Path.Combine(Environment.CurrentDirectory, "exampledata"));

            var exampleRepository = 
                Ix.Repository.Json.Repository.Factory(exampleRepositorySettings);
            
            Entry.Plc.AxoDataExamplesDocu.DataManager.InitializeRemoteDataExchange(exampleRepository);
            //</AxoDataExampleDocuIntialization>

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