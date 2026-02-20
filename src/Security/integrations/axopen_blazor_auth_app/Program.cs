
using axopen_blazor_auth_app.Data;
using AxOpen.Security.Services;
using System.Reflection;
using AXOpen.Base.Data;
using AXOpen.Data.Json;
using AxOpen.Security.Entities;
using axopen_blazor_auth_app;
using AxOpen.Security;
using AXOpen.Data.MongoDb;
using AXOpen.Base.Dialogs;
using AXOpen.Core.Blazor.AxoAlertDialog;
using AXOpen.Core;
using AXOpen.Logging;
using Serilog;
using AXOpen;
using AXSharp.Presentation.Blazor.Services;

var builder = WebApplication.CreateBuilder(args);

//<AxConfiguration>
builder.Services.ConfigureAxBlazorSecurity(SetUpJSon(), Roles.CreateRoles());
//</AxConfiguration>

builder.Services.AddLocalization();
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();

builder.Services.AddIxBlazorServices();
builder.Services.AddAxoCoreServices();

builder.Services.AddSingleton<WeatherForecastService>();

AxoApplication.CreateBuilder().ConfigureLogger(new SerilogLogger(new LoggerConfiguration()
    .WriteTo.Console().MinimumLevel.Verbose()
    .CreateLogger()));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseMigrationsEndPoint();
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

app.MapControllers();
app.MapBlazorHub();
app.MapFallbackToPage("/_Host");

app.Run();


//<SetupJson>
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
//</SetupJson>
static (IRepository<User>, IRepository<Group>) SetUpMongo(string path = "Blazor")
{
    var MongoDatabaseName = path;
    var MongoConnectionString = "mongodb://localhost:27017";

    IRepository<User> userRepo = AXOpen.Data.MongoDb.Repository.Factory<User>(new MongoDbRepositorySettings<User>(MongoConnectionString, MongoDatabaseName, "Users", idExpression: t => t.Id));
    IRepository<Group> groupRepo = AXOpen.Data.MongoDb.Repository.Factory<Group>(new MongoDbRepositorySettings<Group>(MongoConnectionString, MongoDatabaseName, "Groups"));
    return (userRepo, groupRepo);
}

//public static (IRepository<UserData>, IRepository<GroupData>) SetUpRavenDB(string[] urls, string path = "Blazor", string certPath = "", string certPass = "")
//{
//    IRepository<UserData> userRepo = new RavenDbRepository<UserData>(new RavenDbRepositorySettings<UserData>(urls, path, certPath, certPass));
//    IRepository<GroupData> groupRepo = new RavenDbRepository<GroupData>(new RavenDbRepositorySettings<GroupData>(urls, path, certPath, certPass));

//    return (userRepo, groupRepo);
//}

//public static (IRepository<UserData>, IRepository<GroupData>) SetUpInMemory()
//{
//    IRepository<UserData> userRepo = new InMemoryRepository<UserData>(new InMemoryRepositorySettings<UserData>());
//    IRepository<GroupData> groupRepo = new InMemoryRepository<GroupData>(new InMemoryRepositorySettings<GroupData>());

//    return (userRepo, groupRepo);
//}