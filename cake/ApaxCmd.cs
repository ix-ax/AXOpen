// Build
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/ix/blob/master/LICENSE
// Third party licenses: https://github.com/ix-ax/ix/blob/master/notices.md

using System.Diagnostics;
using System.IO;
using System.Linq;
using Cake.Common.IO;
using Cake.Common.Tools.ILMerge;
using Cake.Core.Diagnostics;
using Cake.Core.IO;
using Microsoft.Win32;
using Octokit;
using static NuGet.Packaging.PackagingConstants;
using Path = System.IO.Path;

public static class ApaxCmd
{
    public static void ApaxInstall(this BuildContext context, (string folder, string name, bool pack) lib)
    {
        foreach (var folder in context.GetAxFolders(lib))
        {
            var apaxArguments = context.BuildParameters.DoApaxInstallReDownload ? "install -r" : "install";

            context.Log.Information($"apax install started for '{lib.folder} : {lib.name}'");
            context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
            {
                Arguments = apaxArguments,
                WorkingDirectory = folder,
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                Silent = false
            }).WaitForExit();
        }
    }

    public static void ApaxClean(this BuildContext context, (string folder, string name, bool pack) lib)
    {
        foreach (var folder in context.GetAxFolders(lib))
        {
            context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
            {
                Arguments = "clean",
                WorkingDirectory = folder,
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                Silent = false
            }).WaitForExit();
            context.Log.Information($"apax clean finished for '{lib.folder} : {lib.name}'");

            var lockFile = Path.Combine(folder, "apax-lock.json");
            if(File.Exists(lockFile)) context.DeleteFile(lockFile);
        }
    }


    public static void ApaxBuild(this BuildContext context, (string folder, string name, bool pack) lib)
    {
        foreach (var folder in context.GetAxFolders(lib))
        {
            context.Log.Information($"apax build started for '{lib.folder} : {lib.name}'");
            var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
            {
                Arguments = "build --ignore-scripts",
                WorkingDirectory = folder,
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                Silent = false
            });

            process.WaitForExit();
            var exitcode = process.GetExitCode();
            context.Log.Information($"apax build exited with '{exitcode}'");

            if (exitcode != 0)
            {
                throw new BuildFailedException();
            }
        }
    }

   

 

    public static void ApaxUpdate(this BuildContext context, (string folder, string name, bool pack) lib)
    {
        foreach (var folder in context.GetAxFolders(lib))
        {
            context.Log.Information($"apax update started for '{lib.folder} : {lib.name}' in {folder}");
            var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
            {
                Arguments = "update --all",
                WorkingDirectory = folder,
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                Silent = false
            });

            process.WaitForExit();
            var exitcode = process.GetExitCode();
            context.Log.Information($"apax update exited with '{exitcode}'");

            if (exitcode != 0)
            {
                throw new BuildFailedException();
            }
        }
    }

  

    public static void ApaxPack(this BuildContext context, (string folder, string name, bool pack) lib)
    {

        System.Console.WriteLine(context.ApaxSignKey);
        if (lib.pack)
        {
            context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
            {
                Arguments = $"pack --key={context.ApaxSignKey}",
                WorkingDirectory = context.GetLibFolder(lib),
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                Silent = false
            }).WaitForExit();
        }
    }

    public static void ApaxTest(this BuildContext context, (string folder, string name, bool pack) lib)
    {
        foreach (var folder in context.GetAxFolders(lib))
        {
            context.Log.Information($"apax test started for '{lib.folder} : {lib.name}' [{folder}]");
            var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
            {
                Arguments = "test",
                WorkingDirectory = folder,
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                Silent = false
            });

            process.WaitForExit();

            var exitcode = process.GetExitCode();
            context.Log.Information($"apax test exited with '{exitcode}'");

            if (exitcode != 0)
            {
                throw new TestFailedException();
            }
        }
    }

    public static void ApaxIxc(this BuildContext context, (string folder, string name, bool pack) lib)
    {
        foreach (var folder in context.GetAxFolders(lib))
        {
            context.ProcessRunner.Start(Helpers.GetDotNetCommand(), new ProcessSettings()
            {
                Arguments = "ixc",
                WorkingDirectory = folder,
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                Silent = false
            }).WaitForExit();
        }
    }

    public static void ApaxCopyArtifacts(this BuildContext context,  (string folder, string name, bool pack) lib)
    {
        if (lib.pack)
        {
            var libraryFolder = Path.Combine(Path.Combine(context.RootDir, lib.folder), "ctrl");
            var packageFile = $"{context.ApaxRegistry}-{lib.name}-{GitVersionInformation.SemVer}.apax.tgz";
            var sourceFile = Path.Combine(libraryFolder, packageFile);

            File.Copy(sourceFile, Path.Combine(context.ArtifactsApax, packageFile));
        }
    }

    public static void ApaxPublish(this BuildContext context)
    {
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = $"login --registry https://npm.pkg.github.com--username { context.GitHubUser } --password { context.GitHubToken }",
            WorkingDirectory = context.ArtifactsApax,
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
        
        foreach (var apaxPackageFile in Directory.EnumerateFiles(context.ArtifactsApax))
        {
            var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
            {
                Arguments = $"publish -p {apaxPackageFile} -r  https://npm.pkg.github.com",
                WorkingDirectory = context.ArtifactsApax,
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                Silent = false
            });

            process.WaitForExit();
            
            if (process.GetExitCode() != 0)
            {
                throw new PublishFailedException();
            }
        }
    }

    public static void ApaxDownload(this BuildContext context, 
                                        (string folder, string name, string targetIp, string targetPlatform) app)
    {
        var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = $" sld -t {app.targetIp} -i {app.targetPlatform} --accept-security-disclaimer --default-server-interface -r",
            WorkingDirectory = context.GetAppFolder(app),
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        });

        process.WaitForExit();
    }

    public static void ApaxDownload(this BuildContext context,
        string folder)
    {
        var targetIp = System.Environment.GetEnvironmentVariable("AXTARGET");
        var targetPlatform = System.Environment.GetEnvironmentVariable("AXTARGETPLATFORMINPUT");
        var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = $" sld -t {targetIp} -i {targetPlatform} --accept-security-disclaimer --default-server-interface -r",
            WorkingDirectory = folder,
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        });

        process.WaitForExit();
    }
}