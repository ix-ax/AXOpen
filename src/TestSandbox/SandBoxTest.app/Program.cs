using AxOpen.Security;
using AxOpen.Security.Entities;
using AxOpen.Security.Services;
using AXOpen;
using AXOpen.Base.Data;
using AXOpen.Core;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Data;
using AXOpen.Data.Json;
using AXOpen.Logging;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Services;
using sandboxtest;
using Serilog;
using System.Reflection;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.ConfigureAxBlazorSecurity(SetUpJSon(), Roles.CreateRoles());
builder.Services.AddLocalization();
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddIxBlazorServices();
builder.Services.AddAxoCoreServices();
//builder.Services.AddScoped<IAlertDialogService, ToasterService>();

Entry.Plc.Connector.ExceptionBehaviour = CommExceptionBehaviour.ReThrow;
Entry.Plc.Connector.SubscriptionMode = ReadSubscriptionMode.Polling;
Entry.Plc.Connector.BuildAndStart().ReadWriteCycleDelay = 50;
Entry.Plc.Connector.ConcurrentRequestMaxCount = 5;
Entry.Plc.Connector.ConcurrentRequestDelay = 25;
Entry.Plc.Connector.SetLoggerConfiguration(new LoggerConfiguration()
    .WriteTo
    .Console()
    .WriteTo
    .File($"connector.log",
        outputTemplate: "{Timestamp:yyyy-MMM-dd HH:mm:ss} [{Level}] {Message}{NewLine}{Exception}",
        fileSizeLimitBytes: 100000)
    .MinimumLevel.Information()
    .CreateLogger());
await Entry.Plc.Connector.IdentityProvider.ConstructIdentitiesAsync();

AxoApplication.CreateBuilder().ConfigureLogger(new SerilogLogger(new LoggerConfiguration()
    .WriteTo.Console().MinimumLevel.Verbose()
    .CreateLogger()));

// cd "C:\Program Files\MongoDB\Server\3.6\bin"
// mongod.exe  --dbpath D:\DATA\DB\axopen\ --auth --port 27017
var credentials = new AXOpen.Data.MongoDb.MongoDbCredentials("admin", "user", "user");

// process data a zdielane data
var sharedProcessSettings =
    new AXOpen.Data.MongoDb.MongoDbRepository<Pocos.sandboxtest.SharedProductionData>(new AXOpen.Data.MongoDb.MongoDbRepositorySettings<Pocos.sandboxtest.SharedProductionData>(
    connectionString: "mongodb://localhost:27017",
    databaseName: "AxOpenTest",
    collectionName: "SharedHeaders",
    credentials: credentials));

var ProcessSettings_Cus =
    new AXOpen.Data.MongoDb.MongoDbRepository<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>(new AXOpen.Data.MongoDb.MongoDbRepositorySettings<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>(
    connectionString: "mongodb://localhost:27017",
    databaseName: "AxOpenTest",
    collectionName: "ProcessSettings_Cus",
    credentials: credentials));

var processData = new List<IRepository<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>>();

for (int i = 1; i <= 8; i++)
{
    processData.Add(
        new AXOpen.Data.MongoDb.MongoDbRepository<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>(new AXOpen.Data.MongoDb.MongoDbRepositorySettings<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>(
        connectionString: "mongodb://localhost:27017",
        databaseName: "AxOpenTest",
        collectionName: $"ProcessSettings_Cu{i}",
        credentials: credentials)));
}

// production data ...

var productionData = new List<IRepository<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>>();

for (int i = 1; i <= 8; i++)
{
    productionData.Add(
        new AXOpen.Data.MongoDb.MongoDbRepository<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>(new AXOpen.Data.MongoDb.MongoDbRepositorySettings<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>(
        connectionString: "mongodb://localhost:27017",
        databaseName: "AxOpenTest",
        collectionName: $"productionDataRepository_Cu{i}",
        credentials: credentials)));
}

var productionsharedData =
    new AXOpen.Data.MongoDb.MongoDbRepository<Pocos.sandboxtest.SharedProductionData>(new AXOpen.Data.MongoDb.MongoDbRepositorySettings<Pocos.sandboxtest.SharedProductionData>(
    connectionString: "mongodb://localhost:27017",
    databaseName: "AxOpenTest",
    collectionName: "productionSharedHeaders",
    credentials: credentials));

// CU1 INSTACE
var CuInst_1 = Entry.Plc.Context.ProcessDataCu_1.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_2 = Entry.Plc.Context.ProcessDataCu_2.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_3 = Entry.Plc.Context.ProcessDataCu_3.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_4 = Entry.Plc.Context.ProcessDataCu_4.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_5 = Entry.Plc.Context.ProcessDataCu_5.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_6 = Entry.Plc.Context.ProcessDataCu_6.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_7 = Entry.Plc.Context.ProcessDataCu_7.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_8 = Entry.Plc.Context.ProcessDataCu_8.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();

CuInst_1.Shared.SetRepository(productionsharedData);
CuInst_2.Shared.SetRepository(productionsharedData);
CuInst_3.Shared.SetRepository(productionsharedData);
CuInst_4.Shared.SetRepository(productionsharedData);
CuInst_5.Shared.SetRepository(productionsharedData);
CuInst_6.Shared.SetRepository(productionsharedData);
CuInst_7.Shared.SetRepository(productionsharedData);
CuInst_8.Shared.SetRepository(productionsharedData);

CuInst_1.DataManger.SetRepository(productionData[0]);
CuInst_2.DataManger.SetRepository(productionData[1]);
CuInst_3.DataManger.SetRepository(productionData[2]);
CuInst_4.DataManger.SetRepository(productionData[3]);
CuInst_5.DataManger.SetRepository(productionData[4]);
CuInst_6.DataManger.SetRepository(productionData[5]);
CuInst_7.DataManger.SetRepository(productionData[6]);
CuInst_8.DataManger.SetRepository(productionData[7]);

List<sandboxtest.StandardControlUnit.FragmentProcessDataManger> FragmentManagers = new();
List<SharedProductionDataManager> ShagedManagers = new();

FragmentManagers.Add(CuInst_1.DataManger);
FragmentManagers.Add(CuInst_2.DataManger);
FragmentManagers.Add(CuInst_3.DataManger);
FragmentManagers.Add(CuInst_4.DataManger);
FragmentManagers.Add(CuInst_5.DataManger);
FragmentManagers.Add(CuInst_6.DataManger);
FragmentManagers.Add(CuInst_7.DataManger);
FragmentManagers.Add(CuInst_8.DataManger);

ShagedManagers.Add(CuInst_1.Shared);
ShagedManagers.Add(CuInst_2.Shared);
ShagedManagers.Add(CuInst_3.Shared);
ShagedManagers.Add(CuInst_4.Shared);
ShagedManagers.Add(CuInst_5.Shared);
ShagedManagers.Add(CuInst_6.Shared);
ShagedManagers.Add(CuInst_7.Shared);
ShagedManagers.Add(CuInst_8.Shared);

await CuInst_1.InitializeRemoteDataExchange();
await CuInst_2.InitializeRemoteDataExchange();
await CuInst_3.InitializeRemoteDataExchange();
await CuInst_4.InitializeRemoteDataExchange();
await CuInst_5.InitializeRemoteDataExchange();
await CuInst_6.InitializeRemoteDataExchange();
await CuInst_7.InitializeRemoteDataExchange();
await CuInst_8.InitializeRemoteDataExchange();

// INICIALIZACIA HLAVNYCH PROCESNYCH DAT NA KORENI CONTEXTU
var EntireProcessData = Entry.Plc.Context.EntireProcessData.CreateBuilder<sandboxtest.EntireProcessDataManager>();

await EntireProcessData.InitializeRemoteDataExchange();

EntireProcessData.Set.SetRepository(sharedProcessSettings);
EntireProcessData.Cu1.SetRepository(processData[0]);
EntireProcessData.Cu2.SetRepository(processData[1]);
EntireProcessData.Cu3.SetRepository(processData[2]);
EntireProcessData.Cu4.SetRepository(processData[3]);
EntireProcessData.Cu5.SetRepository(processData[4]);
EntireProcessData.Cu6.SetRepository(processData[5]);
EntireProcessData.Cu7.SetRepository(processData[6]);
EntireProcessData.Cu8.SetRepository(processData[7]);

// INICIALIZACIA HLAVNYCH produkcnyh DAT NA KORENI CONTEXTU
var EntireProductionData = Entry.Plc.Context.EntireProductionData.CreateBuilder<sandboxtest.EntireProcessDataManager>();

await EntireProductionData.InitializeRemoteDataExchange();

EntireProductionData.Set.SetRepository(productionsharedData);
EntireProductionData.Cu1.SetRepository(productionData[0]);
EntireProductionData.Cu2.SetRepository(productionData[1]);
EntireProductionData.Cu3.SetRepository(productionData[2]);
EntireProductionData.Cu4.SetRepository(productionData[3]);
EntireProductionData.Cu5.SetRepository(productionData[4]);
EntireProductionData.Cu6.SetRepository(productionData[5]);
EntireProductionData.Cu7.SetRepository(productionData[6]);
EntireProductionData.Cu8.SetRepository(productionData[7]);

// Clean Temp directory
IAxoDataExchange.CleanUp();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    //app.UseMigrationsEndPoint();
}
else
{
    app.UseExceptionHandler("/Error");
    // use response compression only in production mode
    app.UseResponseCompression();
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

//_ = Task.Run(async () =>
//{
    //while (true)
    //{
    //    List<Task> tasks = new List<Task>();

    //    tasks.Clear();

    //    foreach (var cuManager in Entry.Plc.Context.GetChildren().OfType<AxoDataFragmentExchange>())
    //    {
    //        tasks.Add(cuManager.RemoteCreateOrUpdate("produced"));
    //    }

    //    await Task.WhenAll(tasks.ToArray());
//}
//});

app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();

var supportedCultures = new[] { "en-US", "sk-SK", "es-ES" };
var localizationOptions = new RequestLocalizationOptions()
    .AddSupportedCultures(supportedCultures)
    .AddSupportedUICultures(supportedCultures);

app.UseRequestLocalization(localizationOptions);

app.UseAuthorization();

app.MapControllers();
app.MapBlazorHub();
app.MapHub<DialogHub>("/dialoghub");
app.MapFallbackToPage("/_Host");

app.Run();

static (IRepository<User>, IRepository<Group>) SetUpJSon(string path = "..\\..\\..\\..\\..\\JSONREPOS\\")
{
    var executingAssemblyFile = new FileInfo(Assembly.GetExecutingAssembly().Location);
    var repositoryDirectory = Path.GetFullPath($"{executingAssemblyFile.Directory}{path}");
    if (!Directory.Exists(repositoryDirectory))
    {
        Directory.CreateDirectory(repositoryDirectory);
    }

    IRepository<User> userRepo = new JsonRepository<User>(new JsonRepositorySettings<User>(Path.Combine(repositoryDirectory, "Users")));
    IRepository<Group> groupRepo = new JsonRepository<Group>(new JsonRepositorySettings<Group>(Path.Combine(repositoryDirectory, "Groups")));

    return (userRepo, groupRepo);
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

        return roles;
    }

    public const string can_run_ground_mode = nameof(can_run_ground_mode);
    public const string can_run_automat_mode = nameof(can_run_automat_mode);
    public const string can_run_service_mode = nameof(can_run_service_mode);
    public const string process_settings_access = nameof(process_settings_access);
    public const string process_traceability_access = nameof(process_traceability_access);
    public const string can_skip_steps_in_sequence = nameof(can_skip_steps_in_sequence);
}