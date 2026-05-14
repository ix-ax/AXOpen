using AXOpen;
using AXOpen.Core;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Base.Data;
using AXOpen.Data;
using AXOpen.Data.Json;
using AXOpen.Logging;
using AxOpen.Security;
using AxOpen.Security.Entities;
using AxOpen.Security.Services;
using AXSharp.Connector;
using AXOpen.VisualComposer;
using AXSharp.Presentation.Blazor.Services;
using Serilog;
using showcase;
using showcase.Services;
using showcase.blazor.Templates;
using System.Reflection;

var builder = WebApplication.CreateBuilder(args);

builder.Services.ConfigureAxBlazorSecurity(SetUpJsonSecurity(), Roles.CreateRoles());
builder.Services.AddLocalization();
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
//<AddBlazorServices>
builder.Services.AddIxBlazorServices();
builder.Services.AddAxoCoreServices();
builder.Services.AddVisualComposerService();
//</AddBlazorServices>
builder.Services.AddSingleton<CodeSnippetProvider>();
builder.Services.AddSingleton<DocFxMarkdownProcessor>(sp =>
    new DocFxMarkdownProcessor(sp.GetRequiredService<CodeSnippetProvider>().BasePath));
builder.Services.AddSingleton<ComponentMaturityService>();
builder.Services.AddSingleton<showcase.Services.Search.ContentIndexService>();
builder.Services.AddSingleton<showcase.Services.Search.ShowcaseSearchService>();
//<KeyenceIv3HttpClient>
builder.Services.AddHttpClient();
//</KeyenceIv3HttpClient>





//<ConnectorConfiguration>
Entry.Plc.Connector.SubscriptionMode = ReadSubscriptionMode.Polling;
Entry.Plc.Connector.BuildAndStart().ReadWriteCycleDelay = 250;
Entry.Plc.Connector.ExceptionBehaviour = CommExceptionBehaviour.ReThrow;

Entry.Plc.Connector.SetLoggerConfiguration(new LoggerConfiguration()
    .WriteTo.Console()
    .WriteTo.File("connector.log",
        outputTemplate: "{Timestamp:yyyy-MMM-dd HH:mm:ss} [{Level}] {Message}{NewLine}{Exception}",
        fileSizeLimitBytes: 100000)
    .MinimumLevel.Information()
    .CreateLogger());

_ = Entry.Plc.Connector.IdentityProvider.ConstructIdentitiesAsync();
//</ConnectorConfiguration>

//<AxoApplicationBuilder>
AxoApplication.CreateBuilder().ConfigureLogger(new SerilogLogger(new LoggerConfiguration()
    .WriteTo.Console().MinimumLevel.Verbose()
    .CreateLogger()));
//</AxoApplicationBuilder>

//<AxoLoggerStartDequeuing>
// AxoLogger — forward PLC log entries to .NET Serilog logger
Entry.Plc.Ctx.AxoLoggers.LoggerOne.StartDequeuing(
    new SerilogLogger(new LoggerConfiguration().WriteTo.Console().MinimumLevel.Verbose().CreateLogger()), 250);
//</AxoLoggerStartDequeuing>

//<AxoRemoteTaskInitialize>
// AxoRemoteTask — wire .NET handler for PLC remote invocation.
// Without this, the PLC task enters error state ("REMOTE TASK IS NOT INITIALIZED").
Entry.Plc.Ctx.AxoRemoteTasks._remoteTask.Initialize(() =>
{
    Console.WriteLine($"Remote task executed: {Entry.Plc.Ctx.AxoRemoteTasks._remoteTask.Message.LastValue}");
});
//</AxoRemoteTaskInitialize>

// ---- Data Exchange Initialization ----
var jsonRepoDir = Path.GetFullPath(
    Path.Combine(new FileInfo(Assembly.GetExecutingAssembly().Location).Directory!.FullName, "..", "JSONREPOS"));
if (!Directory.Exists(jsonRepoDir)) Directory.CreateDirectory(jsonRepoDir);

// AxoDataExchange
IRepository<Pocos.AxoDataExchangeExample.AxoProcessData> axoProcessDataRepository =
    new JsonRepositorySettings<Pocos.AxoDataExchangeExample.AxoProcessData>(
        Path.Combine(jsonRepoDir, "ProcessData")).Factory();
Entry.Plc.Ctx.AxoDataExchangeContext.DataManager.InitializeRemoteDataExchange(axoProcessDataRepository);

// AxoDataFragmentExchange
IRepository<Pocos.AxoDataFramentsExchangeExample.SharedDataHeaderData> sharedDataHeaderRepo =
    new JsonRepositorySettings<Pocos.AxoDataFramentsExchangeExample.SharedDataHeaderData>(
        Path.Combine(jsonRepoDir, "SharedDataHeader")).Factory();
IRepository<Pocos.AxoDataFramentsExchangeExample.Station_1_Data> station1DataRepo =
    new JsonRepositorySettings<Pocos.AxoDataFramentsExchangeExample.Station_1_Data>(
        Path.Combine(jsonRepoDir, "Station_1")).Factory();

var axoFragmentDataManager = Entry.Plc.Ctx.AxoDataFragmentsExchangeContext.DataManager
    .CreateDataFragments<AxoDataFramentsExchangeExample.AxoProcessDataManager>();
axoFragmentDataManager.SharedHeader.SetRepository(sharedDataHeaderRepo);
axoFragmentDataManager.Station_1.SetRepository(station1DataRepo);
axoFragmentDataManager.InitializeRemoteDataExchange();

// AxoDataPersistentExchange
IRepository<AXOpen.Data.PersistentRecord> persistentRepository =
    new JsonRepositorySettings<AXOpen.Data.PersistentRecord>(
        Path.Combine(jsonRepoDir, "PersistentData")).Factory();
Entry.Plc.Ctx.AxoDataPersistentContext.DataManager.InitializeRemoteDataExchange(
    Entry.Plc.Ctx.AxoDataPersistentContext.PersistentRootObject,
    persistentRepository);

// Clean temp directory
AXOpen.Data.IAxoDataExchange.CleanUp();

// AxoDataDistributed
IRepository<Pocos.AxoDataDistributedExample.SharedHeader_Data> distributedHeaderRepo =
    new JsonRepositorySettings<Pocos.AxoDataDistributedExample.SharedHeader_Data>(
        Path.Combine(jsonRepoDir, "DistributedHeader")).Factory();
IRepository<Pocos.AxoDataDistributedExample.Station_Data> distributedStationRepo =
    new JsonRepositorySettings<Pocos.AxoDataDistributedExample.Station_Data>(
        Path.Combine(jsonRepoDir, "DistributedStation")).Factory();

Entry.Plc.Ctx.AxoDataDistributedContext.ControlledUnit_1.EntityHeader.SetRepository(distributedHeaderRepo);
Entry.Plc.Ctx.AxoDataDistributedContext.ControlledUnit_2.EntityHeader.SetRepository(distributedHeaderRepo);
Entry.Plc.Ctx.AxoDataDistributedContext.ControlledUnit_1.ProcessData.SetRepository(distributedStationRepo);
Entry.Plc.Ctx.AxoDataDistributedContext.ControlledUnit_2.ProcessData.SetRepository(distributedStationRepo);

Entry.Plc.Ctx.AxoDataDistributedContext.ControlledUnit_1.EntityHeader.InitializeRemoteDataExchange();
Entry.Plc.Ctx.AxoDataDistributedContext.ControlledUnit_2.EntityHeader.InitializeRemoteDataExchange();
Entry.Plc.Ctx.AxoDataDistributedContext.ControlledUnit_1.ProcessData.InitializeRemoteDataExchange();
Entry.Plc.Ctx.AxoDataDistributedContext.ControlledUnit_2.ProcessData.InitializeRemoteDataExchange();

// Distributed data services
var distributedDataService = new DistributedDataExchangeService();
builder.Services.AddSingleton<IDistributedDataExchangeService>(distributedDataService);

var exchangeConfigurationService = new AxoDataExchangeConfigurationService();
builder.Services.AddSingleton<IAxoDataExchangeConfigurationService>(exchangeConfigurationService);

distributedDataService.CollectAxoDataExchanges(Entry.Plc.Ctx.AxoDataDistributedContext.ControlledUnit_1);
distributedDataService.CollectAxoDataExchanges(Entry.Plc.Ctx.AxoDataDistributedContext.ControlledUnit_2);

distributedDataService.SetPrioritizedType(typeof(Pocos.AxoDataDistributedExample.SharedHeader_Data));
distributedDataService.SortGroupsByPriorizedTypes();

exchangeConfigurationService.AddConfiguration<Pocos.AxoDataDistributedExample.SharedHeader_Data>(
    suffix: "",
    configAction: a =>
    {
        a.AddColumn("Global Result", x => x.HeaderGlogalPass, true, typeof(CustomBoolTemplate))
         .AddColumn("Index", x => x.HeaderIndex, false, typeof(CustomIntTemplate))
         .EnableSorting()
         .AddSorting(x => x.HeaderPartialName);
    });

exchangeConfigurationService.AddConfiguration<Pocos.AxoDataDistributedExample.Station_Data>(
    suffix: "",
    configAction: a =>
    {
        a.AddColumn("Station Result", x => x.StationPass, true, typeof(CustomBoolTemplate))
         .AddColumn("Name", x => x.StationName, true, null)
         .AddColumn("Operation", x => x.StaionOperation, true, null)
         .EnableSorting();
    });

var app = builder.Build();

//<KeyenceIv3ReverseProxy>
app.Use(async (context, next) =>
{
    var keyenceComponent = Entry.Plc.Ctx.keyence_vision_documentation.axo_IV3.Component; // Replace with your actual component instance.
    await keyenceComponent.ConfigureProxy(context, next);
});
//</KeyenceIv3ReverseProxy>

// Initialize content search index (fire-and-forget, non-blocking)
_ = app.Services.GetRequiredService<showcase.Services.Search.ContentIndexService>().InitializeAsync();

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();
app.MapAdditionalIdentityEndpoints();
app.MapBlazorHub();
//<MapDialogHub>
// SignalR hub for dialog/alert cross-client synchronization
app.MapHub<SignalRDialogHub>(SignalRDialogHub.HUB_URL_SUFFIX);
//</MapDialogHub>
app.MapFallbackToPage("/_Host");
app.Run();

static (IRepository<User>, IRepository<Group>) SetUpJsonSecurity(string path = "JSONREPOS")
{
    var dir = Path.GetFullPath(
        Path.Combine(new FileInfo(Assembly.GetExecutingAssembly().Location).Directory!.FullName, "..", path));
    if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);

    return (new JsonRepository<User>(new JsonRepositorySettings<User>(Path.Combine(dir, "Users"))),
            new JsonRepository<Group>(new JsonRepositorySettings<Group>(Path.Combine(dir, "Groups"))));
}

public static class Roles
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

        // Add all roles from AXOpen.Data
        foreach (var item in typeof(AXOpen.Data.DataExchangeRoleNames)
            .GetFields(BindingFlags.Public | BindingFlags.Static)
            .Where(f => f.FieldType == typeof(string)))
        {
            roles.Add(new Role(item.Name));
        }

        return roles;
    }

    public const string can_run_ground_mode = nameof(can_run_ground_mode);
    public const string can_run_automat_mode = nameof(can_run_automat_mode);
    public const string can_run_service_mode = nameof(can_run_service_mode);
    public const string process_settings_access = nameof(process_settings_access);
    public const string process_traceability_access = nameof(process_traceability_access);
    public const string can_skip_steps_in_sequence = nameof(can_skip_steps_in_sequence);
}
