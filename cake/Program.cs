// Build
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/ix/blob/master/LICENSE
// Third party licenses: https://github.com/ix-ax/ix/blob/master/notices.md


using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Diagnostics.Contracts;
using System.IO;
using System.IO.Compression;
using System.IO.Packaging;
using System.Linq;
using System.Management.Automation;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Build;
using Build.FilteredSolution;
using Cake.Common;
using Cake.Common.Diagnostics;
using Cake.Common.IO;
using Cake.Common.Tools.DotNet;
using Cake.Common.Tools.DotNet.Clean;
using Cake.Common.Tools.DotNet.Restore;
using Cake.Core.Diagnostics;
using Cake.Core.IO;
using Cake.Core.Tooling;
using Cake.Frosting;
using Cake.Powershell;
using CliWrap;
using CommandLine;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.VisualBasic;
using Newtonsoft.Json;
using NuGet.Packaging;
using NuGet.Protocol;
using NuGet.Protocol.Plugins;
using Octokit;
using Polly;
using Spectre.Console;
using static System.Net.WebRequestMethods;
using static NuGet.Packaging.PackagingConstants;
using Credentials = Octokit.Credentials;
using File = System.IO.File;
using Path = System.IO.Path;
using ProductHeaderValue = Octokit.ProductHeaderValue;


public static class Program
{
    public static int Main(string[] args)
    {
        var retVal = 0;
        Parser.Default.ParseArguments<BuildParameters>(args)
            .WithParsed<BuildParameters>(o =>
            {
                retVal = new CakeHost()
                    .ConfigureServices(services => services.AddSingleton(o))
                    .UseContext<BuildContext>()
                    .Run(args);
            });

        return retVal;
    }
}

[TaskName("CleanUp")]
public sealed class CleanUpTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        context.Log.Information("Build running with following parameters:");
        context.Log.Information(context.BuildParameters.ToJson(Formatting.Indented));
       
        if (context.IsGitHubActions)
        {
            context.BuildParameters.CleanUp = true;
        }
        
        if (!context.BuildParameters.CleanUp)
        {
            context.Log.Information($"Skipping clean-up");
            return;
        }
        
        Parallel.ForEach(context.Libraries, lib => context.ApaxClean(lib));
        
        context.DotNetClean(Path.Combine(context.RootDir, "AXOpen.proj"), new DotNetCleanSettings() { Verbosity = context.BuildParameters.Verbosity});
        context.CleanDirectory(context.BuildsOutput);
        context.CleanDirectory(context.Artifacts);
        context.CleanDirectory(context.TestResults);
        context.CleanDirectory(context.TestResultsCtrl);
    }
}

[TaskName("Provision")]
[IsDependentOn(typeof(CleanUpTask))]
public sealed class ProvisionTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        ProvisionTools(context);

        foreach (var library in context.Libraries)
        {
            context.CopyFiles(Path.Combine(context.RootDir, "traversals", "traversalBuilds", "**/*.*"), Path.Combine(context.RootDir, library.folder));
        }
    }

    private static void ProvisionTools(BuildContext context)
    {
        context.ProcessRunner.Start(@"dotnet", new Cake.Core.IO.ProcessSettings()
        {
            Arguments = $"tool restore",
            WorkingDirectory = context.RootDir
        }).WaitForExit();
    }
}

[TaskName("ApaxUpdate")]
[IsDependentOn(typeof(ProvisionTask))]
public sealed class ApaxUpdateTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (!context.BuildParameters.DoApaxUpdate)
            return;

        context.Libraries.ToList().ForEach(lib =>
        {
            context.ApaxUpdate(lib);
        });

        context.DotNetBuild(Path.Combine(context.RootDir, "AXOpen.proj"), context.DotNetBuildSettings);
    }
}


[TaskName("CatalogInstall")]
[IsDependentOn(typeof(ApaxUpdateTask))]
public sealed class CatalogInstallTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        context.Libraries.ToList().ForEach(lib =>
        {
            foreach (var apaxfile in context.GetApaxFiles(lib))
            {
                context.ApaxCatalogInstall(apaxfile);
            }
        });


    }
}

[TaskName("Build")]
[IsDependentOn(typeof(CatalogInstallTask))]
public sealed class BuildTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (context.BuildParameters.DoPack)
        {
            context.Libraries.ToList().ForEach(lib =>
            {
                foreach (var apaxfile in context.GetApaxFiles(lib))
                {
                    context.UpdateApaxVersion(apaxfile, GitVersionInformation.SemVer);
                    context.UpdateApaxDependencies(apaxfile, context.Libraries.Select(p => context.GetApaxFile(p)), GitVersionInformation.SemVer);
                }
            });

            context.Libraries.ToList().ForEach(lib =>
            {
                foreach (var apaxfile in context.GetApaxFiles(lib))
                {
                    context.ApaxChangeBuildProperties(apaxfile, new string[] { "\"1500\"", "llvm" }, new[] { "src", "axsharp.companion.json" });
                }
            });
        }

        var traversalProjectFolder = Path.Combine(context.RootDir, "traversals", "apax");
        if (!context.BuildParameters.NoBuild)
        {
            var traversalProject = Path.Combine(traversalProjectFolder, "apax.yml");
            context.CreateApaxTraversal(context.RootDir, traversalProject);
            context.ApaxInstall(new[] { traversalProjectFolder });
            context.DotnetIxc(new[] { traversalProjectFolder });
            context.DotNetBuildSettings.Verbosity = DotNetVerbosity.Quiet;
            context.DotNetBuildSettings.MSBuildSettings.Properties.Add("NoWarn", new List<string>() 
            { "1234;2345;8602;10012;8618;0162;8605;1416;3270;1504;8600;8618;" +
                "CS0618;CS1591;BL0007;BL0005;CA1416;CA2200;CS0105;CS0108;CS0109;CS0162;CS0168;CS0169;CS219;CS0414;CS0436;CS0472;CS0618;CS1591;CS1998;CS8604;" +
                "CS8601;SYSLIB0051;SYSLIB0014;CS8625;CS0219;CS8625;CS8625;CS8620;RZ2012;RZ10012;CS4014;CS8981;CS8603;CS8766;CS8619;CS0649;CS8321"
            });
            context.DotNetBuild(Path.Combine(context.RootDir, "AXOpen.proj"), context.DotNetBuildSettings);
        }

        if (!context.BuildParameters.NoBuild && !context.BuildParameters.DoTest && !context.BuildParameters.DoPack)
        {
            context.ApaxBuild(new []{traversalProjectFolder});
        }
    }
}

[TaskName("Tests")]
[IsDependentOn(typeof(BuildTask))]
public sealed class TestsTask : FrostingTask<BuildContext>
{
    // Tasks can be asynchronous
    public override void Run(BuildContext context)
    {
        if (!context.BuildParameters.DoTest)
        {
            context.Log.Warning($"Skipping tests");
            return;
        }


        if (context.BuildParameters.Paralellize)
        {
            context.Libraries.ToList().ForEach(lib =>
            {
                context.ApaxClean(lib);
                context.ApaxInstall(context.GetLibraryAxFolders(lib));
                context.ApaxBuild(context.GetLibraryAxFolders(lib));
                context.ApaxTestLibrary(lib);
                if (context.BuildParameters.DoPack)
                {
                    context.ApaxPack(lib);
                    context.ApaxCopyArtifacts(lib);
                }
                context.ApaxClean(lib);
            });

        }
        else
        {
            context.Libraries.ToList().ForEach(lib =>
            {
                context.Log.Information($"---------------------------------");
                context.Log.Information($"Testing {lib.folder}");
                context.Log.Information($"---------------------------------");
                context.ApaxClean(lib);
                context.ApaxInstall(context.GetLibraryAxFolders(lib));
                context.ApaxBuild(context.GetLibraryAxFolders(lib));
                context.ApaxTestLibrary(lib);
                if (context.BuildParameters.DoPack)
                {
                    context.ApaxPack(lib);
                    context.ApaxCopyArtifacts(lib);
                }
                context.ApaxClean(lib);
            });
        }

        
          
                
        if (context.BuildParameters.TestLevel == 1)
        {
            context.DotNetTest(Path.Combine(context.RootDir, "AXOpen-L1-tests.proj"), context.DotNetTestSettings);
        }
        if (context.BuildParameters.TestLevel == 2)
        {
        
            context.DotNetTest(Path.Combine(context.RootDir, "AXOpen-L2-tests.proj"), context.DotNetTestSettings);
        }
        if(context.BuildParameters.TestLevel >= 3)
        {
            foreach (var package in context.Libraries)
            {
                var app = Path.Combine(context.RootDir, package.folder, "app");
                var ax = Path.Combine(context.RootDir, package.folder, "ax");

                if (Directory.Exists(app))
                {
                    context.ApaxDownload(app);
                }
                else if (Directory.Exists(ax))
                {
                    context.ApaxDownload(ax);
                }
                else
                {
                    //throw new Exception($"No app or ax folder found for {package.folder}");
                    context.Log.Information($"No app or ax folder found for {package.folder}");
                    break;
                }

                context.DotNetTest(Path.Combine(context.RootDir, package.folder, "tmp_L3_.proj"), context.DotNetTestSettings);
            }
        }

        context.Log.Information("Tests done.");
    }
}

[TaskName("AppsRun")]
[IsDependentOn(typeof(TestsTask))]
public sealed class AppsRunTask : FrostingTask<BuildContext>
{
    // Tasks can be asynchronous
    public override void Run(BuildContext context)
    {
        if (!context.BuildParameters.AppsRun)
        {
            context.Log.Warning($"Skipping apps run");
            return;
        }
        KillProcess(context,"Siemens.Simatic.PlcSim.Advanced.UserInterface");

        bool summaryResult = true;

        var createResult = CreateLogFile(context, "app_test_result");

        if (createResult.Success)
        {
            string logFilePath = createResult.FilePath;
            WriteResult(context,"AppName,PlcHw,PlcSw,DotnetBuild,DotnetRun", logFilePath);

            foreach (var library in context.Libraries)
            {
                if (library.app_run)
                {
                    string appFolder = context.GetAppFolder(library);
                    string appFile = context.GetApaxFile(appFolder);
                    string appName = context.GetApplicationName(appFile);

                    if (!string.IsNullOrEmpty(appFolder) && context.DirectoryExists(appFolder) && !string.IsNullOrEmpty(appFile) && context.FileExists(appFile) && !string.IsNullOrEmpty(appName))
                    {
                        // Display the file details
                        context.Log.Information($"###################################################");
                        context.Log.Information($"Starting the application: {appName}");
                        context.Log.Information($"File of the application: {appFile}");
                        context.Log.Information($"###################################################");

                        WriteResult(context, " ", logFilePath);
                        WriteResult(context, appName, logFilePath, appendToSameLine: true);

                        // Initialize PLC Sim instance
                        InitializePlcSimInstance(context, appName);

                        // Overwrite security files
                        OverwriteSecurityFiles(context,appFile, context.PlcName);

                        // Build and load PLC
                        BuildAndLoadPlc(context, appFile, appName, logFilePath, ref summaryResult);

                        // Build and start HMI
                        BuildAndStartHmi(context, appFile, appName, logFilePath, ref summaryResult);
                    }
                }
            }
        }
        else
        {
            Console.Error.WriteLine("Failed to create the log file.");
        }
        KillProcess(context, "Siemens.Simatic.PlcSim.Advanced.UserInterface");
        context.Log.Information("Apps run done.");
    }

    private static (bool Success, string FilePath) CreateLogFile(BuildContext context, string fileNamePrefix = "app_test_result")
    {
        string timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss"); // Generate the timestamp
        string fileName = $"{fileNamePrefix}_{timestamp}.csv"; // Create the full file name
        string appsRunResultFileName = Path.GetFullPath(Path.Combine(context.AppTestResultsDir, fileName));

        // Create result directory
        try
        {
            context.EnsureDirectoryExists(context.AppTestResultsDir);
        }
        catch (Exception ex)
        {
            context.Log.Error($"Failed to create the directory {context.AppTestResultsDir}: {ex.Message}");
            return (false, null);
        }
        context.Log.Information($"Directory: {context.AppTestResultsDir} has been created.");

        // Create result file
        try
        {
            using (File.Create(appsRunResultFileName)) { }
            context.Log.Information($"File '{appsRunResultFileName}' has been created.");
            return (context.FileExists(appsRunResultFileName), appsRunResultFileName);
        }
        catch (Exception ex)
        {
            context.Log.Error($"Failed to create the file {appsRunResultFileName}: {ex.Message}");
            return (false, null);
        }
    }

    private static void WriteResult(BuildContext context,string textToWrite, string logFilePath, bool appendToSameLine = false)
    {
        // Check if the log file exists
        if (!context.FileExists(logFilePath))
        {
            context.Log.Error($"The specified log file does not exist: {logFilePath}");
            return;
        }

        try
        {
            if (appendToSameLine)
            {
                // Append to the same line without a newline
                File.AppendAllText(logFilePath, textToWrite);
            }
            else
            {
                // Append text with a newline
                File.AppendAllText(logFilePath, textToWrite + Environment.NewLine);
            }

            context.Log.Information($"Text successfully written to file '{logFilePath}'.");
            context.Log.Information("File content:");

            // Read and display the content of the log file
            var fileContent = File.ReadAllText(logFilePath);
            context.Log.Information(fileContent);
        }
        catch (Exception ex)
        {
            context.Log.Error($"An error occurred while writing to the file: {ex.Message}");
        }
    }

    private static void KillProcess(BuildContext context,string processName)
    {
        try
        {
            // Get all processes by name
            Process[] processes = Process.GetProcessesByName(processName);

            if (processes.Length > 0)
            {
                foreach (var process in processes)
                {
                    try
                    {
                        // Attempt to kill the process
                        process.Kill(true); // Forcefully terminate the process
                        context.Log.Information($"Successfully terminated process: {process.ProcessName} (ID: {process.Id})");
                    }
                    catch (Exception ex)
                    {
                        context.Log.Error($"Failed to terminate process: {process.ProcessName} (ID: {process.Id}) - {ex.Message}");
                    }
                }
            }
            else
            {
                context.Log.Information($"No processes named '{processName}' were found.");
            }
        }
        catch (Exception ex)
        {
            context.Log.Error($"An error occurred while attempting to find or kill processes: {ex.Message}");
        }
    }

    private static void InitializePlcSimInstance(BuildContext context, string instanceName)
    {
        string plcSimSourceDir = context.SourceDirPlcSim;
        string memoryCardPath = context.PlcSimVirtualMemoryCardLocation;

        // Validate the memory card path
        if (!context.DirectoryExists(memoryCardPath))
        {
            context.Log.Error($"The provided path for the virtual memory card does not exist: {memoryCardPath}");
            return;
        }

        // Validate the instance name
        if (string.IsNullOrWhiteSpace(instanceName))
        {
            context.Log.Error("The provided instance name is empty.");
            return;
        }

        // Determine the instance path
        string instancePath = Path.GetFullPath(Path.Combine(memoryCardPath, instanceName));

        if (context.DirectoryExists(instancePath))
        {
            // Delete all files and subfolders
            context.Log.Information($"The instance path {instancePath} already exists. It needs to be cleaned before.");
            try
            {
                context.CleanDirectory(instancePath, new CleanDirectorySettings() { Force = true });
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to clean the directory {instancePath}: {ex.Message}");
            }
            context.Log.Information($"Directory {instancePath} has been cleaned.");
        }

        // Create the instance directory
        try
        {
            context.EnsureDirectoryExists(instancePath);
        }
        catch (Exception ex)
        {
            context.Log.Error($"Failed to create directory {instancePath}: {ex.Message}");
            return;
        }
        context.Log.Information($"Directory: {instancePath} has been created.");

        // Source directory for PLC Sim files
        if (!context.DirectoryExists(plcSimSourceDir))
        {
            context.Log.Error($"Source directory for the plcsim {plcSimSourceDir} does not exist.");
            return;
        }

        // Copy plcsim virtual memory card content
        try
        {
            context.CopyDirectory(plcSimSourceDir, instancePath);
        }
        catch (Exception ex)
        {
            context.Log.Error($"Failed to copy plcsim virtual memory card content from: {plcSimSourceDir} to: {instancePath}: {ex.Message}");
            return;
        }
        context.Log.Information($"Plcsim virtual memory card content has been copied succesfullt from: {plcSimSourceDir} to: {instancePath}");
    }

    private static void OverwriteSecurityFiles(BuildContext context, string appYamlFile, string plcName)
    {
        string sourceDirSecurityFiles = context.SourceDirSecurityFiles;

        // Check application YAML file
        if (string.IsNullOrWhiteSpace(appYamlFile))
        {
            context.Log.Error("The provided YAML of the application is empty.");
            return;
        }

        if (!context.FileExists(appYamlFile))
        {
            context.Log.Error($"The provided application file does not exist: {appYamlFile}");
            return;
        }

        string appFolder = Path.GetFullPath(Path.GetDirectoryName(appYamlFile));
        if (string.IsNullOrWhiteSpace(appFolder) || !context.DirectoryExists(appFolder))
        {
            context.Log.Error($"The provided path for the application does not exist: {appFolder}");
            return;
        }


        if (string.IsNullOrWhiteSpace(plcName))
        {
            context.Log.Error("The provided PLC name is empty.");
            return;
        }

        // Check source directory
        if (string.IsNullOrWhiteSpace(sourceDirSecurityFiles))
        {
            context.Log.Error("The provided directory name for the source directory of the security files is empty.");
            return;
        }

        if (!context.DirectoryExists(sourceDirSecurityFiles))
        {
            context.Log.Error($"Source directory for the security file does not exist: {sourceDirSecurityFiles}");
            return;
        }

        // Handle certification folder
        string appCertFolder = Path.Combine(appFolder, "certs");
        if (context.DirectoryExists(appCertFolder))
        {
            context.Log.Information($"The application certification folder {appCertFolder} already exists. It needs to be cleaned before.");
            try
            {
                context.CleanDirectory(appCertFolder, new CleanDirectorySettings() { Force = true});
                context.Log.Information($"The application certification folder {appCertFolder} has been cleaned.");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to clean the application certification folder {appCertFolder}: {ex.Message}");
            }
        }
        else
        {
            try
            {
                context.EnsureDirectoryExists(appCertFolder);
                context.Log.Information($"The application certification folder {appCertFolder} has been created.");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to create the application certification folder {appCertFolder}: {ex.Message}");
            }
        }

        // Handle certification subfolder for the plc: 'plcName'
        string appCertSubFolder = Path.GetFullPath(Path.Combine(appCertFolder, plcName));
        try
        {
            context.EnsureDirectoryExists (appCertSubFolder);
            context.Log.Information($"The application certification  subfolder {appCertSubFolder} has been created.");
        }
        catch (Exception ex)
        {
            context.Log.Error($"Failed to create the application certification folder {appCertSubFolder}: {ex.Message}");
        }

        // Handle certification file
        string plcSourceCertificateFile = $"{plcName}.cer";
        string plcSourceCertificate = Path.GetFullPath(Path.Combine(sourceDirSecurityFiles, plcSourceCertificateFile));
        if (context.FileExists(plcSourceCertificate))
        {
            try
            {
                context.CopyFileToDirectory(plcSourceCertificate, appCertSubFolder);
                context.Log.Information($"Certification file '{plcSourceCertificateFile}' has been copied to: {appCertSubFolder}");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to copy the certification file '{plcSourceCertificateFile}': {ex.Message}");
            }
        }
        else
        {
            context.Log.Error($"Certification file '{plcSourceCertificateFile}' does not exist in the directory: {sourceDirSecurityFiles}");
        }

        // Handle hwc folder
        string appHwcFolder = Path.GetFullPath(Path.Combine(appFolder, "hwc"));
        if (!context.DirectoryExists(appHwcFolder))
        {
            context.Log.Error($"The application's hwc folder does not exist: {appHwcFolder}");
            return;
        }

        // Handle hwc.gen subfolder
        string appHwcGenFolder = Path.GetFullPath(Path.Combine(appHwcFolder, "hwc.gen"));
        if (context.DirectoryExists(appHwcGenFolder))
        {
            context.Log.Information($"The application's hwc.gen subfolder {appHwcGenFolder} already exists. It needs to be cleaned before.");
            try
            {
                context.CleanDirectory(appHwcGenFolder, new CleanDirectorySettings() { Force = true });
                context.Log.Information($"The application's hwc.gen subfolder {appHwcGenFolder} has been cleaned.");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to clean the application's hwc.gen subfolder {appHwcGenFolder}: {ex.Message}");
            }
        }
        else
        {
            try
            {
                context.EnsureDirectoryExists(appHwcGenFolder);
                context.Log.Information($"The application's hwc.gen subfolder {appHwcGenFolder} has been created.");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to create the application's hwc.gen subfolder {appHwcGenFolder}: {ex.Message}");
            }
        }

        // Handle secutity configuration file
        string securityConfigFileName = $"{plcName}.SecurityConfiguration.json";
        string securityConfigFile = Path.GetFullPath(Path.Combine(sourceDirSecurityFiles, securityConfigFileName));
        if (context.FileExists(securityConfigFile))
        {
            try
            {
                context.CopyFileToDirectory(securityConfigFile, appHwcGenFolder);
                context.Log.Information($"Security configuration file '{securityConfigFileName}' successfully copied to: {appHwcGenFolder}");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to copy the file: {ex.Message}");
            }
        }
        else
        {
            context.Log.Information($"Security configuration file '{securityConfigFileName}' does not exist in the directory: {sourceDirSecurityFiles}");
        }
    }

    private static void BuildAndLoadPlc(BuildContext context, string appYamlFile, string appName, string logFilePath, ref bool summaryResult)
    {
        string plcName = context.PlcName;
        string plcIpAddress = context.PlcIpAddress;

        // Validate application YAML file
        if (string.IsNullOrWhiteSpace(appYamlFile))
        {
            context.Log.Error("The provided YAML of the application is empty.");
            return;
        }

        if (!File.Exists(appYamlFile))
        {
            context.Log.Error($"The provided application file does not exist: {appYamlFile}");
            return;
        }

        if (string.IsNullOrWhiteSpace(appName))
        {
            context.Log.Error("The provided application name is empty.");
            return;
        }

        string appFolder = Path.GetDirectoryName(appYamlFile);
        if (string.IsNullOrWhiteSpace(appFolder) || !Directory.Exists(appFolder))
        {
            context.Log.Error($"The provided path for the application does not exist: {appFolder}");
            return;
        }

        // Run "apax install"
        ApaxCmd.ApaxInstall(context,appFolder);

        // Run "apax plcsim"
        ApaxCmd.ApaxPlcSim(context, appFolder);

        // Run "apax hwu"
        string hwuResult = ApaxCmd.ApaxHwu(context, appFolder, ref summaryResult);
        WriteResult(context, hwuResult, logFilePath, appendToSameLine: true);

        // Run "apax swfd"
        string swfdResult = ApaxCmd.ApaxSwfd(context, appFolder, ref summaryResult);
        WriteResult(context, swfdResult, logFilePath, appendToSameLine: true);
    }

    public static void BuildAndStartHmi(BuildContext context, string appYamlFile, string appName, string logFilePath, ref bool summaryResult)
    {
        // Validate application YAML file
        if (string.IsNullOrWhiteSpace(appYamlFile))
        {
            context.Log.Error("The provided YAML of the application is empty.");
            return;
        }

        if (!context.FileExists(appYamlFile))
        {
            context.Log.Error($"The provided application file does not exist: {appYamlFile}");
            return;
        }

        if (string.IsNullOrWhiteSpace(appName))
        {
            context.Log.Error("The provided application name is empty.");
            return;
        }

        string appFolder = Path.GetFullPath(Path.GetDirectoryName(appYamlFile));
        if (string.IsNullOrWhiteSpace(appFolder) || !context.DirectoryExists(appFolder))
        {
            context.Log.Error($"The provided path for the application does not exist: {appFolder}");
            return;
        }

        // Recreate solution file by running the slngen script
        string slnGenPath = Path.GetFullPath(Path.GetFullPath(Path.Combine (appFolder, "..", "./slngen.ps1")));
        DotNetCmd.RunPowershellScript(context,slnGenPath, "");

        // Clean solution
        string solutionFile = Path.GetFullPath(Path.Combine(appFolder, "../this.sln"));
        DotNetCmd.DotNetClean(context, solutionFile, "-c Debug");

        // Build solution
        string buildResult = DotNetCmd.DotNetBuildWithResult(context, solutionFile, "-c Debug",ref summaryResult);
        WriteResult(context, buildResult, logFilePath, appendToSameLine: true );

        // Get blazor projects
        var blazorFiles = Directory.GetFiles(appFolder, "*.csproj", SearchOption.AllDirectories).Where(file => file.Contains("blazor")).ToList();

        if (blazorFiles.Any())
        {
            foreach (var blazorFile in blazorFiles)
            {
                context.Log.Information($"Application 'blazor' file: {blazorFile}");

                // Filter out libraries by checking for <PackageId> in the project file
                string csprojContent = File.ReadAllText(blazorFile);
                if (!csprojContent.Contains("<PackageId>"))
                {
                    string runResult = DotNetCmd.DotNetRunWithResult(context, blazorFile, "-c Debug --framework net9.0",60 , ref summaryResult);
                    WriteResult(context, runResult, logFilePath, appendToSameLine: true);
                }
            }
        }
        else
        {
            context.Log.Information("No files containing 'blazor' in the filename and ending with '.csproj' were found.");
        }
    }

}

[TaskName("CreateArtifacts")]
[IsDependentOn(typeof(AppsRunTask))]
public sealed class CreateArtifactsTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (context.BuildParameters.DoPack)
        {
            //context.Libraries.ToList().ForEach(lib =>
            //{
            //    foreach (var apaxfile in context.GetApaxFiles(lib))
            //    {
            //        context.ApaxChangeBuildProperties(apaxfile, new string[] { "\"1500\"", "llvm", "plcsim" }, new[] { "bin", "axsharp.companion.json" });
            //    }
            //});
        }
        
        if (!context.BuildParameters.DoPack)
        {
            context.Log.Warning($"Skipping packaging.");
            return;
        }

        //PackApax(context);
        PackNugets(context);
    }

    private static void PackApax(BuildContext context)
    {
        context.Libraries.ToList().ForEach(lib =>
        {
            context.ApaxPack(lib);
            context.ApaxCopyArtifacts(lib);
        });
    }


    private static void PackNugets(BuildContext context)
    {
        context.DotNetPack(context.PackableNugetsSlnf, 
            new Cake.Common.Tools.DotNet.Pack.DotNetPackSettings()
        {
            OutputDirectory = Path.Combine(context.ArtifactsNugets),
            NoRestore = true,
            NoBuild = false,
        });
    }
}

[TaskName("PushPackages task")]
[IsDependentOn(typeof(CreateArtifactsTask))]
public sealed class PushPackages : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (!context.BuildParameters.DoPublish)
        {
            context.Log.Warning($"Skipping package push.");
            return;
        }

        if (Helpers.CanReleaseInternal())
        {
            context.ApaxPublish();
       

        foreach (var nugetFile in Directory.EnumerateFiles(Path.Combine(context.Artifacts, @"nugets"), "*.nupkg")
                         .Select(p => new FileInfo(p)))
            {
                context.DotNetNuGetPush(nugetFile.FullName,
                    new Cake.Common.Tools.DotNet.NuGet.Push.DotNetNuGetPushSettings()
                    {
                        ApiKey = context.GitHubToken,
                        Source = "https://nuget.pkg.github.com/ix-ax/index.json",
                        SkipDuplicate = true
                    });
            }
        }
    }
}

[TaskName("Publish release")]
[IsDependentOn(typeof(PushPackages))]
public sealed class PublishReleaseTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (!context.BuildParameters.DoPublishRelease)
        {
            context.Log.Warning($"Skipping package release.");
            return;
        }

        if (Helpers.CanReleaseInternal())
        {
            var githubToken = context.Environment.GetEnvironmentVariable("GH_TOKEN");
            var githubClient = new GitHubClient(new ProductHeaderValue("IX"));
            githubClient.Credentials = new Credentials(githubToken);

            var release = githubClient.Repository.Release.Create(
                "ix-ax",
                "AXOpen",
                new NewRelease($"{GitVersionInformation.SemVer}")
                {
                    Name = $"{GitVersionInformation.SemVer}",
                    TargetCommitish = GitVersionInformation.Sha,
                    Body = $"Release v{GitVersionInformation.SemVer}",
                    Draft = !Helpers.CanReleasePublic(),
                    Prerelease = !string.IsNullOrEmpty(GitVersionInformation.PreReleaseTag)
                }
            ).Result;
        }
    }
}

[TaskName("Default")]
[IsDependentOn(typeof(PublishReleaseTask))]
public class DefaultTask : FrostingTask
{
}