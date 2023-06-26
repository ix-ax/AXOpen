using System.Diagnostics;
using System.Reflection;
using AXOpen.Core;
using axosimple;

namespace templates.simpletests
{
    public class InvalidReferenceOverInterfaceReproTest
    {

        //**********************************************************************
        // make sure you have access to https://github.com/orgs/ix-ax/packages follow instruction at https://ix-ax.github.io/axsharp/index.html#add-package-source
        // run build.ps1 script from the root folder.
        // set target info in \src\template.simple\ctrl\apax.yml
        // set target IP in \src\templates.simple\axosimple.twin\Entry.cs
        //**********************************************************************

        [Fact]
        public static void DownloadTemplate()
        {
            

            var execAssemblyPath = new FileInfo(Assembly.GetExecutingAssembly().Location);
            var plcProjectFolder =
                Path.GetFullPath(Path.Combine(execAssemblyPath.Directory.FullName, "..\\..\\..\\..\\..\\..\\..\\src\\templates.simple\\ctrl"));
           
            var processInfo = new ProcessStartInfo("apax.cmd")
            {
                Arguments = "download",
                WorkingDirectory = plcProjectFolder,
                RedirectStandardOutput = false,
                RedirectStandardError = false,
            };

            Process.Start(processInfo)!.WaitForExit();
        }

        [Fact]
        public async void MakesThePlcToStop()
        {

            DownloadTemplate();

            var sut = Entry.Plc.Context.PneumaticManipulator; 
            sut.GroundSequence.Restore();
            await sut.GroundSequence.ExecuteAsync();
            await sut.GroundSequence.SteppingMode.SetAsync((short)eAxoSteppingMode.StepByStep);
            await Task.Delay(100);
            await sut.GroundSequence.StepForwardCommand.ExecuteAsync();
            await Task.Delay(100);
            await sut.GroundSequence.StepIn.ExecuteAsync();
        }
    }
}