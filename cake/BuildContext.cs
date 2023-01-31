// Build
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/ix/blob/master/LICENSE
// Third party licenses: https://github.com/ix-ax/ix/blob/master/notices.md

using System.Collections;
using System.Collections.Generic;
using System.IO;
using Cake.Common.Tools.DotNet;
using Cake.Common.Tools.DotNet.Build;
using Cake.Common.Tools.DotNet.MSBuild;
using Cake.Common.Tools.DotNet.Run;
using Cake.Common.Tools.DotNet.Test;
using Cake.Core;
using Cake.Core.IO;
using Cake.Frosting;
using Polly;
using Path = System.IO.Path;

public class BuildContext : FrostingContext
{
    public string Artifacts  => Path.Combine(Environment.WorkingDirectory.FullPath, "..//artifacts//");

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
}

public static class Apax
{
    public static void ApaxInstall(this BuildContext context, (string folder, string name) lib)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = "install -L",
            WorkingDirectory = context.GetAxFolder(lib),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
    }

    public static void ApaxClean(this BuildContext context, (string folder, string name) lib)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = "clean",
            WorkingDirectory = context.GetAxFolder(lib),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
    }

    public static void ApaxBuild(this BuildContext context, (string folder, string name) lib)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = "build",
            WorkingDirectory = context.GetAxFolder(lib),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
    }

    public static void ApaxPack(this BuildContext context, (string folder, string name) lib)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = "pack",
            WorkingDirectory = context.GetAxFolder(lib),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
    }

    public static void ApaxTest(this BuildContext context, (string folder, string name) lib)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = "pack",
            WorkingDirectory = context.GetAxFolder(lib),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
    }

    public static void ApaxPublish(this BuildContext context, (string folder, string name) lib)
    {
        var libraryFolder = Path.Combine(Path.Combine(context.RootDir, lib.folder), "ctrl");
        var packageFile = $"ix-ax-{lib.name}-{GitVersionInformation.SemVer}.apax.tgz";
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = $"publish -p {packageFile} -r  https://npm.pkg.github.com",
            WorkingDirectory = libraryFolder,
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
    }
}