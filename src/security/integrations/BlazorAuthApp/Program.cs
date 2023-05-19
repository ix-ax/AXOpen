using AXOpen.Base.Data;
using AXOpen.Core.blazor.Toaster;
using AXOpen.Data.InMemory;
using AXOpen.Data.Json;
using AXOpen.Data.MongoDb;
using AXOpen.Data.RavenDb;
using BlazorAuthApp.Areas.Identity;
using BlazorAuthApp.Data;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI;
using Microsoft.EntityFrameworkCore;
using AxOpen.Security;
using System.Reflection;

namespace BlazorAuthApp
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddSingleton<ToastService>();

            builder.Services.AddDatabaseDeveloperPageExceptionFilter();

            //ExternalAuthorization externalAuthorization = ExternalTokenAuthorization.CreatePlcTokenReader("sff", true);

            builder.Services.AddVortexBlazorSecurity(SetUpJSon(), Roles.CreateRoles());
            //builder.Services.AddVortexBlazorSecurity(ServicesConfiguration.SetUpMongo());
            //builder.Services.AddVortexBlazorSecurity(ServicesConfiguration.SetUpRavenDB(new string[] { "https://a.ravend.ravendb.community" }, "Blazor", "C:\\Users\\branko.zachemsky\\Downloads\\ClientCertificate\\ClientCertificate.pfx"));
            //builder.Services.AddVortexBlazorSecurity(ServicesConfiguration.SetUpInMemory());

            builder.Services.AddRazorPages();
            builder.Services.AddServerSideBlazor();
            //builder.Services.AddScoped<AuthenticationStateProvider, RevalidatingIdentityAuthenticationStateProvider<IdentityUser>>();
            builder.Services.AddSingleton<WeatherForecastService>();

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
        }

        public static (IRepository<UserData>, IRepository<GroupData>) SetUpJSon(string path = "..\\..\\..\\..\\..\\JSONREPOS\\")
        {
            var executingAssemblyFile = new FileInfo(Assembly.GetExecutingAssembly().Location);
            var repositoryDirectory = Path.GetFullPath($"{executingAssemblyFile.Directory}{path}");

            if (!Directory.Exists(repositoryDirectory))
            {
                Directory.CreateDirectory(repositoryDirectory);
            }


            IRepository<UserData> userRepo = new JsonRepository<UserData>(new JsonRepositorySettings<UserData>(Path.Combine(repositoryDirectory, "Users")));
            IRepository<GroupData> groupRepo = new JsonRepository<GroupData>(new JsonRepositorySettings<GroupData>(Path.Combine(repositoryDirectory, "Groups")));

            return (userRepo, groupRepo);
        }

        public static (IRepository<UserData>, IRepository<GroupData>) SetUpMongo(string path = "Blazor")
        {
            var mongoUri = "mongodb://localhost:27017";

            IRepository<UserData> userRepo = new MongoDbRepository<UserData>(new MongoDbRepositorySettings<UserData>(mongoUri, path, "Users"));
            IRepository<GroupData> groupRepo = new MongoDbRepository<GroupData>(new MongoDbRepositorySettings<GroupData>(mongoUri, path, "Groups"));

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
    }
}