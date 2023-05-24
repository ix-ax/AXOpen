using System.Reflection;
using AXOpen;
using AXOpen.Data.InMemory;
using AXOpen.Logging;
using AXSharp.Connector;
using AXSharp.Presentation.Blazor.Services;
using axosimple.hmi.Areas.Identity;
using axosimple.hmi.Data;
using axosimple;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI;
using Microsoft.EntityFrameworkCore;
using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") ?? throw new InvalidOperationException("Connection string 'DefaultConnection' not found.");
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));
builder.Services.AddDatabaseDeveloperPageExceptionFilter();
builder.Services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
    .AddEntityFrameworkStores<ApplicationDbContext>();
builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();
builder.Services.AddScoped<AuthenticationStateProvider, RevalidatingIdentityAuthenticationStateProvider<IdentityUser>>();

builder.Services.AddIxBlazorServices();

Entry.Plc.Connector.SubscriptionMode = ReadSubscriptionMode.AutoSubscribeUsedVariables;
Entry.Plc.Connector.BuildAndStart().ReadWriteCycleDelay = 150;


AxoApplication.CreateBuilder().ConfigureLogger(new SerilogLogger(new LoggerConfiguration()
    .WriteTo.Console().MinimumLevel.Debug()
    .CreateLogger()));

var productionDataRepository = new InMemoryRepositorySettings<Pocos.examples.PneumaticManipulator.FragmentProcessData> ().Factory();
var headerDataRepository = new InMemoryRepositorySettings<Pocos.axosimple.SharedProductionData>().Factory();

var a = Entry.Plc.Context.PneumaticManipulator
    .ProcessData
    .Builder<examples.PneumaticManipulator.ProcessDataManger>();
a.DataManger.InitializeRemoteDataExchange(productionDataRepository);
a.Shared.InitializeRemoteDataExchange(headerDataRepository);

var b = Entry.Plc.Context.ProcessData
    .Builder<ProcessData>();

b.Manip.InitializeRemoteDataExchange(productionDataRepository);
b.Set.InitializeRemoteDataExchange(headerDataRepository);

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
