using AXOpen.Data.InMemory;
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
Entry.Plc.Connector.BuildAndStart().ReadWriteCycleDelay = 100;

var productionDataRepository = new InMemoryRepositorySettings<Pocos.examples.PneumaticManipulator.ProcessData> ().Factory();
Entry.Plc.Context.ProductionSettings.InitializeRemoteDataExchange(productionDataRepository);
Entry.Plc.Context.PneumaticManipulator.ProcessData.InitializeRemoteDataExchange(productionDataRepository);

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
