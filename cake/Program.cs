// Build
// Copyright (c) 2023 MTS spol. s r.o,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/AXOpen/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/AXOpen/blob/master/LICENSE
// Third party licenses: https://github.com/inxton/AXOpen/blob/master/notices.md


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
        if (context.BuildParameters.PublishOnly)
        {
            context.Log.Information("Skipping. Publish only.");
            return;
        }

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

        context.DotNetClean(Path.Combine(context.RootDir, "AXOpen.proj"), new DotNetCleanSettings() { Verbosity = context.BuildParameters.Verbosity });
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
        if (context.BuildParameters.PublishOnly)
        {
            context.Log.Information("Skipping. Publish only.");
            return;
        }

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

[TaskName("CatalogInstall")]
[IsDependentOn(typeof(ProvisionTask))]
public sealed class CatalogInstallTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (context.BuildParameters.PublishOnly)
        {
            context.Log.Information("Skipping. Publish only.");
            return;
        }

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
        if (context.BuildParameters.PublishOnly)
        {
            context.Log.Information("Skipping. Publish only.");
            return;
        }

        if (context.BuildParameters.DoPack)
        {
            context.Libraries.ToList().ForEach(lib =>
            {
                foreach (var apaxfile in context.GetApaxFiles(lib))
                {
                    context.UpdateApaxVersion(apaxfile, GitVersionInformation.SemVer);
                    context.UpdateApaxDependencies(apaxfile, GitVersionInformation.SemVer);
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
            context.ApaxBuild(new[] { traversalProjectFolder });
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
        if (context.BuildParameters.PublishOnly)
        {
            context.Log.Information("Skipping. Publish only.");
            return;
        }

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
        if (context.BuildParameters.TestLevel >= 3)
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

        AppsRunTaskHelpers.KillProcess(context,"Siemens.Simatic.PlcSim.Advanced.UserInterface");

        bool summaryResult = true;

        if (string.IsNullOrEmpty(context.BuildParameters.AppRunOnlyFolderName))
        {
            var createResult = AppsRunTaskHelpers.CreateLogFile(context, "app_test_result");

            if (createResult.Success)
            {
                string logFilePath = createResult.FilePath;
                AppsRunTaskHelpers.WriteResult(context, "AppName,PlcSim,PlcHw,PlcSw,DotnetBuild,DotnetRun", logFilePath);

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
                            AppsRunTaskHelpers.WriteResult(context, " ", logFilePath);
                            AppsRunTaskHelpers.WriteResult(context, appName, logFilePath, appendToSameLine: true);

                            // Cleanup JSONREPOS
                            AppsRunTaskHelpers.DeleteJsonReposFolder(context, appFolder);

                            // Initialize PLC Sim instance
                            AppsRunTaskHelpers.InitializePlcSimInstance(context, appName);

                            // Overwrite security files
                            AppsRunTaskHelpers.OverwriteSecurityFiles(context, appFile, context.PlcName);

                            // Build and load PLC
                            AppsRunTaskHelpers.BuildAndLoadPlc(context, appFile, appName, logFilePath, ref summaryResult);

                            // Build and start HMI
                            AppsRunTaskHelpers.BuildAndStartHmi(context, appFile, appName, logFilePath, ref summaryResult);


                        }
                    }
                }
                
                if (!summaryResult)
                {
                    context.Log.Error($"App run failed for some of the applications.");
                    context.Log.Error($"Good luck with finding out the reason :-).");
                    Environment.Exit(1);
                }
            }
            else
            {
                Console.Error.WriteLine("Failed to create the log file.");
            }
        }
        else
        {
            var createResult = AppsRunTaskHelpers.CreateLogFile(context, "single_app_test_result");

            if (createResult.Success)
            {
                string logFilePath = createResult.FilePath;
                AppsRunTaskHelpers.WriteResult(context, "AppName,ApaxInstall,ApaxPlcSim,ApaxGsd,ApaxHwl,ApaxHwcc,ApaxHwid,ApaxHwadr,ApaxHwdo,ApaxBuild,DotnetIxc,ApaxSlfdo,Slngen,DotnetClean,DotnetBuild,DotnetRun", logFilePath);

                string appFolder = Path.Combine(Path.Combine(context.RootDir, context.BuildParameters.AppRunOnlyFolderName), "app");
                string appFile = context.GetApaxFile(appFolder);
                string appName = context.GetApplicationName(appFile);

                if (!string.IsNullOrEmpty(appFolder) && context.DirectoryExists(appFolder) && !string.IsNullOrEmpty(appFile) && context.FileExists(appFile) && !string.IsNullOrEmpty(appName))
                {
                    // Display the file details
                    context.Log.Information($"###################################################");
                    context.Log.Information($"Starting the application: {appName}");
                    context.Log.Information($"File of the application: {appFile}");
                    context.Log.Information($"###################################################");
                    AppsRunTaskHelpers.WriteResult(context, " ", logFilePath);
                    AppsRunTaskHelpers.WriteResult(context, appName, logFilePath, appendToSameLine: true);

                    // Cleanup JSONREPOS
                    AppsRunTaskHelpers.DeleteJsonReposFolder(context, appFolder);

                    // Initialize PLC Sim instance
                    AppsRunTaskHelpers.InitializePlcSimInstance(context, appName);

                    // Overwrite security files
                    AppsRunTaskHelpers.OverwriteSecurityFiles(context, appFile, context.PlcName);

                    // Build and load PLC, build and start HMI with more grannular evaluation
                    AppsRunTaskHelpers.AppRunDetailed(context, appFile, appName, logFilePath, ref summaryResult);

                    if (!summaryResult)
                    {
                        context.Log.Error($"App run failed for the application name: '{appName}', application file: '{appFile}' in folder: '{appFolder}'");
                        Environment.Exit(1);
                    }
                }
            }
            else
            {
                Console.Error.WriteLine("Failed to create the log file.");
            }
        }

        AppsRunTaskHelpers.KillProcess(context, "Siemens.Simatic.PlcSim.Advanced.UserInterface");
        context.Log.Information("Apps run done.");
    }
}

[TaskName("CreateArtifacts")]
[IsDependentOn(typeof(AppsRunTask))]
public sealed class CreateArtifactsTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (context.BuildParameters.PublishOnly)
        {
            context.Log.Information("Skipping. Publish only.");
            return;
        }

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
            if(int.Parse(GitVersionInformation.Major) >= 1)
            {
                context.ApaxPublish();
            }
       

            foreach (var nugetFile in Directory.EnumerateFiles(Path.Combine(context.Artifacts, @"nugets"), "*.nupkg")
                         .Select(p => new FileInfo(p)))
            {
                context.DotNetNuGetPush(nugetFile.FullName,
                    new Cake.Common.Tools.DotNet.NuGet.Push.DotNetNuGetPushSettings()
                    {
                        ApiKey = context.GitHubToken,
                        Source = "https://nuget.pkg.github.com/inxton/index.json",
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
            var githubClient = new GitHubClient(new ProductHeaderValue("AXOPEN"));
            githubClient.Credentials = new Credentials(githubToken);

            var release = githubClient.Repository.Release.Create(
                "inxton",
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
