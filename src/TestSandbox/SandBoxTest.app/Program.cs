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
Entry.Plc.Connector.BuildAndStart().ReadWriteCycleDelay = 40;
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

var productionData = new List<IRepository<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>>();
List<sandboxtest.StandardControlUnit.FragmentProcessDataManger> FragmentManagers = new();

List<SharedProductionDataManager> ShagedManagers = new();

var productionsharedData =
    new AXOpen.Data.MongoDb.MongoDbRepository<Pocos.sandboxtest.SharedProductionData>(new AXOpen.Data.MongoDb.MongoDbRepositorySettings<Pocos.sandboxtest.SharedProductionData>(
    connectionString: "mongodb://localhost:27017",
    databaseName: "AxOpenTest",
    collectionName: "productionSharedHeaders",
    credentials: credentials));

// CU1 INSTACE

var CuInstList = Entry.Plc.Context.GetChildren().OfType<sandboxtest.StandardControlUnit.ProcessDataManger>().ToArray();

for (int i = 0; i < CuInstList.Length; i++)
{
    var processFragment =
        new AXOpen.Data.MongoDb.MongoDbRepository<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>(new AXOpen.Data.MongoDb.MongoDbRepositorySettings<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>(
        connectionString: "mongodb://localhost:27017",
        databaseName: "AxOpenTest",
        collectionName: $"ProcessSettings_Cu{i}",
        credentials: credentials));

    var productionFragment =
      new AXOpen.Data.MongoDb.MongoDbRepository<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>(new AXOpen.Data.MongoDb.MongoDbRepositorySettings<Pocos.sandboxtest.StandardControlUnit.FragmentProcessData>(
      connectionString: "mongodb://localhost:27017",
      databaseName: "AxOpenTest",
      collectionName: $"productionDataRepository_Cu{i}",
      credentials: credentials));

    processData.Add(processFragment);
    productionData.Add(productionFragment);

    var CuInst = CuInstList[i].CreateBuilder<sandboxtest.StandardControlUnit.ProcessDataManger>();
    CuInst.Shared.SetRepository(productionsharedData);
    CuInst.DataManger.SetRepository(productionFragment);
    await CuInst.InitializeRemoteDataExchange();

}


// INICIALIZACIA HLAVNYCH PROCESNYCH DAT NA KORENI CONTEXTU
var EntireProcessData = Entry.Plc.Context.EntireProcessData.CreateBuilder<sandboxtest.EntireProcessDataManager>();

await EntireProcessData.InitializeRemoteDataExchange();

EntireProcessData.Set.SetRepository(sharedProcessSettings);

// setting fragment repository 
var EntireProcessDataFragmentList = EntireProcessData.GetChildren().OfType<sandboxtest.StandardControlUnit.FragmentProcessDataManger>().ToArray();

for (int i = 0; i < EntireProcessDataFragmentList.Length; i++)
{
    var c = EntireProcessDataFragmentList[i];
    c.SetRepository(processData[i]);

}

// INICIALIZACIA HLAVNYCH produkcnyh DAT NA KORENI CONTEXTU
var EntireProductionData = Entry.Plc.Context.EntireProductionData.CreateBuilder<sandboxtest.EntireProcessDataManager>();

await EntireProductionData.InitializeRemoteDataExchange();

EntireProductionData.Set.SetRepository(productionsharedData);

// setting fragment repository 
var EntireProductionDataFragmentList = EntireProductionData.GetChildren().OfType<sandboxtest.StandardControlUnit.FragmentProcessDataManger>().ToArray();

for (int i = 0; i < EntireProductionDataFragmentList.Length; i++)
{
    var c = EntireProductionDataFragmentList[i];
    c.SetRepository(productionData[i]);

}


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

