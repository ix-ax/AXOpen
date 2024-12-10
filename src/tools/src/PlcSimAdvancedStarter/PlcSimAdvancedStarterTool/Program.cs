using Cocona;
using System.Reflection;
using PlcSimAdvancedStarterTool.PlcSim;

internal class Program
{
    private static void Main(string[] args)
    {       
        var builder = CoconaApp.CreateBuilder();

        var app = builder.Build();

        app.AddCommands<PlcSim>();

        app.Run();
    }
}