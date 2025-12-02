// Copyright (c) 2023 MTS spol. s r.o,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/AXOpen/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/AXOpen/blob/master/LICENSE
// Third party licenses: https://github.com/inxton/AXOpen/blob/master/notices.md

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
using Cake.Core.IO;
using System;
using YamlDotNet.RepresentationModel;


public partial class BuildContext : FrostingContext
{

    public bool IsGitHubActions { get; set; }

    public string ApaxRegistry => "inxton";

    public void UpdateApaxVersion(string file, string version)
    {
        var sb = new StringBuilder();
        foreach (var line in System.IO.File.ReadLines(file))
        {
            var newLine = line;
            if (line.Trim().StartsWith("name"))
            {
                // Do not change the version of the catalog in the declaration field
                if (line.Contains(".catalog"))
                {
                    return;
                }
            }
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

    public void UpdateApaxDependencies(string file, string version)
    {
        var sb = new StringBuilder();
        foreach (var line in System.IO.File.ReadLines(file))
        {
            var newLine = line;

            // Do not change the version of the catalog when used
            if (line.Trim().StartsWith($"\"@{ApaxRegistry}/") && line.Contains(":") && !line.Contains(".catalog"))
            {
                var semicPosition = line.IndexOf(":");
                var lenght = line.Length - semicPosition;

                newLine = $"{line.Substring(0, semicPosition)} : '{version}'";
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

    public IEnumerable<string> TargetFrameworks { get; } = new List<string>() { "net9.0" };

    public string TestResults => Path.Combine(Environment.WorkingDirectory.FullPath, "..//TestResults//");
   
    public string TestResultsCtrl => Path.Combine(Environment.WorkingDirectory.FullPath, "..//TestResultsCtrl//");
    public string AppTestResultsDir => Path.GetFullPath(Path.Combine(Environment.WorkingDirectory.FullPath, "..//..//..//..//..//AppRunTest//app_test_results//"));
    public string SourceDirPlcSim => Path.GetFullPath(Path.Combine(Environment.WorkingDirectory.FullPath, "..//..//..//..//..//AppRunTest//source//plcsim//"));
    public string PlcSimVirtualMemoryCardLocation => Path.GetFullPath(Path.Combine(Environment.WorkingDirectory.FullPath, "..//..//..//..//..//AppRunTest//plcsim//"));
    public string PlcName => "plc_line";
    public string PlcIpAddress => "10.10.10.120";

    public string SourceDirSecurityFiles => Path.GetFullPath(Path.Combine(Environment.WorkingDirectory.FullPath, "..//..//..//..//..//AppRunTest//source//"));
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
            Framework = "net9.0",
            Configuration = buildParameters.Configuration,
            NoBuild = true,
            NoRestore = true,
        };

        IsGitHubActions = context.EnvironmentVariable("GITHUB_ACTIONS") == "true";
    }

    #region Libraries
    public IEnumerable<(string folder, string name, bool pack, bool app_run)> Libraries { get; } = new[]
    {
        ("ax.latest.packages", "ax.latest.packages", true, false),
        ("ax.axopen.min", "ax.axopen.min", true, false),
        ("ax.axopen.hwlibrary", "ax.axopen.hwlibrary", true, false),
        ("ax.axopen.app", "ax.axopen.app", true, false),
        ("sdk-ax", "ax-sdk", true, false),
        ("abstractions", "axopen.abstractions", true, true),
        ("timers", "axopen.timers", true, false),
        ("simatic1500", "axopen.simatic1500", true, false),
        ("utils", "axopen.utils", true, false),
        ("core", "axopen.core", true, true),
        ("data", "axopen.data", true, true),
        ("probers", "axopen.probers", true, true),
        ("inspectors", "axopen.inspectors", true, true),
        ("components.abstractions", "axopen.components.abstractions", true, true),
        ("components.elements", "axopen.components.elements", true, true),
        ("io", "axopen.io", true, true),
        ("components.cognex.vision", "axopen.components.cognex.vision", true, true),
        ("components.pneumatics", "axopen.components.pneumatics", true, true),
        ("components.drives", "axopen.components.drives", true, true),
        ("components.rexroth.drives", "axopen.components.rexroth.drives", true, true),
        ("components.rexroth.press", "axopen.components.rexroth.press", true, true),
        ("components.festo.drives", "axopen.components.festo.drives", true, true),
        ("components.desoutter.tightening", "axopen.components.desoutter.tightening", true, true),
        ("components.robotics", "axopen.components.robotics", true, true),
        ("components.abb.robotics", "axopen.components.abb.robotics", true, true),
        ("components.mitsubishi.robotics", "axopen.components.mitsubishi.robotics", true, true),
        ("components.ur.robotics", "axopen.components.ur.robotics", true, true),
        ("components.kuka.robotics", "axopen.components.kuka.robotics", true, true),
        ("components.siem.identification", "axopen.components.siem.identification", true, true),
        ("components.siem.communication", "axopen.components.siem.communication", true, true),
        ("components.balluff.identification", "axopen.components.balluff.identification", true, true),
        ("components.keyence.vision", "axopen.components.keyence.vision", true, true),
        ("components.rexroth.tightening", "axopen.components.rexroth.tightening", true, true),
        ("components.dukane.welders", "axopen.components.dukane.welders", true, true),
        ("components.zebra.vision", "axopen.components.zebra.vision", true, true),
        ("integrations", "ix.integrations", false,false),
        ("template.axolibrary", "template.axolibrary", false, true)
    };
    #endregion
    
    public string GitHubUser { get; } = System.Environment.GetEnvironmentVariable("GH_USER");
    
    public string GitHubToken { get; } = System.Environment.GetEnvironmentVariable("GH_TOKEN");

    public string ApaxSignKey { get; } = System.Environment.GetEnvironmentVariable("APAX_KEY");

    public IEnumerable<string> GetAxFolders((string folder, string name, bool pack, bool app_run) library)
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

    public IEnumerable<string> GetLibraryAxFolders((string folder, string name, bool pack, bool app_run) library)
    {
        var paths = new string[]
        {
            Path.Combine(Path.Combine(RootDir, library.folder), "ctrl")
        };

        return paths.Where(p => File.Exists(Path.Combine(p, "apax.yml")));
    }

    public IEnumerable<string> GetLibraryWithTestAxFolders((string folder, string name, bool pack, bool app_run) library)
    {
        var paths = new string[]
        {
            Path.Combine(Path.Combine(RootDir, library.folder), "ctrl")
        };

        return paths.Where(p => File.Exists(Path.Combine(p, "apax.yml")) && Directory.Exists(Path.Combine(p, "tests"))).ToList();
    }

    public string GetLibFolder((string folder, string name, bool pack, bool app_run) library)
    {
        return Path.Combine(Path.Combine(RootDir, library.folder), "ctrl");
    }

    public string GetAppFolder((string folder, string name) library)
    {
        return Path.Combine(Path.Combine(RootDir, library.folder), "app");
    }

    public string GetAppFolder((string folder, string name, bool pack, bool app_run) library)
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

    
    public IEnumerable<string> GetApaxFiles((string folder, string name, bool pack, bool app_run) library)
    {
        var paths = new string[]
        {
            Path.Combine(Path.Combine(RootDir, library.folder), "ctrl", "apax.yml"),
            Path.Combine(Path.Combine(RootDir, library.folder), "app", "apax.yml"),
            Path.Combine(Path.Combine(RootDir, library.folder), "ax", "apax.yml")
        };

        return paths.Where(Path.Exists);
    }

    public string GetApaxFile((string folder, string name, bool pack, bool app_run) library)
    {
        return Path.Combine(Path.Combine(RootDir, library.folder), "ctrl", "apax.yml");
    }

    public string GetApaxFile(string folder, string sub)
    {
        return Path.Combine(Path.Combine(RootDir, folder), sub, "apax.yml");
    }
    public string GetApaxFile(string folder)
    {
        return Path.Combine(Path.Combine(RootDir, folder), "apax.yml");
    }

    public string GetApplicationName(string yamlFilePath)
    {
        string appName = "";
        // Load the YAML stream
        var yaml = new YamlStream();
        using (var reader = new StreamReader(yamlFilePath))
        {
            yaml.Load(reader);
        }

        // Assuming there's only one document in the YAML stream
        var root = (YamlMappingNode)yaml.Documents[0].RootNode;

        if (root.Children.TryGetValue(new YamlScalarNode("type"), out var typeNode) && typeNode is YamlScalarNode scalarNode && (scalarNode.Value == "app"))
        {
            if (root.Children.TryGetValue(new YamlScalarNode("name"), out var nameNode))
            {
                appName = nameNode.ToString();
            }

        }

        return appName;
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