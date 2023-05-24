
using axopen_blazor_auth_app.Data;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI;
using Microsoft.EntityFrameworkCore;
using AxOpen.Security.Services;
using System.Reflection;
using AXOpen.Base.Data;
using AXOpen.Data.Json;
using AxOpen.Security.Entities;
using axopen_blazor_auth_app;
using AxOpen.Security;
using AXOpen.Data.MongoDb;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
//var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
//builder.Services.AddDbContext<ApplicationDbContext>(options =>
//    options.UseSqlServer(connectionString));
//builder.Services.AddDatabaseDeveloperPageExceptionFilter();
//builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
//    .AddEntityFrameworkStores<ApplicationDbContext>();
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
//builder.Services.AddScoped<AuthenticationStateProvider, RevalidatingIdentityAuthenticationStateProvider<IdentityUser>>();
builder.Services.AddSingleton<WeatherForecastService>();

builder.Services.ConfigureAxBlazorSecurity(SetUpJSon(), Roles.CreateRoles());

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

static (IRepository<User>, IRepository<Group>) SetUpMongo(string path = "Blazor")
{
    var mongoUri = "mongodb://localhost:27017";

    IRepository<User> userRepo = new MongoDbRepository<User>(new MongoDbRepositorySettings<User>(mongoUri, path, "Users"));
    IRepository<Group> groupRepo = new MongoDbRepository<Group>(new MongoDbRepositorySettings<Group>(mongoUri, path, "Groups"));

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