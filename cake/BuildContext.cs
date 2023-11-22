// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/ix/blob/master/LICENSE
// Third party licenses: https://github.com/ix-ax/ix/blob/master/notices.md

using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using Cake.Common.Build;
using Cake.Common;
using Cake.Common.Tools.DotNet;
using Cake.Common.Tools.DotNet.Build;
using Cake.Common.Tools.DotNet.MSBuild;
using Cake.Common.Tools.DotNet.Run;
using Cake.Common.Tools.DotNet.Test;
using Cake.Core;
using Cake.Frosting;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Octokit;
using Polly;
using static NuGet.Packaging.PackagingConstants;
using Path = System.IO.Path;

public class BuildContext : FrostingContext
{

    public bool IsGitHubActions { get; set; }

    public string ApaxRegistry => "ix-ax";

    public void UpdateApaxVersion(string file, string version)
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

    public void UpdateApaxDependencies(string file, IEnumerable<string> dependencies, string version)
    {
        var sb = new StringBuilder();
        foreach (var line in System.IO.File.ReadLines(file))
        {
            var newLine = line;

            foreach (var dependency in dependencies.Select(p => $"\"@{ApaxRegistry}/{p}\""))
            {
                if (line.Trim().StartsWith($"\"@{ApaxRegistry}/") && line.Contains(":"))
                {
                    var semicPosition = line.IndexOf(":");
                    var lenght = line.Length - semicPosition;

                    newLine = $"{line.Substring(0, semicPosition)} : '{version}'";
                }
            }

            sb.AppendLine(newLine);
        }

        System.IO.File.WriteAllText(file, sb.ToString());
    }

    public string Artifacts  => Path.Combine(Environment.WorkingDirectory.FullPath, "..//artifacts//");

    public string BuildsOutput => Path.Combine(RootDir, ".builds");

    public string ArtifactsApax => EnsureFolder(Path.Combine(Artifacts, "apax"));

    public string ArtifactsNugets => EnsureFolder(Path.Combine(Artifacts, "nugets"));

    public string PackableNugetsSlnf => Path.Combine(RootDir, "AXOpen-packable-only.proj");

    public string WorkDirName => Environment.WorkingDirectory.GetDirectoryName();

    public string ApiDocumentationDir => Path.GetFullPath(Path.Combine(Environment.WorkingDirectory.FullPath, "..//docs//api//"));

    public string RootDir => Path.GetFullPath(Path.Combine(Environment.WorkingDirectory.FullPath, "..//src//"));

    public Cake.Common.Tools.DotNet.Build.DotNetBuildSettings DotNetBuildSettings { get; }

    public Cake.Common.Tools.DotNet.Test.DotNetTestSettings DotNetTestSettings { get; }

    public DotNetRunSettings DotNetRunSettings { get; }

    public BuildParameters BuildParameters { get; }

    public IEnumerable<string> TargetFrameworks { get; } = new List<string>() { "net7.0" };

    public string TestResults => Path.Combine(Environment.WorkingDirectory.FullPath, "..//TestResults//");

    public string TestResultsCtrl => Path.Combine(Environment.WorkingDirectory.FullPath, "..//TestResultsCtrl//");

    public BuildContext(ICakeContext context, BuildParameters buildParameters)
        : base(context)
    {

        BuildParameters = buildParameters;

        DotNetBuildSettings = new DotNetBuildSettings()
        {
            Verbosity = buildParameters.Verbosity,
            Configuration = buildParameters.Configuration,
            NoRestore = false,
            MSBuildSettings = new DotNetMSBuildSettings()
            {
                Verbosity = buildParameters.Verbosity
            }
        };

        DotNetTestSettings = new DotNetTestSettings()
        {
            ResultsDirectory = Path.Combine(TestResults),
            Verbosity = buildParameters.Verbosity,
            Configuration = buildParameters.Configuration,
            NoRestore = true,
            NoBuild = true
        };

        DotNetRunSettings = new DotNetRunSettings()
        {
            Verbosity = buildParameters.Verbosity,
            Framework = "net8.0",
            Configuration = buildParameters.Configuration,
            NoBuild = true,
            NoRestore = true,
        };

        IsGitHubActions = context.EnvironmentVariable("GITHUB_ACTIONS") == "true";
    }

    #region Libraries
    public IEnumerable<(string folder, string name, bool pack)> Libraries { get; } = new[]
    {
        ("abstractions", "axopen.abstractions", true),
        ("timers", "axopen.timers", true),
        ("simatic1500", "axopen.simatic1500", true),
        ("utils", "axopen.utils", true),
        ("core", "axopen.core", true),       
        ("data", "axopen.data", true),
        ("probers", "axopen.probers", true),
        ("inspectors", "axopen.inspectors", true),
        ("components.elements", "axopen.components.elements", true),
        ("components.abstractions", "axopen.components.abstractions", true),
        ("components.cognex.vision", "axopen.components.cognex.vision", true),
        ("components.pneumatics", "axopen.components.pneumatics", true),
        ("components.drives", "axopen.components.drives", true),
        ("components.rexroth.drives", "axopen.components.rexroth.drives", true),
        ("components.festo.drives", "axopen.components.festo.drives", true),
        ("integrations", "ix.integrations", false),
        ("templates.simple", "templates.simple", false),
        ("template.axolibrary", "template.axolibrary", false)
    };
    #endregion
    
    public string GitHubUser { get; } = System.Environment.GetEnvironmentVariable("GH_USER");
    
    public string GitHubToken { get; } = System.Environment.GetEnvironmentVariable("GH_TOKEN");

    public string ApaxSignKey { get; } = System.Environment.GetEnvironmentVariable("APAX_KEY");

    public IEnumerable<string> GetAxFolders((string folder, string name, bool pack) library)
    {
        var paths = new string[]
        {
            Path.Combine(Path.Combine(RootDir, library.folder), "ctrl"),
            Path.Combine(Path.Combine(RootDir, library.folder), "app"),
            Path.Combine(Path.Combine(RootDir, library.folder), "ax")            
        };

        return paths.Where(p => File.Exists(Path.Combine(p, "apax.yml")));
    }

    public IEnumerable<string> GetApplicationAxFolders((string folder, string name, bool pack) library)
    {
        var paths = new string[]
        {            
            Path.Combine(Path.Combine(RootDir, library.folder), "app"),
            Path.Combine(Path.Combine(RootDir, library.folder), "ax")            
        };

        return paths.Where(p => File.Exists(Path.Combine(p, "apax.yml")));
    }

    public string GetLibFolder((string folder, string name, bool pack) library)
    {
        return Path.Combine(Path.Combine(RootDir, library.folder), "ctrl");
    }

    public string GetAppFolder((string folder, string name) library)
    {
        return Path.Combine(Path.Combine(RootDir, library.folder), "app");
    }

    public string GetAxTestResultsFolder(string axFolder)
    {
        return Path.Combine(axFolder, "testresult");
    }

    public string GetAppFolder((string folder, string name, string targetIp, string targetPlatform) app)
    {
        return GetAppFolder((app.folder, app.name));
    }

    
    public IEnumerable<string> GetApaxFiles((string folder, string name, bool pack) library)
    {
        var paths = new string[]
        {
            Path.Combine(Path.Combine(RootDir, library.folder), "ctrl", "apax.yml"),
            Path.Combine(Path.Combine(RootDir, library.folder), "app", "apax.yml"),
            Path.Combine(Path.Combine(RootDir, library.folder), "ax", "apax.yml")
        };

        return paths.Where(Path.Exists);
    }

    public string GetApaxFile((string folder, string name, bool pack) library)
    {
        return Path.Combine(Path.Combine(RootDir, library.folder), "ctrl", "apax.yml");
    }

    public string GetApaxFile(string folder, string sub)
    {
        return Path.Combine(Path.Combine(RootDir, folder), sub, "apax.yml");
    }


    public string EnsureFolder(string path)
    {
        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
        }

        return path;
    }
}