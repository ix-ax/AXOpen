// Build
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/ix/blob/master/LICENSE
// Third party licenses: https://github.com/ix-ax/ix/blob/master/notices.md

using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Cake.Common.Tools.DotNet;
using Cake.Common.Tools.DotNet.Build;
using Cake.Common.Tools.DotNet.MSBuild;
using Cake.Common.Tools.DotNet.Run;
using Cake.Common.Tools.DotNet.Test;
using Cake.Core;
using Cake.Frosting;
using Polly;
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
                if (line.Trim().StartsWith(dependency))
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

    public string PackableNugetsSlnf => Path.Combine(RootDir, "ix.framework-packable-only.slnf");

    public string WorkDirName => Environment.WorkingDirectory.GetDirectoryName();

    public string ApiDocumentationDir => Path.GetFullPath(Path.Combine(Environment.WorkingDirectory.FullPath, "..//docs//api//"));

    public string RootDir => Path.GetFullPath(Path.Combine(Environment.WorkingDirectory.FullPath, "..//src//"));

    public Cake.Common.Tools.DotNet.Build.DotNetBuildSettings DotNetBuildSettings { get; }

    public Cake.Common.Tools.DotNet.Test.DotNetTestSettings DotNetTestSettings { get; }

    public DotNetRunSettings DotNetRunSettings { get; }

    public BuildParameters BuildParameters { get; }

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
        ("core", "ix.framework.core"),        
    };

    public IEnumerable<(string folder, string name)> Integrations { get; } = new[]
    {
        ("integrations", "ix.integrations"),        
    };

    public string GetAxFolder((string folder, string name) library)
    {
        return Path.Combine(Path.Combine(RootDir, library.folder), "ctrl");
    }

    public string GetApaxFile((string folder, string name) library)
    {
        return Path.Combine(Path.Combine(RootDir, library.folder), "ctrl", "apax.yml");
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