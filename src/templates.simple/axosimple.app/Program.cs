    using System.Reflection;
using AXOpen;
using AXOpen.Base.Data;
using AXOpen.Data.InMemory;
using AXOpen.Data.Json;
using AXOpen.Logging;
using AxOpen.Security;
using AxOpen.Security.Entities;
using AxOpen.Security.Services;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Services;
using axosimple;
using axosimple.hmi;
using AXSharp.Connector.Identity;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Identity;
using Serilog;
using AXSharp.Abstractions.Dialogs.AlertDialog;
using AXSharp.Presentation.Blazor.Controls.Dialogs.AlertDialog;
using System.Security.Principal;
using AXOpen.Core;
using AXOpen.Core.Blazor.AxoDialogs.Hubs;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.ConfigureAxBlazorSecurity(SetUpJSon(), Roles.CreateRoles());
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddIxBlazorServices();
builder.Services.AddAxoCoreServices();
builder.Services.AddScoped<IAlertDialogService, ToasterService>();


Entry.Plc.Connector.SubscriptionMode = ReadSubscriptionMode.Polling;
Entry.Plc.Connector.BuildAndStart().ReadWriteCycleDelay = 250;
await Entry.Plc.Connector.IdentityProvider.ConstructIdentitiesAsync();

AxoApplication.CreateBuilder().ConfigureLogger(new SerilogLogger(new LoggerConfiguration()
    .WriteTo.Console().MinimumLevel.Verbose()
    .CreateLogger()));

var productionDataRepository = new InMemoryRepositorySettings<Pocos.examples.PneumaticManipulator.FragmentProcessData> ().Factory();
var headerDataRepository = new InMemoryRepositorySettings<Pocos.axosimple.SharedProductionData>().Factory();

Entry.Plc.ContextLogger.StartDequeuing(AxoApplication.Current.Logger, 250);

var a = Entry.Plc.Context.PneumaticManipulator
    .ProcessData
    .CreateBuilder<examples.PneumaticManipulator.ProcessDataManger>();

a.DataManger.SetRepository(productionDataRepository);
a.Shared.SetRepository(headerDataRepository);
a.InitializeRemoteDataExchange();

var b = Entry.Plc.Context.ProcessData
    .CreateBuilder<ProcessData>();

b.Manip.InitializeRemoteDataExchange(productionDataRepository);
b.Set.InitializeRemoteDataExchange(headerDataRepository);

b.InitializeRemoteDataExchange();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    //app.UseMigrationsEndPoint();
}
else
{
    app.UseExceptionHandler("/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.UseResponseCompression();

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




