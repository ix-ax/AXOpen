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
using Cake.Common;
using Cake.Common.IO;
using Cake.Common.Tools.DotNet;
using Cake.Common.Tools.DotNet.Clean;
using Cake.Core.Diagnostics;
using Cake.Core.IO;
using Cake.Core.Tooling;
using Cake.Frosting;
using Cake.Powershell;
using CliWrap;
using CommandLine;
using Ix.Compiler;
using Microsoft.Extensions.DependencyInjection;
using NuGet.Packaging;
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
        context.Libraries.ToList().ForEach(lib => context.ApaxClean(lib));
        context.Integrations.ToList().ForEach(integration => context.ApaxClean(integration));
        context.DotNetClean(Path.Combine(context.RootDir, "ix.framework.sln"), new DotNetCleanSettings() { Verbosity = context.BuildParameters.Verbosity});
        context.CleanDirectory(context.Artifacts);       
    }
}

[TaskName("Provision")]
[IsDependentOn(typeof(CleanUpTask))]
public sealed class ProvisionTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        ProvisionTools(context);
    }

    private static void ProvisionTools(BuildContext context)
    {
        context.ProcessRunner.Start(@"dotnet", new Cake.Core.IO.ProcessSettings()
        {
            Arguments = $" tool restore",

        });
    }
}

[TaskName("Build")]
[IsDependentOn(typeof(ProvisionTask))]
public sealed class BuildTask : FrostingTask<BuildContext>
{

    private void UpdateApaxVersion(string file, string version)
    {
        var sb = new StringBuilder();
        foreach (var line in System.IO.File.ReadLines(file))
        {
            var newLine = line;

            if (line.Trim().StartsWith("version"))
            {
                var semicPosition = line.IndexOf(":");
                var lenght = line.Length - semicPosition;

                newLine = $"{line.Substring(0, semicPosition)} : '{version}'";
            }
            sb.AppendLine(newLine);
        }

        System.IO.File.WriteAllText(file, sb.ToString());
    }

    public override void Run(BuildContext context)
    {
        context.Libraries.ToList().ForEach(lib => 
        {
            UpdateApaxVersion(context.GetApaxFile(lib), GitVersionInformation.SemVer);
            context.ApaxInstall(lib);
            context.ApaxBuild(lib);
        });

        context.Integrations.ToList().ForEach(proj => context.ApaxInstall(proj));
        context.Integrations.ToList().ForEach(proj => context.ApaxBuild(proj));

        context.DotNetBuild(Path.Combine(context.RootDir, "ix.framework.sln"), context.DotNetBuildSettings);
    }
}

[TaskName("Test")]
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

        context.Libraries.ToList().ForEach(lib => context.ApaxTest(lib));
        context.Integrations.ToList().ForEach(proj => context.ApaxTest(proj));
        context.DotNetTest(Path.Combine(context.RootDir, "ix.framework.sln"), context.DotNetTestSettings);
    }
}

[TaskName("CreateArtifacts")]
[IsDependentOn(typeof(TestsTask))]
public sealed class CreateArtifactsTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (!context.BuildParameters.DoPublish)
        {
            context.Log.Warning($"Skipping packaging.");
            return;
        }

        context.Libraries.ToList().ForEach(lib => context.ApaxPack(lib));

        PackPackages(context, Path.Combine(context.RootDir, "ix.framework-packable-only.slnf"));
    }

    private static void PackTemplatePackages(BuildContext context, string solutionToPack)
    {
        context.DotNetPack(solutionToPack,
            new Cake.Common.Tools.DotNet.Pack.DotNetPackSettings()
            {
                OutputDirectory = Path.Combine(context.Artifacts, @"nugets"),
                Sources = new List<string>() { Path.Combine(context.Artifacts, "nugets") },
                NoRestore = false,
                NoBuild = false,
            });
    }

    private static void PackPackages(BuildContext context, string solutionToPack)
    {
        context.DotNetPack(solutionToPack, 
            new Cake.Common.Tools.DotNet.Pack.DotNetPackSettings()
        {
            OutputDirectory = Path.Combine(context.Artifacts, @"nugets"),
            NoRestore = true,
            NoBuild = false,
        });
    }
}

[TaskName("GenerateApiDocumentation")]
[IsDependentOn(typeof(CreateArtifactsTask))]
public sealed class GenerateApiDocumentationTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (!context.BuildParameters.DoDocs)
        {
            context.Log.Warning($"Skipping documentation generation.");
            return;
        }

        if (Helpers.CanReleaseInternal())
        {
            //GenerateApiDocumentation(context,
            //    @$"ix.connectors\src\Ix.Connector\bin\{context.DotNetBuildSettings.Configuration}\net6.0\Ix.Connector.dll",
            //    @"Ix.Connector");
            //GenerateApiDocumentation(context,
            //    @$"ix.connectors\src\Ix.Connector.S71500.WebAP\bin\{context.DotNetBuildSettings.Configuration}\net6.0\Ix.Connector.S71500.WebAPI.dll",
            //    @"Ix.Connector.S71500.WebAPI");

            //GenerateApiDocumentation(context,
            //    @$"ix.builder\src\IX.Compiler\bin\{context.DotNetBuildSettings.Configuration}\net6.0\IX.Compiler.dll",
            //    @"IX.Compiler");
            //GenerateApiDocumentation(context,
            //    @$"ix.builder\src\IX.Cs.Compiler\bin\{context.DotNetBuildSettings.Configuration}\net6.0\IX.Compiler.Cs.dll",
            //    @"IX.Compiler.Cs");

            //GenerateApiDocumentation(context,
            //    @$"ix.abstractions\src\Ix.Abstractions\bin\{context.DotNetBuildSettings.Configuration}\net6.0\Ix.Abstractions.dll",
            //    @"Ix.Abstractions");
            //GenerateApiDocumentation(context,
            //    @$"ix.blazor\src\Ix.Presentation.Blazor\bin\{context.DotNetBuildSettings.Configuration}\net6.0\Ix.Presentation.Blazor.dll",
            //    @"Ix.Presentation.Blazor");
            //GenerateApiDocumentation(context,
            //    @$"ix.blazor\src\Ix.Presentation.Blazor.Controls\bin\{context.DotNetBuildSettings.Configuration}\net6.0\Ix.Presentation.Blazor.Controls.dll",
            //    @"Ix.Presentation.Blazor.Controls");
        }
    }

    private static void GenerateApiDocumentation(BuildContext context, string assemblyFile, string outputDocDirectory)
    {
        context.Log.Information($"Generating documentation for {assemblyFile}");
        var docXmlFile = Path.Combine(context.RootDir, assemblyFile);
        var docDirectory = Path.Combine(context.ApiDocumentationDir, outputDocDirectory);
        context.ProcessRunner.Start(@"dotnet", new Cake.Core.IO.ProcessSettings()
        {
            Arguments = $"xmldocmd {docXmlFile} {docDirectory}"
        }).WaitForExit();
    }
}


[TaskName("Check license compliance")]
[IsDependentOn(typeof(GenerateApiDocumentationTask))]
public sealed class LicenseComplianceCheckTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        ////var licensedFiles = Directory.EnumerateFiles(Path.Combine(context.RootDir, "apax", ".apax", "packages"),
        //var licensedFiles = Directory.EnumerateFiles(Path.Combine(context.RootDir, "apax", "stc"),
        //    "AX.*.*",
        //    SearchOption.AllDirectories)
        //    .Select(p => new FileInfo(p));

        //if (licensedFiles.Count() < 5)
        //    throw new Exception("");


        //foreach (var nugetFile in Directory.EnumerateFiles(context.Artifacts, "*.nupkg", SearchOption.AllDirectories))
        //{
        //    using (var zip = ZipFile.OpenRead(nugetFile))
        //    {
        //        var ouptutDir = Path.Combine(context.Artifacts, "verif");
        //        zip.ExtractToDirectory(Path.Combine(context.Artifacts, "verif"));

        //        if (Directory.EnumerateFiles(ouptutDir, "*.*", SearchOption.AllDirectories)
        //            .Select(p => new FileInfo(p))
        //            .Any(p => licensedFiles.Any(l => l.Name == p.Name)))
        //        {
        //            throw new Exception("");
        //        }

        //        Directory.Delete(ouptutDir, true);
        //    }
        //}
    }
}


[TaskName("PushPackages task")]
[IsDependentOn(typeof(LicenseComplianceCheckTask))]
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
            context.Libraries.ToList().ForEach(lib => context.ApaxPublish(lib));
       

        foreach (var nugetFile in Directory.EnumerateFiles(Path.Combine(context.Artifacts, @"nugets"), "*.nupkg")
                         .Select(p => new FileInfo(p)))
            {
                context.DotNetNuGetPush(nugetFile.FullName,
                    new Cake.Common.Tools.DotNet.NuGet.Push.DotNetNuGetPushSettings()
                    {
                        ApiKey = Environment.GetEnvironmentVariable("GH_TOKEN"),
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
                "ix.framework",
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