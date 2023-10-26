using System.Reflection;
using AXOpen;
using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using AXOpen.Data.Json;
using AXOpen.Logging;
using AxOpen.Security;
using AxOpen.Security.Entities;
using AxOpen.Security.Services;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Services;
using axosimple;
using axosimple.server;
using AXSharp.Connector.Identity;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Identity;
using Serilog;
using System.Security.Principal;
using AXOpen.Core;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;
using AXOpen.Data;
using System.Globalization;
using AXOpen.Core.Blazor;
using AXOpen.Core.Blazor.Culture;
using Microsoft.AspNetCore.Localization;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.Primitives;
using Microsoft.JSInterop;


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
var MongoDatabaseName       = "axosimple";

var mongoCredentials = new AXOpen.Data.MongoDb.MongoDbCredentials("admin", "user", "userpwd");

var ProcessSettings_ShararedHeader = Repository.Factory<Pocos.axosimple.SharedProductionData>(
                                        new(connectionString    : MongoConnectionString,
                                            databaseName        : MongoDatabaseName,
                                            collectionName      : "ProcessSettings_SharedHeaders",
                                            credentials         : mongoCredentials));

var ProcessData_ShararedHeader = Repository.Factory<Pocos.axosimple.SharedProductionData>(
                                        new(connectionString    : MongoConnectionString,
                                            databaseName        : MongoDatabaseName,
                                            collectionName      : "ProcessData_SharedHeaders",
                                            credentials         : mongoCredentials));

#endregion



var axoappContext = ContextService.Create();
axoappContext.SetContextData(ProcessData_ShararedHeader);

//var unitTemplateService = UnitTemplateServices.Create(axoappContext);
//unitTemplateService.SetUnitsData(unitTemplateRepository);

//var starterUnitTemplateService = StarterUnitTemplateServices.Create(axoappContext);
//starterUnitTemplateService.SetUnitsData(starterUnitTemplateRepository);

// Clean Temp directory
IAxoDataExchange.CleanUp();
#endregion


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

var supportedCultures = new[] { "en-US", "sk-SK", "es-ES"};
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

