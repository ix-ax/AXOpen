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
using System.Drawing.Text;
using System.Reflection;

int STATION_COUNT = 20;

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
Entry.Plc.Connector.ConcurrentRequestMaxCount = 3;
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

for (int i = 0; i <= STATION_COUNT; i++)
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

for (int i = 1; i <= STATION_COUNT; i++)
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
var CuInst_0 = Entry.Plc.Context.ProcessDataCu_0.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_1 = Entry.Plc.Context.ProcessDataCu_1.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_2 = Entry.Plc.Context.ProcessDataCu_2.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_3 = Entry.Plc.Context.ProcessDataCu_3.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_4 = Entry.Plc.Context.ProcessDataCu_4.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_5 = Entry.Plc.Context.ProcessDataCu_5.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_6 = Entry.Plc.Context.ProcessDataCu_6.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_7 = Entry.Plc.Context.ProcessDataCu_7.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_8 = Entry.Plc.Context.ProcessDataCu_8.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_9 = Entry.Plc.Context.ProcessDataCu_9.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();

var CuInst_10 = Entry.Plc.Context.ProcessDataCu_10.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_11 = Entry.Plc.Context.ProcessDataCu_11.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_12 = Entry.Plc.Context.ProcessDataCu_12.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_13 = Entry.Plc.Context.ProcessDataCu_13.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_14 = Entry.Plc.Context.ProcessDataCu_14.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_15 = Entry.Plc.Context.ProcessDataCu_15.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_16 = Entry.Plc.Context.ProcessDataCu_16.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_17 = Entry.Plc.Context.ProcessDataCu_17.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_18 = Entry.Plc.Context.ProcessDataCu_18.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
var CuInst_19 = Entry.Plc.Context.ProcessDataCu_19.CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();


CuInst_0.Shared.SetRepository(productionsharedData);
CuInst_1.Shared.SetRepository(productionsharedData);
CuInst_2.Shared.SetRepository(productionsharedData);
CuInst_3.Shared.SetRepository(productionsharedData);
CuInst_4.Shared.SetRepository(productionsharedData);
CuInst_5.Shared.SetRepository(productionsharedData);
CuInst_6.Shared.SetRepository(productionsharedData);
CuInst_7.Shared.SetRepository(productionsharedData);
CuInst_8.Shared.SetRepository(productionsharedData);
CuInst_9.Shared.SetRepository(productionsharedData);


CuInst_10.Shared.SetRepository(productionsharedData);
CuInst_11.Shared.SetRepository(productionsharedData);
CuInst_12.Shared.SetRepository(productionsharedData);
CuInst_13.Shared.SetRepository(productionsharedData);
CuInst_14.Shared.SetRepository(productionsharedData);
CuInst_15.Shared.SetRepository(productionsharedData);
CuInst_16.Shared.SetRepository(productionsharedData);
CuInst_17.Shared.SetRepository(productionsharedData);
CuInst_18.Shared.SetRepository(productionsharedData);
CuInst_19.Shared.SetRepository(productionsharedData);

CuInst_0.DataManger.SetRepository(productionData[0]);
CuInst_1.DataManger.SetRepository(productionData[1]);
CuInst_2.DataManger.SetRepository(productionData[2]);
CuInst_3.DataManger.SetRepository(productionData[3]);
CuInst_4.DataManger.SetRepository(productionData[4]);
CuInst_5.DataManger.SetRepository(productionData[5]);
CuInst_6.DataManger.SetRepository(productionData[6]);
CuInst_7.DataManger.SetRepository(productionData[7]);
CuInst_8.DataManger.SetRepository(productionData[8]);
CuInst_9.DataManger.SetRepository(productionData[9]);

CuInst_10.DataManger.SetRepository(productionData[10]);
CuInst_11.DataManger.SetRepository(productionData[11]);
CuInst_12.DataManger.SetRepository(productionData[12]);
CuInst_13.DataManger.SetRepository(productionData[13]);
CuInst_14.DataManger.SetRepository(productionData[14]);
CuInst_15.DataManger.SetRepository(productionData[15]);
CuInst_16.DataManger.SetRepository(productionData[16]);
CuInst_17.DataManger.SetRepository(productionData[17]);
CuInst_18.DataManger.SetRepository(productionData[18]);
CuInst_19.DataManger.SetRepository(productionData[19]);

List<sandboxtest.StandardControlUnit.FragmentProcessDataManger> FragmentManagers = new();
List<SharedProductionDataManager> ShagedManagers = new();

FragmentManagers.Add(CuInst_0.DataManger);
FragmentManagers.Add(CuInst_1.DataManger);
FragmentManagers.Add(CuInst_2.DataManger);
FragmentManagers.Add(CuInst_3.DataManger);
FragmentManagers.Add(CuInst_4.DataManger);
FragmentManagers.Add(CuInst_5.DataManger);
FragmentManagers.Add(CuInst_6.DataManger);
FragmentManagers.Add(CuInst_7.DataManger);
FragmentManagers.Add(CuInst_8.DataManger);
FragmentManagers.Add(CuInst_9.DataManger);

FragmentManagers.Add(CuInst_10.DataManger);
FragmentManagers.Add(CuInst_11.DataManger);
FragmentManagers.Add(CuInst_12.DataManger);
FragmentManagers.Add(CuInst_13.DataManger);
FragmentManagers.Add(CuInst_14.DataManger);
FragmentManagers.Add(CuInst_15.DataManger);
FragmentManagers.Add(CuInst_16.DataManger);
FragmentManagers.Add(CuInst_17.DataManger);
FragmentManagers.Add(CuInst_18.DataManger);
FragmentManagers.Add(CuInst_19.DataManger);

ShagedManagers.Add(CuInst_0.Shared);
ShagedManagers.Add(CuInst_1.Shared);
ShagedManagers.Add(CuInst_2.Shared);
ShagedManagers.Add(CuInst_3.Shared);
ShagedManagers.Add(CuInst_4.Shared);
ShagedManagers.Add(CuInst_5.Shared);
ShagedManagers.Add(CuInst_6.Shared);
ShagedManagers.Add(CuInst_7.Shared);
ShagedManagers.Add(CuInst_8.Shared);
ShagedManagers.Add(CuInst_9.Shared);

ShagedManagers.Add(CuInst_10.Shared);
ShagedManagers.Add(CuInst_11.Shared);
ShagedManagers.Add(CuInst_12.Shared);
ShagedManagers.Add(CuInst_13.Shared);
ShagedManagers.Add(CuInst_14.Shared);
ShagedManagers.Add(CuInst_15.Shared);
ShagedManagers.Add(CuInst_16.Shared);
ShagedManagers.Add(CuInst_17.Shared);
ShagedManagers.Add(CuInst_18.Shared);
ShagedManagers.Add(CuInst_19.Shared);


await CuInst_0.InitializeRemoteDataExchange();
await CuInst_1.InitializeRemoteDataExchange();
await CuInst_2.InitializeRemoteDataExchange();
await CuInst_3.InitializeRemoteDataExchange();
await CuInst_4.InitializeRemoteDataExchange();
await CuInst_5.InitializeRemoteDataExchange();
await CuInst_6.InitializeRemoteDataExchange();
await CuInst_7.InitializeRemoteDataExchange();
await CuInst_8.InitializeRemoteDataExchange();
await CuInst_9.InitializeRemoteDataExchange();

await CuInst_10.InitializeRemoteDataExchange();
await CuInst_11.InitializeRemoteDataExchange();
await CuInst_12.InitializeRemoteDataExchange();
await CuInst_13.InitializeRemoteDataExchange();
await CuInst_14.InitializeRemoteDataExchange();
await CuInst_15.InitializeRemoteDataExchange();
await CuInst_16.InitializeRemoteDataExchange();
await CuInst_17.InitializeRemoteDataExchange();
await CuInst_18.InitializeRemoteDataExchange();
await CuInst_19.InitializeRemoteDataExchange();

// INICIALIZACIA HLAVNYCH PROCESNYCH DAT NA KORENI CONTEXTU
var EntireProcessData = Entry.Plc.Context.EntireProcessData.CreateBuilder<sandboxtest.EntireProcessDataManager>();

await EntireProcessData.InitializeRemoteDataExchange();

EntireProcessData.Set.SetRepository(sharedProcessSettings);
EntireProcessData.Cu0.SetRepository(processData[0]);
EntireProcessData.Cu1.SetRepository(processData[1]);
EntireProcessData.Cu2.SetRepository(processData[2]);
EntireProcessData.Cu3.SetRepository(processData[3]);
EntireProcessData.Cu4.SetRepository(processData[4]);
EntireProcessData.Cu5.SetRepository(processData[5]);
EntireProcessData.Cu6.SetRepository(processData[6]);
EntireProcessData.Cu7.SetRepository(processData[7]);
EntireProcessData.Cu8.SetRepository(processData[8]);
EntireProcessData.Cu9.SetRepository(processData[9]);

EntireProcessData.Cu10.SetRepository(processData[10]);
EntireProcessData.Cu11.SetRepository(processData[11]);
EntireProcessData.Cu12.SetRepository(processData[12]);
EntireProcessData.Cu13.SetRepository(processData[13]);
EntireProcessData.Cu14.SetRepository(processData[14]);
EntireProcessData.Cu15.SetRepository(processData[15]);
EntireProcessData.Cu16.SetRepository(processData[16]);
EntireProcessData.Cu17.SetRepository(processData[17]);
EntireProcessData.Cu18.SetRepository(processData[18]);
EntireProcessData.Cu19.SetRepository(processData[19]);

// INICIALIZACIA HLAVNYCH produkcnyh DAT NA KORENI CONTEXTU
var EntireProductionData = Entry.Plc.Context.EntireProductionData.CreateBuilder<sandboxtest.EntireProcessDataManager>();

await EntireProductionData.InitializeRemoteDataExchange();

EntireProductionData.Set.SetRepository(productionsharedData);
EntireProductionData.Cu0.SetRepository(productionData[0]);
EntireProductionData.Cu1.SetRepository(productionData[1]);
EntireProductionData.Cu2.SetRepository(productionData[2]);
EntireProductionData.Cu3.SetRepository(productionData[3]);
EntireProductionData.Cu4.SetRepository(productionData[4]);
EntireProductionData.Cu5.SetRepository(productionData[5]);
EntireProductionData.Cu6.SetRepository(productionData[6]);
EntireProductionData.Cu7.SetRepository(productionData[7]);
EntireProductionData.Cu8.SetRepository(productionData[8]);
EntireProductionData.Cu9.SetRepository(productionData[9]);

EntireProductionData.Cu10.SetRepository(productionData[10]);
EntireProductionData.Cu11.SetRepository(productionData[11]);
EntireProductionData.Cu12.SetRepository(productionData[12]);
EntireProductionData.Cu13.SetRepository(productionData[13]);
EntireProductionData.Cu14.SetRepository(productionData[14]);
EntireProductionData.Cu15.SetRepository(productionData[15]);
EntireProductionData.Cu16.SetRepository(productionData[16]);
EntireProductionData.Cu17.SetRepository(productionData[17]);
EntireProductionData.Cu18.SetRepository(productionData[18]);
EntireProductionData.Cu19.SetRepository(productionData[19]);


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

