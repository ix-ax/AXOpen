using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using System.Data;
using AXOpen.Core;
using AxOpen.Security.Services;
using AXSharp.Presentation.Blazor.Services;
using AXSharp.Connector;
using AXOpen.Base.Data;
using AxOpen.Security.Entities;
using System.Reflection;
using AxOpen.Security;
using Serilog;
using AXOpen;
using AXOpen.Logging;
using librarytemplate;
using AXOpen.Data.InMemory;
using AXOpen.Data.MongoDb;
using AXOpen.Data.Json;


var builder = WebApplication.CreateBuilder(args);

var jsonRepositoryLocation = CreateJsonRepositoryDirectory();

// Add services to the container.
builder.Services.ConfigureAxBlazorSecurity(SetUpJsonSecurityRepository(jsonRepositoryLocation), Roles.CreateRoles());
builder.Services.AddLocalization();
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddIxBlazorServices();
builder.Services.AddAxoCoreServices();

Entry.Plc.Connector.SubscriptionMode = ReadSubscriptionMode.Polling;
Entry.Plc.Connector.BuildAndStart().ReadWriteCycleDelay = 250;
Entry.Plc.Connector.SetLoggerConfiguration(new LoggerConfiguration()
    .WriteTo
    .Console()
    .WriteTo
    .File($"connector.log",
        outputTemplate: "{Timestamp:yyyy-MMM-dd HH:mm:ss} [{Level}] {Message}{NewLine}{Exception}",
        fileSizeLimitBytes: 100000)
    .MinimumLevel.Debug()
    .CreateLogger());
await Entry.Plc.Connector.IdentityProvider.ConstructIdentitiesAsync();

AxoApplication.CreateBuilder().ConfigureLogger(new SerilogLogger(new LoggerConfiguration()
    .WriteTo.Console().MinimumLevel.Verbose()
    .CreateLogger()));


//<SetUpAxoDataPersistentExchange>
IRepository<AXOpen.Data.PersistentRecord> persistentRepository;

// *** IN MEMORY REPOSITORY ***
//persistentRepository = new InMemoryRepositorySettings<AXOpen.Data.PersistentRecord>().Factory();

//***JSON REPOSITORY***
//var persistentLocation = Path.Combine(jsonRepositoryLocation, "PersistentData");
//persistentRepository = new JsonRepositorySettings<AXOpen.Data.PersistentRecord>(persistentLocation).Factory();

// *** MONGO REPOSITORY ***


persistentRepository = AXOpen.Data.MongoDb.Repository.Factory<AXOpen.Data.PersistentRecord>(new MongoDbRepositorySettings<AXOpen.Data.PersistentRecord>("mongodb://localhost:27017", "AxOpenData", "PersistentData"));


Entry.Plc.AxoDataPersistentContext.DataManager.InitializeRemoteDataExchange( 
        Entry.Plc.AxoDataPersistentContext.PersistentRootObject, 
        persistentRepository
        );
//</SetUpAxoDataPersistentExchange>


//<SetUpAxoDataFragmentExchange>
IRepository<Pocos.AxoDataFramentsExchangeExample.SharedDataHeaderData> SharedDataHeaderDataRepository;
IRepository<Pocos.AxoDataFramentsExchangeExample.Station_1_Data> Station_1_DataRepository;

// *** IN MEMORY REPOSITORY ***
//SharedDataHeaderDataRepository = new InMemoryRepositorySettings<Pocos.AxoDataFramentsExchangeExample.SharedDataHeaderData>().Factory();
//Station_1_DataRepository = new InMemoryRepositorySettings<Pocos.AxoDataFramentsExchangeExample.Station_1_Data>().Factory();

// *** JSON REPOSITORY ***
//var SharedHeaderLocation = Path.Combine(jsonRepositoryLocation, "SharedDataHeader");
//var Station_1_Location = Path.Combine(jsonRepositoryLocation, "Station_1");
//SharedDataHeaderDataRepository = new JsonRepositorySettings<Pocos.AxoDataFramentsExchangeExample.SharedDataHeaderData>(SharedHeaderLocation).Factory();
//Station_1_DataRepository = new JsonRepositorySettings<Pocos.AxoDataFramentsExchangeExample.Station_1_Data>(Station_1_Location).Factory();

// *** MONGO REPOSITORY ***

SharedDataHeaderDataRepository = AXOpen.Data.MongoDb.Repository.Factory<Pocos.AxoDataFramentsExchangeExample.SharedDataHeaderData>(new MongoDbRepositorySettings<Pocos.AxoDataFramentsExchangeExample.SharedDataHeaderData>("mongodb://localhost:27017", "AxOpenData", "SharedDataHeader"));
Station_1_DataRepository = AXOpen.Data.MongoDb.Repository.Factory<Pocos.AxoDataFramentsExchangeExample.Station_1_Data>(new MongoDbRepositorySettings<Pocos.AxoDataFramentsExchangeExample.Station_1_Data>("mongodb://localhost:27017", "AxOpenData", "Station_1"));

var AxoProcessDataManager = Entry.Plc.AxoDataFragmentsExchangeContext.DataManager.CreateBuilder<AxoDataFramentsExchangeExample.AxoProcessDataManager>();

AxoProcessDataManager.SharedHeader.SetRepository(SharedDataHeaderDataRepository);
AxoProcessDataManager.Station_1.SetRepository(Station_1_DataRepository);
AxoProcessDataManager.InitializeRemoteDataExchange();
//</SetUpAxoDataFragmentExchange>


//<SetUpAxoDataExchange>
IRepository<Pocos.AxoDataExchangeExample.AxoProcessData> AxoProcessDataRepository;

// *** IN MEMORY REPOSITORY ***
//AxoProcessDataRepository = new InMemoryRepositorySettings<Pocos.AxoDataExchangeExample.AxoProcessData>().Factory();
//Entry.Plc.AxoDataExchangeContext.DataManager.InitializeRemoteDataExchange(AxoProcessDataRepository);

// *** JSON REPOSITORY ***
//var ProcessDataLocation = Path.Combine(jsonRepositoryLocation, "ProcessData");
//AxoProcessDataRepository = new JsonRepositorySettings<Pocos.AxoDataExchangeExample.AxoProcessData>(ProcessDataLocation).Factory();

// *** MONGO REPOSITORY ***


AxoProcessDataRepository = AXOpen.Data.MongoDb.Repository.Factory<Pocos.AxoDataExchangeExample.AxoProcessData>(new MongoDbRepositorySettings<Pocos.AxoDataExchangeExample.AxoProcessData>("mongodb://localhost:27017", "AxOpenData","AxoDataExchangeExample"));

Entry.Plc.AxoDataExchangeContext.DataManager.InitializeRemoteDataExchange(AxoProcessDataRepository);
//</SetUpAxoDataExchange>

//<CleanUp>
// Clean Temp directory
AXOpen.Data.IAxoDataExchange.CleanUp();
//</CleanUp>

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


static string CreateJsonRepositoryDirectory(string path = "..\\..\\..\\..\\..\\JSONREPOS\\")
{
    var executingAssemblyFile = new FileInfo(Assembly.GetExecutingAssembly().Location);
    var repositoryDirectory = Path.GetFullPath($"{executingAssemblyFile.Directory}{path}");
    if (!Directory.Exists(repositoryDirectory))
    {
        Directory.CreateDirectory(repositoryDirectory);
    }
    return repositoryDirectory;
}

static (IRepository<User>, IRepository<Group>) SetUpJsonSecurityRepository(string repositoryDirectory)
{

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
