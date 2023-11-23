using AxOpen.Security;
using AxOpen.Security.Entities;
using AxOpen.Security.Services;
using AXOpen;
using AXOpen.Base.Data;
using AXOpen.Core;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Data;
using AXOpen.Logging;
using axosimple;
using AXOpen.Data.MongoDb;
using axosimple.server.Units;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Services;
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
builder.Services.AddControllers();
builder.Services.AddHttpContextAccessor();

#region AxoApplication

Entry.Plc.Connector.SubscriptionMode = ReadSubscriptionMode.Polling;
Entry.Plc.Connector.BuildAndStart().ReadWriteCycleDelay = 250;
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

Entry.Plc.ContextLogger.StartDequeuing(AxoApplication.Current.Logger, 250);

//var sharedDataRepository = new InMemoryRepositorySettings<Pocos.axosimple.SharedProductionData>().Factory();
//var unitTemplateRepository = new InMemoryRepositorySettings<Pocos.axosimple.UnitTemplate.ProcessData>().Factory();
//var starterUnitTemplateRepository = new InMemoryRepositorySettings<Pocos.axosimple.StarterUnitTemplate.ProcessData>().Factory();

#region MongoDB repository

//https://ix-ax.github.io/AXOpen/api/AXOpen.Data.MongoDb.MongoDbRepository-1.html

var MongoConnectionString = "mongodb://localhost:27017";
var MongoDatabaseName = "axosimple";

// initialize factory - store connection and credentials
Repository.InitializeFactory(MongoConnectionString, MongoDatabaseName, "user", "userpwd");

//  repository - data connected with technology (not with production process)
var TechnologyCommonRepository = Repository.Factory<Pocos.axosimple.TechnologyCommonData>("TechnologyCommon_Settings");

// repository - settings connected with specific recepie
var EntitySettingsRepository = Repository.Factory<Pocos.axosimple.EntityData>("Entity_Settings");

//  repository - data connected with specific part or piece in production/technology
var EntityDataRepository = Repository.Factory<Pocos.axosimple.EntityData>("Entity_Data");

var StarterUnitTemplate_TechSettings = Repository.Factory<Pocos.axosimple.StarterUnitTemplate.TechnologyData>("StarterUnitTemplate_TechnologySettings");
var StarterUnitTemplate_ProcessSettings = Repository.Factory<Pocos.axosimple.StarterUnitTemplate.ProcessData>("StarterUnitTemplate_ProcessSettings");
var StarterUnitTemplate_ProcessData = Repository.Factory<Pocos.axosimple.StarterUnitTemplate.ProcessData>("StarterUnitTemplate_ProcessData");

var UnitTemplate_TechSettings = Repository.Factory<Pocos.axosimple.UnitTemplate.TechnologyData>("UnitTemplate_TechnologySettings");
var UnitTemplate_ProcessSettings = Repository.Factory<Pocos.axosimple.UnitTemplate.ProcessData>("UnitTemplate_ProcessSettings");
var UnitTemplate_ProcessData = Repository.Factory<Pocos.axosimple.UnitTemplate.ProcessData>("UnitTemplate_ProcessData");

//var Cu1_TechSettings    = Repository.Factory<Pocos.axosimple.Cu1.TechnologyData>("Cu1_TechnologySettings");
//var Cu1_ProcessSettings = Repository.Factory<Pocos.axosimple.Cu1.ProcessData>("Cu1_ProcessSettings");
//var Cu1_ProcessData     = Repository.Factory<Pocos.axosimple.Cu1.ProcessData>("Cu1_ProcessData");

#endregion MongoDB repository


var persistentRepository = Repository.Factory<AXOpen.Data.PersistentRecord>("Persistent_Data");
Entry.Plc.Context.PersistentData.InitializeRemoteDataExchange( Entry.Plc.Context, persistentRepository );

var axoappContext = ContextService.Create();
axoappContext.SetContextData(
    technologyCommonRepository: TechnologyCommonRepository,
    entitySettingsRepository: EntitySettingsRepository,
    entityDataRepository: EntityDataRepository
    );

var axoappContext_starterUnitTemplate = StarterUnitTemplateServices.Create(axoappContext);
axoappContext_starterUnitTemplate.SetUnitsData(
    technologySettingsRepository: StarterUnitTemplate_TechSettings,
    processSettingsRepository: StarterUnitTemplate_ProcessSettings,
    processDataRepository: StarterUnitTemplate_ProcessData);

var axoappContext_unitTemplate = UnitTemplateServices.Create(axoappContext);
axoappContext_unitTemplate.SetUnitsData(
    technologySettingsRepository: UnitTemplate_TechSettings,
    processSettingsRepository: UnitTemplate_ProcessSettings,
    processDataRepository: UnitTemplate_ProcessData);

//var axoappContext_Cu1 = axosimple.server.Units.Cu1Services.Create(axoappContext);
//axoappContext_Cu1.SetUnitsData(
//    technologySettingsRepository  : Cu1_TechSettings,
//    processSettingsRepository     : Cu1_ProcessSettings,
//    processDataRepository         : Cu1_ProcessData);


// Clean Temp directory
IAxoDataExchange.CleanUp();

#endregion AxoApplication

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

    IRepository<User> userRepo = new AXOpen.Data.Json.JsonRepository<User>(new AXOpen.Data.Json.JsonRepositorySettings<User>(Path.Combine(repositoryDirectory, "Users")));
    IRepository<Group> groupRepo = new AXOpen.Data.Json.JsonRepository<Group>(new AXOpen.Data.Json.JsonRepositorySettings<Group>(Path.Combine(repositoryDirectory, "Groups")));

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