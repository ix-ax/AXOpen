// Build
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/ix/blob/master/LICENSE
// Third party licenses: https://github.com/ix-ax/ix/blob/master/notices.md


using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.IO;
using System.IO.Compression;
using System.IO.Packaging;
using System.Linq;
using System.Management.Automation;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Build.FilteredSolution;
using Cake.Common;
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
using Octokit;
using Polly;
using Spectre.Console;
using static System.Net.WebRequestMethods;
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

        if (context.BuildParameters.Paralellize)
        {
            Parallel.ForEach(context.Libraries, lib => context.ApaxClean(lib));
        }
        else
        {
            context.Libraries.ToList().ForEach(lib => context.ApaxClean(lib));
        }


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

[TaskName("Build")]
[IsDependentOn(typeof(ApaxUpdateTask))]
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
        }

        if (!context.BuildParameters.NoBuild)
        {
            if (context.BuildParameters.Paralellize)
            {
                Parallel.ForEach(context.Libraries, lib => context.ApaxInstall(lib));
                Parallel.ForEach(context.Libraries, lib => context.ApaxBuild(lib));
                context.Libraries.ToList().ForEach(lib => context.ApaxIxc(lib));
            }
            else
            {
                context.Libraries.ToList().ForEach(lib =>
                {
                    context.ApaxInstall(lib);
                    context.ApaxBuild(lib);
                    context.ApaxIxc(lib);
                });
            }

            context.DotNetBuild(Path.Combine(context.RootDir, "AXOpen.proj"), context.DotNetBuildSettings);
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
            Parallel.ForEach(context.Libraries, context.ApaxTest);
        }
        else
        {
            context.Libraries.ToList().ForEach(context.ApaxTest);
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

                if(Directory.Exists(app))
                    context.ApaxDownload(app);
                else if(Directory.Exists(ax))
                    context.ApaxDownload(ax);
                else
                    throw new Exception($"No app or ax folder found for {package.folder}");    

                context.DotNetTest(Path.Combine(context.RootDir, package.folder, "tmp_L3_.proj"), context.DotNetTestSettings);
            }
        }

        context.Log.Information("Tests done.");
    }

    private static void RunTestsFromFilteredSolution(BuildContext context, string filteredSolutionFile)
    {
        foreach (var project in FilteredSolution.Parse(filteredSolutionFile).solution.projects
                     .Select(p => new FileInfo(Path.Combine(context.RootDir, p)))
                     .Where(p => p.Name.ToUpperInvariant().Contains("TEST")))
        {
            foreach (var framework in context.TargetFrameworks)
            {
                context.DotNetTestSettings.VSTestReportPath = Path.Combine(context.TestResults, $"{project.Name}_{framework}.xml");
                context.DotNetTestSettings.Framework = framework;
                context.DotNetTest(Path.Combine(project.FullName), context.DotNetTestSettings);
            }
        }
    }
}

[TaskName("CreateArtifacts")]
[IsDependentOn(typeof(TestsTask))]
public sealed class CreateArtifactsTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (!context.BuildParameters.DoPack)
        {
            context.Log.Warning($"Skipping packaging.");
            return;
        }

        PackApax(context);
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