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
using System.Net.Http;
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
        // CaseInsensitiveEnumValues lets --publish-target accept gitlab/github in any case
        // (CI passes lowercase); HelpWriter keeps the default error/help output of Parser.Default.
        using var parser = new Parser(settings =>
        {
            settings.CaseInsensitiveEnumValues = true;
            settings.HelpWriter = Console.Error;
        });
        parser.ParseArguments<BuildParameters>(args)
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

        if (context.IsGitHubActions || context.IsGitLabCI)
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

        // provision nodejs
        context.ProvisionNodeJs();

        // with this we will enforce use of specific apax version at least temporarily 
        // due to issues with apax versions in some environments.
        context.ApaxSelfUpdate("4.3.0");
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
            var apaxFiles = new List<string>();
            context.Log.Information("Collecting .apax files.");
            ApaxTraversal.CollectApaxFileInfoRecursively(context.RootDir, new List<string>() { ".apax", "traversals" }, apaxFiles);

            context.Libraries.ToList().ForEach(lib =>
            {
                //foreach (var apaxfile in context.GetApaxFiles(lib))               
                foreach (var apaxfile in apaxFiles)
                {
                    context.UpdateApaxVersion(apaxfile, GitVersionInformation.SemVer);
                    context.UpdateApaxDependencies(apaxfile, GitVersionInformation.SemVer);
                }
            });
        }
        
       // context.DotnetIxr(context.Libraries.Where(p => p.pack && Directory.Exists(Path.Combine(context.RootDir, p.folder, "ctrl", "src"))).Select(p => Path.Combine(context.RootDir, p.folder, "ctrl")));

        var traversalProjectFolder = Path.Combine(context.RootDir, "traversals", "apax");
        if (!context.BuildParameters.NoBuild || context.BuildParameters.DoPack)
        {
            var traversalProject = Path.Combine(traversalProjectFolder, "apax.yml");
            context.Log.Information("Creating apax traversal.");
            context.CreateApaxTraversal(context.RootDir, traversalProject);
            context.ApaxInstall(new[] { traversalProjectFolder });
            context.DotnetIxc(new[] { traversalProjectFolder });
            context.DotNetBuildSettings.Verbosity = DotNetVerbosity.Quiet;
            context.DotNetBuildSettings.NoRestore = true;
            context.DotNetBuildSettings.MSBuildSettings.Properties.Add("NoWarn", new List<string>()
            { "1234;2345;8602;10012;8618;0162;8605;1416;3270;1504;8600;8618;" +
                "CS0618;CS1591;BL0007;BL0005;CA1416;CA2200;CS0105;CS0108;CS0109;CS0162;CS0168;CS0169;CS219;CS0414;CS0436;CS0472;CS0618;CS1591;CS1998;CS8604;" +
                "CS8601;SYSLIB0051;SYSLIB0014;CS8625;CS0219;CS8625;CS8625;CS8620;RZ2012;RZ10012;CS4014;CS8981;CS8603;CS8766;CS8619;CS0649;CS8321"
            });
            
            
           

            context.DotNetRestore(Path.Combine(context.RootDir, "AXOpen.proj"));
            BuildTailwindCss(context);

            context.DotNetBuild(Path.Combine(context.RootDir, "AXOpen.proj"), context.DotNetBuildSettings);

             var showcaseAppFolder = Path.Combine(context.RootDir, "showcase", "app");
            if (File.Exists(Path.Combine(showcaseAppFolder, "apax.yml")))
            {
                context.Log.Information("---------------------------------");
                context.Log.Information("Building showcase application (PLC).");
                context.Log.Information("---------------------------------");
                context.ApaxInstall(new[] { showcaseAppFolder });
                context.ApaxBuild(new[] { showcaseAppFolder });
                context.DotnetIxc(new[] { showcaseAppFolder });
            }
        }

        


        if (!context.BuildParameters.NoBuild && !context.BuildParameters.DoTest && !context.BuildParameters.DoPack)
        {
            context.Log.Information("Creating apax traversal.");
            context.ApaxBuild(new[] { traversalProjectFolder });
        }


        // Clean up travversal files after build remove apax.yml and .apax folder
        context.DeleteFile(Path.Combine(traversalProjectFolder, "apax.yml"));

        //System.IO.Directory.Delete(Path.Combine(traversalProjectFolder, ".apax"), true);

    }

    private void BuildTailwindCss(BuildContext context)
    {
        var stylingFolder = Path.Combine(context.RootDir, "styling", "src");
        var nodeModulesFolder = Path.Combine(stylingFolder, "node_modules");

        context.Log.Information($"Building Tailwind CSS in folder: {stylingFolder}");

        // Check if node_modules exists, if not install packages
        if (!Directory.Exists(nodeModulesFolder))
        {
            context.Log.Information("node_modules not found. Installing npm packages...");
            var npmInstall = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = "cmd.exe",
                    Arguments = "/c npm install",
                    WorkingDirectory = stylingFolder,
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    CreateNoWindow = true
                }
            };
            npmInstall.OutputDataReceived += (sender, e) => { if (e.Data != null) Console.WriteLine(e.Data); };
            npmInstall.ErrorDataReceived += (sender, e) => { if (e.Data != null) Console.Error.WriteLine(e.Data); };
            npmInstall.Start();
            npmInstall.BeginOutputReadLine();
            npmInstall.BeginErrorReadLine();
            npmInstall.WaitForExit();

            if (npmInstall.ExitCode != 0)
            {
                throw new Exception($"npm install failed with exit code {npmInstall.ExitCode}");
            }
        }

        // Run the tailwind build using npx
        context.Log.Information("Running Tailwind build...");
        var npxBuild = new Process
        {
            StartInfo = new ProcessStartInfo
            {
                FileName = "cmd.exe",
                Arguments = "/c npx @tailwindcss/cli -i ./wwwroot/css/tailwind.css -o ./wwwroot/css/momentum.css --minify",
                WorkingDirectory = stylingFolder,
                UseShellExecute = false,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                CreateNoWindow = true
            }
        };
        npxBuild.OutputDataReceived += (sender, e) => { if (e.Data != null) Console.WriteLine(e.Data); };
        npxBuild.ErrorDataReceived += (sender, e) => { if (e.Data != null) Console.Error.WriteLine(e.Data); };
        npxBuild.Start();
        npxBuild.BeginOutputReadLine();
        npxBuild.BeginErrorReadLine();
        npxBuild.WaitForExit();

        if (npxBuild.ExitCode != 0)
        {
            throw new Exception($"Tailwind CSS build failed with exit code {npxBuild.ExitCode}");
        }

        context.Log.Information("Tailwind CSS build completed.");
    }
}

[TaskName("TemplateTest")]
[IsDependentOn(typeof(BuildTask))]
public sealed class TemplateTestTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (context.BuildParameters.PublishOnly)
        {
            context.Log.Information("Skipping. Publish only.");
            return;
        }

        if (!context.BuildParameters.DoTemplateTest)
        {
            context.Log.Information("Skipping template test.");
            return;
        }

        // scripts/create_library_from_template.ps1 lives one level above 'src' (RootDir).
        var script = Path.GetFullPath(Path.Combine(context.RootDir, "..", "scripts", "create_library_from_template.ps1"));

        // The library MUST be generated inside 'src' (the apax workspace) so its
        // '@inxton/*' dependencies (pinned at 0.0.0-dev.0) resolve locally from the
        // sibling libraries - exactly how every repo library resolves them. This task
        // removes the generated folder again in the finally block.
        var libraryFolder = "components.citemplate";
        var generated = Path.Combine(context.RootDir, libraryFolder);

        // Guard against a stale copy left by an interrupted previous run.
        if (Directory.Exists(generated))
        {
            Directory.Delete(generated, true);
        }

        try
        {
            context.Log.Information("---------------------------------");
            context.Log.Information("Template test: scaffolding library from template.axolibrary");
            context.Log.Information("---------------------------------");

            // Scaffold + build the library (apax build in ctrl + dotnet build this.proj).
            // -OutputRoot defaults to 'src', so it is intentionally not passed here.
            context.RunPowershellScriptOrThrow(script, $"-LibraryFolder {libraryFolder}");

            // L1: build + run the generated .NET twin tests via the per-library traversal.
            var thisProj = Path.Combine(generated, "this.proj");
            if (File.Exists(thisProj))
            {
                var testSettings = new Cake.Common.Tools.DotNet.Test.DotNetTestSettings()
                {
                    Configuration = context.BuildParameters.Configuration,
                    Verbosity = context.BuildParameters.Verbosity,
                    NoBuild = false,
                    NoRestore = false,
                    ResultsDirectory = context.TestResults
                };
                context.DotNetTest(thisProj, testSettings);
            }
            else
            {
                context.Log.Warning($"No 'this.proj' found at '{generated}'; skipping generated-library tests.");
            }

            context.Log.Information("Template test passed.");
        }
        finally
        {
            // Never leave the throwaway library behind in 'src', even on failure.
            if (Directory.Exists(generated))
            {
                try
                {
                    Directory.Delete(generated, true);
                }
                catch (Exception ex)
                {
                    context.Log.Warning($"Template test cleanup failed: {ex.Message}");
                }
            }
        }
    }
}

[TaskName("Tests")]
[IsDependentOn(typeof(TemplateTestTask))]
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
            context.Libraries.Where(p => p.test).ToList().ForEach(lib =>
            {
                context.Log.Information($"---------------------------------");
                context.Log.Information($"Testing {lib.folder}");
                context.Log.Information($"---------------------------------");
                context.ApaxClean(lib);
                context.ApaxInstall(context.GetLibraryAxFolders(lib));
                context.ApaxBuild(context.GetLibraryAxFolders(lib));
                context.ApaxTestLibrary(lib);
                context.ApaxClean(lib);
            });

        }
        else
        {
            context.Libraries.Where(p => p.test).ToList().ForEach(lib =>
            {
                context.Log.Information($"---------------------------------");
                context.Log.Information($"Testing {lib.folder}");
                context.Log.Information($"---------------------------------");
                context.ApaxClean(lib);
                context.ApaxInstall(context.GetLibraryAxFolders(lib));
                context.ApaxBuild(context.GetLibraryAxFolders(lib));
                context.ApaxTestLibrary(lib);
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

            // Offline showcase build: everything `apax alf` does except the PLC-access steps.
            var showcaseApp = Path.Combine(context.RootDir, "showcase", "app", "apax.yml");
            AppsRunTaskHelpers.BuildShowcaseOffline(context, showcaseApp);
        }
        if (context.BuildParameters.TestLevel >= 3)
        {
            foreach (var package in context.Libraries)
            {
                var ax = Path.Combine(context.RootDir, package.folder, "ax");

                if (Directory.Exists(ax))
                {
                    context.ApaxDownload(ax);
                }
                else
                {
                    context.Log.Information($"No ax folder found for {package.folder}");
                    continue;
                }

                context.DotNetTest(Path.Combine(context.RootDir, package.folder, "tmp_L3_.proj"), context.DotNetTestSettings);
            }
        }
        if (context.BuildParameters.TestLevel >= 4)
        {
            // Full end-to-end smoke test of the consolidated showcase app: load the entire PLC
            // (incl. hardware configuration) onto PLCSIM Advanced, then run the Blazor server and
            // assert it serves traffic. Fails the build on any error.
            var showcaseApp = Path.Combine(context.RootDir, "showcase", "app", "apax.yml");
            AppsRunTaskHelpers.RunShowcaseIntegration(context, showcaseApp);
        }

        context.Log.Information("Tests done.");
    }
}

[TaskName("CreateArtifacts")]
[IsDependentOn(typeof(TestsTask))]
public sealed class CreateArtifactsTask : FrostingTask<BuildContext>
{
    public override void Run(BuildContext context)
    {
        if (context.BuildParameters.PublishOnly)
        {
            context.Log.Information("Skipping packaging. Publish only.");
            return;
        }

        if (!context.BuildParameters.DoPack)
        {
            context.Log.Warning($"Skipping packaging.");
            return;
        }

        if(context.BuildParameters.DoPack)
        {
            PackApax(context);
            PackNuGets(context);
        }
    }

    private static void PackApax(BuildContext context)
    {
        context.Log.Information($"Pack APAX");
        context.Libraries.ToList().ForEach(lib =>
        {
            foreach (var apaxfile in context.GetApaxFiles(lib))
            {
                context.ApaxChangeBuildProperties(apaxfile, new string[] { "\"1500\"" }, new[] {"assets", "bin/1500", "axsharp.companion.json" });
            }
        });

        if (context.BuildParameters.Paralellize)
        {
            context.Libraries.Where(p => p.pack).ToList().ForEach(lib =>
            {
                context.Log.Information($"---------------------------------");
                context.Log.Information($"Packing {lib.folder}");
                context.Log.Information($"---------------------------------");
                context.ApaxClean(lib);
                context.ApaxInstall(context.GetLibraryAxFolders(lib));
                context.ApaxBuild(context.GetLibraryAxFolders(lib));
                context.ApaxPack(lib);
                context.ApaxCopyArtifacts(lib);                   
            });

        }
        else
        {
            context.Libraries.Where(p => p.pack).ToList().ForEach(lib =>
            {
                context.Log.Information($"---------------------------------");
                context.Log.Information($"Packing {lib.folder}");
                context.Log.Information($"---------------------------------");
                context.ApaxClean(lib);
                context.ApaxInstall(context.GetLibraryAxFolders(lib));
                context.ApaxBuild(context.GetLibraryAxFolders(lib));
                context.ApaxPack(lib);
                context.ApaxCopyArtifacts(lib);                  
            });
        }
    }


    private static void PackNuGets(BuildContext context)
    {
        context.Log.Information($"Pack NUGET");

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
            // apax (npm) packages.
            if (context.BuildParameters.Target == PublishTarget.GitHub)
            {
                context.ApaxPublishGitHub();
            }
            else
            {
                context.ApaxPublishGitLab();
            }

            // NuGet packages: pick the feed + credential for the selected target.
            var (source, apiKey) = context.BuildParameters.Target == PublishTarget.GitHub
                ? ("https://nuget.pkg.github.com/inxton/index.json", context.GitHubToken)
                : (context.GitLabNuGetSource, context.GitLabToken);

            foreach (var nugetFile in Directory.EnumerateFiles(Path.Combine(context.Artifacts, @"nugets"), "*.nupkg")
                         .Select(p => new FileInfo(p)))
            {
                context.DotNetNuGetPush(nugetFile.FullName,
                    new Cake.Common.Tools.DotNet.NuGet.Push.DotNetNuGetPushSettings()
                    {
                        ApiKey = apiKey,
                        Source = source,
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
            if (context.BuildParameters.Target == PublishTarget.GitHub)
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
            else
            {
                CreateGitLabRelease(context);
            }
        }
    }

    // Creates a GitLab Release via the Releases API. GitLab auto-creates the tag from 'ref',
    // and has no draft concept. Prefers the job token (JOB-TOKEN); falls back to a PAT
    // (PRIVATE-TOKEN) when the API returns 401/403 (job-token API access disabled).
    private static void CreateGitLabRelease(BuildContext context)
    {
        var payload = JsonConvert.SerializeObject(new
        {
            name = GitVersionInformation.SemVer,
            tag_name = GitVersionInformation.SemVer,
            @ref = GitVersionInformation.Sha,
            description = $"Release v{GitVersionInformation.SemVer}"
        });

        using var http = new HttpClient();

        bool TryPost(string headerName, string headerValue)
        {
            if (string.IsNullOrEmpty(headerValue))
            {
                return false;
            }

            using var request = new HttpRequestMessage(HttpMethod.Post, context.GitLabReleasesApi)
            {
                Content = new StringContent(payload, Encoding.UTF8, "application/json")
            };
            request.Headers.Add(headerName, headerValue);

            var response = http.SendAsync(request).Result;
            if (response.StatusCode == HttpStatusCode.Unauthorized ||
                response.StatusCode == HttpStatusCode.Forbidden)
            {
                return false;
            }

            if (!response.IsSuccessStatusCode)
            {
                var body = response.Content.ReadAsStringAsync().Result;
                context.Log.Error($"GitLab release creation failed ({(int)response.StatusCode}): {body}");
                throw new PublishFailedException();
            }

            return true;
        }

        if (!TryPost("JOB-TOKEN", context.GitLabToken) && !TryPost("PRIVATE-TOKEN", context.GitLabApiToken))
        {
            context.Log.Error("GitLab release creation failed: neither CI_JOB_TOKEN nor GITLAB_API_TOKEN was accepted.");
            throw new PublishFailedException();
        }
    }
}

[TaskName("Default")]
[IsDependentOn(typeof(PublishReleaseTask))]
public class DefaultTask : FrostingTask
{
}
