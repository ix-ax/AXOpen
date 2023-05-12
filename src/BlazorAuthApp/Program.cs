using AXOpen.Core.blazor.Toaster;
using BlazorAuthApp.Areas.Identity;
using BlazorAuthApp.Data;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI;
using Microsoft.EntityFrameworkCore;
using Security;

namespace BlazorAuthApp
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            builder.Services.AddSingleton<ToastService>();

            builder.Services.AddDatabaseDeveloperPageExceptionFilter();

            builder.Services.AddVortexBlazorSecurity(ServicesConfiguration.SetUpJSon());
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
    }
}