using Cocona;
using System.Reflection;
using Microsoft.CodeAnalysis;
using System.Xml.Linq;
using System.Diagnostics;


namespace PlcSimAdvancedStarterTool.PlcSim
{
    public class PlcSim
    {
        [Command("startplcsim")]
        public Task StartPlcSim(  [Option('x',Description = "PlcSim instance name")] string PlcSimInstanceName,
                                        [Option('n',Description = "Plc name.")] string PlcName,
                                        [Option('t',Description = "Plc Ip address")] string PlcIpAddress)
        {
            string dllPath = "";
            string exePath = "";

            if(PlcSimInstallation.Check(ref dllPath, ref exePath))
            {
                // This is a workaround to get the local dll for the PlcSimAdvanced API
                var entry = new FileInfo(Assembly.GetEntryAssembly().Location);
                var folder = entry.Directory.FullName;
                File.Copy(dllPath, Path.Combine(folder, "Siemens.Simatic.Simulation.Runtime.Api.x64.dll"), true);

                // Check if PlcSim is already running
                if (Process.GetProcesses().Where(p => p.ProcessName.Equals("Siemens.Simatic.PlcSim.Advanced.UserInterface")).Count() > 0)
                {
                    Console.WriteLine("PlcSimAdvanced already running.");
                }
                else
                {
                    // Start PlcSim
                    Process.Start(new ProcessStartInfo(exePath));
                    Console.WriteLine("PlcSimAdvanced started.");
                }

                exePath = Path.Combine(folder, "PlcSimAdvancedStarter.exe");
                Process.Start(new ProcessStartInfo(exePath) { Arguments = $"-x {PlcSimInstanceName} -n {PlcName} -t {PlcIpAddress}" });
            }

            return Task.CompletedTask;
        }
    }
}
