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

    public string ArtifactsApax => EnsureFolder(Path.Combine(Artifacts, "apax"));

    public string ArtifactsNugets => EnsureFolder(Path.Combine(Artifacts, "nugets"));

    public string PackableNugetsSlnf => Path.Combine(RootDir, "AXOpen-packable-only.slnf");

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
                Verbosity = DotNetVerbosity.Quiet
            }
        };

        DotNetTestSettings = new DotNetTestSettings()
        {
            Verbosity = buildParameters.Verbosity,
            Configuration = buildParameters.Configuration,
            NoRestore = true,
            NoBuild = true

        };

        DotNetRunSettings = new DotNetRunSettings()
        {
            Verbosity = buildParameters.Verbosity,
            Framework = "net6.0",
            Configuration = buildParameters.Configuration,
            NoBuild = true,
            NoRestore = true,
        };
    }

    public IEnumerable<(string folder, string name)> Libraries { get; } = new[]
    {
        ("abstractions", "axopen.abstractions"),
        ("simatic1500", "axopen.simatic1500"),
        ("utils", "axopen.utils"),
        ("core", "axopen.core"),       
        ("data", "axopen.data"),
        ("probers", "axopen.probers"),
        ("inspectors", "axopen.inspectors"),
        ("components.abstractions", "axopen.components.abstractions"),
        ("components.cognex.vision", "axopen.cognex.vision"),
    };

    public IEnumerable<(string folder, string name, string targetIp, string targetPlatform)> Integrations { get; } = new[]
    {
        ("integrations", "ix.integrations", System.Environment.GetEnvironmentVariable("AXTARGET"), System.Environment.GetEnvironmentVariable("AXTARGETPLATFORMINPUT")),
        ("templates.simple", "templates.simple", System.Environment.GetEnvironmentVariable("AXTARGET"), System.Environment.GetEnvironmentVariable("AXTARGETPLATFORMINPUT")),
        ("template.axolibrary", "template.axolibrary", System.Environment.GetEnvironmentVariable("AXTARGET"), System.Environment.GetEnvironmentVariable("AXTARGETPLATFORMINPUT")),
    };

    public string GitHubUser { get; } = System.Environment.GetEnvironmentVariable("GH_USER");
    
    public string GitHubToken { get; } = System.Environment.GetEnvironmentVariable("GH_TOKEN");

    public IEnumerable<string> GetAxFolders((string folder, string name) library)
    {
        return new string[]
        {
            Path.Combine(Path.Combine(RootDir, library.folder), "ctrl"),
            Path.Combine(Path.Combine(RootDir, library.folder), "app")
        };
    }

    public string GetLibFolder((string folder, string name) library)
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

    public IEnumerable<string> GetAxFolders((string folder, string name, string targetIp, string targetPlatform) app)
    {
        return GetAxFolders((app.folder, app.name));
    }

    public string GetAppFolder((string folder, string name, string targetIp, string targetPlatform) app)
    {
        return GetAppFolder((app.folder, app.name));
    }

    public string GetApaxFile((string folder, string name) library)
    {
        return Path.Combine(Path.Combine(RootDir, library.folder), "ctrl", "apax.yml");
    }

    public string GetApaxFile(string folder, string sub)
    {
        return Path.Combine(Path.Combine(RootDir, folder), sub, "apax.yml");
    }

    public string GetApaxFile((string folder, string name, string targetIp, string targetPlatform) app)
    {
        return GetApaxFile((app.folder, app.name));
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