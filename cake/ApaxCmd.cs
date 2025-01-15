// Build
// Copyright (c) 2023 Peter Kurhajec (PTKu), MTS,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/ix-ax/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/ix-ax/ix/blob/master/LICENSE
// Third party licenses: https://github.com/ix-ax/ix/blob/master/notices.md

using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using Cake.Common.IO;
using Cake.Common.Tools.ILMerge;
using Cake.Core.Diagnostics;
using Cake.Core.IO;
using Microsoft.Win32;
using Octokit;
using YamlDotNet.RepresentationModel;
using static NuGet.Packaging.PackagingConstants;
using Path = System.IO.Path;

public static class ApaxCmd
{
    public static void ApaxInstall(this BuildContext context, IEnumerable<string> folders)
    {
        foreach (var folder in folders)
        {
            var apaxArguments = context.BuildParameters.DoApaxInstallReDownload ? "install -r" : "install";

            context.Log.Information($"apax install started in '{folder}'");
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

    public static void ApaxInstall(this BuildContext context, string folder)
    {
        var apaxArguments = "install";

        context.Log.Information($"apax {apaxArguments} started in '{folder}'");
        context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
        {
            Arguments = apaxArguments,
            WorkingDirectory = folder,
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
        context.Log.Information($"apax {apaxArguments} completed successfully in '{folder}'");
    }

    public static string ApaxPlcSim(this BuildContext context, string folder, ref bool summaryResult)
    {
        string retVal = ",NOK";
        var apaxArguments = "plcsim";

        context.Log.Information($"apax {apaxArguments} started in '{folder}'");

        var processSettings = new ProcessSettings()
        {
            Arguments = apaxArguments,
            WorkingDirectory = folder,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            Silent = false
        };

        using (var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), processSettings))
        {
            if (process == null)
            {
                summaryResult = false;
                throw new Exception("Failed to start the process.");
            }
            int timeoutInSeconds = 60;

            context.Log.Information($"Waiting for {timeoutInSeconds} seconds...");
            Task.Delay(1000 * timeoutInSeconds).Wait();
            
            var standardOutput = process.GetStandardOutput();
            var standardError = process.GetStandardError();

    
            foreach (var std_line in standardOutput)
            {
                context.Log.Information($"std_line: {std_line}");
                if (std_line.StartsWith("PLCsim instance:") && std_line.EndsWith("is accessible!"))
                {
                    retVal = ",OK";
                    break;
                }
            }
            if (retVal.Equals(",NOK"))
            {
                summaryResult = false;
            }
            return retVal;
        }
    }

    public static string ApaxHwu(this BuildContext context, string folder, ref bool summaryResult)
    {
        string retVal = ",NOK";
        var apaxArguments = "hwu";

        context.Log.Information($"apax {apaxArguments} started in '{folder}'");

        var processSettings = new ProcessSettings()
        {
            Arguments = apaxArguments,
            WorkingDirectory = folder,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            Silent = false
        };

        using (var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), processSettings))
        {
            if (process == null)
            {
                summaryResult = false;
                throw new Exception("Failed to start the process.");
            }

            process.WaitForExit();

            var standardOutput = process.GetStandardOutput();
            var standardError = process.GetStandardError();


            // Check the exit code and handle result
            if (process.GetExitCode() == 0)
            {
                foreach (string line in standardOutput)
                {
                    context.Log.Information(line);
                }
                context.Log.Information($"apax {apaxArguments} completed successfully in '{folder}'");
                retVal = ",OK";
            }
            else
            {
                summaryResult = false;
                foreach (string line in standardError)
                {
                    context.Log.Error(line);
                }
                context.Log.Error($"apax {apaxArguments} failed with exit code: {process.GetExitCode()} in '{folder}'");
                context.Log.Error($"Error Output: {standardError}");
            }
            return retVal;
        }
    }
    public static string ApaxSwfd(this BuildContext context, string folder, ref bool summaryResult)
    {
        string retVal = ",NOK";
        var apaxArguments = "swfd";

        context.Log.Information($"apax {apaxArguments} started in '{folder}'");

        var processSettings = new ProcessSettings()
        {
            Arguments = apaxArguments,
            WorkingDirectory = folder,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            Silent = false
        };

        using (var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), processSettings))
        {
            if (process == null)
            {
                summaryResult = false;
                throw new Exception("Failed to start the process.");
            }

            process.WaitForExit();

            var standardOutput = process.GetStandardOutput();
            var standardError = process.GetStandardError();


            // Check the exit code and handle result
            if (process.GetExitCode() == 0)
            {
                foreach (string line in standardOutput)
                {
                    context.Log.Information(line);
                }
                context.Log.Information($"apax {apaxArguments} completed successfully in '{folder}'");
                retVal = ",OK";
            }
            else
            {
                summaryResult = false;
                foreach (string line in standardError)
                {
                    context.Log.Error(line);
                }
                context.Log.Error($"apax {apaxArguments} failed with exit code: {process.GetExitCode()} in '{folder}'");
                context.Log.Error($"Error Output: {standardError}");
            }
            return retVal;
        }
    }

    public static void ApaxClean(this BuildContext context, (string folder, string name, bool pack, bool app_run) lib)
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

    public static void ApaxBuild(this BuildContext context, IEnumerable<string> folders)
    {
        foreach (var folder in folders)
        {
            context.Log.Information($"apax build started for in '{folder}'");
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

    public static void ApaxUpdate(this BuildContext context, (string folder, string name, bool pack, bool app_run) lib)
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

    public static void ApaxPack(this BuildContext context, (string folder, string name, bool pack, bool app_run) lib)
    {        
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


    public static void ApaxTest(this BuildContext context, (string folder, string name, bool pack, bool app_run) lib)
    {
        foreach (var folder in context.GetAxFolders(lib))
        {
            if(!Directory.Exists(Path.Combine(folder, "test")))
            {
                context.Log.Warning($"skipping apax test for '{lib.folder} : {lib.name}' [{folder}] no 'test' folder present in the directory.");
                continue;
            }

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

    public static void ApaxTestLibrary(this BuildContext context, (string folder, string name, bool pack, bool app_run) lib)
    {
        foreach (var folder in context.GetLibraryAxFolders(lib))
        {
            if (!Directory.Exists(Path.Combine(folder, "test")))
            {
                context.Log.Warning($"skipping apax test for '{lib.folder} : {lib.name}' [{folder}] no 'test' folder present in the directory.");
                continue;
            }

            context.Log.Information($"apax test started for '{lib.folder} : {lib.name}' [{folder}]");
            var process = context.ProcessRunner.Start(Helpers.GetApaxCommand(), new ProcessSettings()
            {
                Arguments = "test",
                WorkingDirectory = folder,
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                Silent = false
            });

            process.WaitForExit();
            var passed = false;
            foreach (var o in process.GetStandardOutput())
            {
                if (o.Trim().Replace(" ", "").ToUpper() == "FAILED:0")
                {
                    passed = true;
                }
                context.Log.Information(o);
            }

            var exitcode = process.GetExitCode();
            context.Log.Information($"apax test exited with '{exitcode}'");

            
            if (exitcode != 0 || !passed)
            {
                throw new TestFailedException();
            }
        }
    }

    public static void ApaxCopyArtifacts(this BuildContext context,  (string folder, string name, bool pack, bool app_run) lib)
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
            Arguments = $"login --registry https://npm.pkg.github.com --username { context.GitHubUser } --password { context.GitHubToken }",
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
            Arguments = $" sld load -t {app.targetIp} -i {app.targetPlatform} --accept-security-disclaimer -r",
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
            Arguments = $" sld load -t {targetIp} -i {targetPlatform} --accept-security-disclaimer -r",
            WorkingDirectory = folder,
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        });

        process.WaitForExit();
    }

    public static void ApaxChangeBuildProperties(this BuildContext context, string yamlFilePath, IEnumerable<string> targets, IEnumerable<string> files)
    {
        // Load the YAML stream
        var yaml = new YamlStream();
        using (var reader = new StreamReader(yamlFilePath))
        {
            yaml.Load(reader);
        }

        // Assuming there's only one document in the YAML stream
        var root = (YamlMappingNode)yaml.Documents[0].RootNode;

        if (root.Children.TryGetValue(new YamlScalarNode("type"), out var typeNode) &&
            ((YamlScalarNode)typeNode).Value == "lib")
        {

            // Modify 'targets'
            var targetsNode = (YamlSequenceNode)root.Children[new YamlScalarNode("targets")];
            targetsNode.Children.Clear(); // Clear existing targets

            var quotedTargets = new List<string>();

            foreach (var target in targets)
            {
                if (target.StartsWith("\"") && target.EndsWith("\""))
                {
                    quotedTargets.Add(target);
                }

                targetsNode.Children.Add(new YamlScalarNode(target));
            }

            // Modify 'files'
            var filesNode = (YamlSequenceNode)root.Children[new YamlScalarNode("files")];
            filesNode.Children.Clear(); // Clear existing files

            foreach (var file in files)
            {
                filesNode.Children.Add(new YamlScalarNode(file));
            }

            // Save the modified document
            using (var writer = new StreamWriter(yamlFilePath))
            {
                yaml.Save(writer, assignAnchors: false);
            }

            // Assume 'yamlString' is your serialized YAML string
            string yamlString = File.ReadAllText(yamlFilePath);


            foreach (var target in quotedTargets)
            {
                yamlString = yamlString.Replace($"'{target}'", target);
            }



            // Save the manually adjusted YAML string to a file
            File.WriteAllText(yamlFilePath, yamlString);


            Console.WriteLine($"Apax '{yamlFilePath}' was modified for targets '{string.Join(",", targets)}' and files '{string.Join(",", files)}'");
        }
    }

    public static void ApaxCatalogInstall(this BuildContext context, string yamlFilePath)
    {
        // Load the YAML stream
        var yaml = new YamlStream();
        using (var reader = new StreamReader(yamlFilePath))
        {
            yaml.Load(reader);
        }

        // Assuming there's only one document in the YAML stream
        var root = (YamlMappingNode)yaml.Documents[0].RootNode;

        if(root.Children.TryGetValue(new YamlScalarNode("type"), out var typeNode) && typeNode is YamlScalarNode scalarNode && (scalarNode.Value == "generic" || scalarNode.Value == "lib"))
        {
            if (root.Children.TryGetValue(new YamlScalarNode("catalogs"), out var catalogNode))
            {
                var apaxArguments = "install --catalog";
                var folder = Path.GetDirectoryName(yamlFilePath);
                context.Log.Information($"apax install --catalog started in '{folder}'");
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
    }

    //public static void RunPowershellScript(this BuildContext context, string scriptPath, string arguments)
    //{
    //    string workDir = Path.GetFullPath(Path.Combine(scriptPath, ".."));
    //    context.Log.Information($"Powershell script {scriptPath} with arguments '{arguments}' started");
    //    context.ProcessRunner.Start("powershell.exe", new ProcessSettings()
    //    {
    //        Arguments = $"-NoProfile -ExecutionPolicy Bypass -File \"{scriptPath}\" {arguments}",
    //        WorkingDirectory = workDir,
    //        RedirectStandardOutput = false,
    //        RedirectStandardError = false,
    //        Silent = false
    //    }).WaitForExit();
    //    context.Log.Information($"Powershell script {scriptPath} with arguments '{arguments}' finished");
    //}

    //public static void DotnetClean(this BuildContext context, string slnFilePath, string arguments)
    //{
    //    string workDir = Path.GetFullPath(Path.Combine(slnFilePath, ".."));
    //    context.Log.Information($"Dotne clean command started with solution: {slnFilePath}");
    //    context.ProcessRunner.Start(Helpers.GetDotNetCommand(), new ProcessSettings()
    //    {
    //        Arguments = arguments,
    //        WorkingDirectory = workDir,
    //        RedirectStandardOutput = false,
    //        RedirectStandardError = false,
    //        Silent = false
    //    }).WaitForExit();
    //    context.Log.Information($"Dotne clean command finished with solution: {slnFilePath}");
    //}
}