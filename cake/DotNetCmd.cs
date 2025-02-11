// Build
// Copyright (c) 2023 MTS spol. s r.o,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/AXOpen/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/AXOpen/blob/master/LICENSE
// Third party licenses: https://github.com/inxton/AXOpen/blob/master/notices.md

using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;
using Cake.Common.IO;
using Cake.Common.Tools.ILMerge;
using Cake.Core.Diagnostics;
using Cake.Core.IO;
using Microsoft.Extensions.Configuration;
using Microsoft.Win32;
using Octokit;
using Polly;
using YamlDotNet.RepresentationModel;
using static NuGet.Packaging.PackagingConstants;
using Path = System.IO.Path;

public static class DotNetCmd
{

    public static void DotnetIxc(this BuildContext context, IEnumerable<string> folders)
    {
        foreach (var folder in folders)
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


    //this BuildContext context, string folder, string apaxCommand, ref bool summaryResult
    public static string DotNetIxc(this BuildContext context, string folder, ref bool summaryResult)
    {
        string retVal = ",NOK";

        var processSettings = new ProcessSettings
        {
            Arguments = "ixc",
            WorkingDirectory = folder,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            Silent = false
        };

        try
        {
            using (var process = context.ProcessRunner.Start(Helpers.GetDotNetCommand(), processSettings))
            {
                if (process == null)
                {
                    summaryResult = false;
                    throw new Exception($"Failed to start the 'dotnet ixc' command in folder: '{folder}'");
                }
                context.Log.Information($"Dotnet ixc command started in folder: '{folder}'");

                // Initialize output storage
                var standardOutput = new List<string>();
                var standardError = new List<string>();

                // Read output and error streams asynchronously
                Task outputTask = Task.Run(() =>
                {
                    foreach (var line in process.GetStandardOutput())
                    {
                        standardOutput.Add(line);
                        context.Log.Information(line); // Log output immediately
                    }
                });

                Task errorTask = Task.Run(() =>
                {
                    foreach (var line in process.GetStandardError())
                    {
                        standardError.Add(line);
                        context.Log.Error(line); // Log errors immediately
                    }
                });

                // Wait for the process to exit
                process.WaitForExit();

                // Ensure all output and error streams are read
                Task.WaitAll(outputTask, errorTask);

                // Check the exit code and handle result
                if (process.GetExitCode() == 0)
                {
                    context.Log.Information($"Dotnet ixc command finished successfully in '{folder}'");
                    retVal = ",OK";
                }
                else
                {
                    summaryResult = false;
                    context.Log.Error($"Dotnet ixc command in folder: '{folder}' failed with exit code: {process.GetExitCode()}");
                    context.Log.Error($"Standard Error Output: {string.Join(Environment.NewLine, standardError)}");
                    context.Log.Error($"Standard Output: {string.Join(Environment.NewLine, standardOutput)}");
                }
            }
        }
        catch (Exception ex)
        {
            context.Log.Error($"An exception occurred while running the dotnet build command: {ex.Message}");
            summaryResult = false;
        }
        return retVal;
    }
    public static void RunPowershellScript(this BuildContext context, string scriptPath, string arguments)
    {
        string workDir = Path.GetFullPath(Path.Combine(scriptPath, ".."));
        context.Log.Information($"Powershell script {scriptPath} with arguments '{arguments}' started");
        context.ProcessRunner.Start("powershell.exe", new ProcessSettings()
        {
            Arguments = $"-NoProfile -ExecutionPolicy Bypass -File \"{scriptPath}\" {arguments}",
            WorkingDirectory = workDir,
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
        context.Log.Information($"Powershell script {scriptPath} with arguments '{arguments}' finished");
    }

    public static string RunPowershellScript(this BuildContext context, string scriptPath, string arguments, ref bool summaryResult)
    {
        string retVal = ",NOK";

        string workDir = Path.GetFullPath(Path.Combine(scriptPath, ".."));

        var processSettings = new ProcessSettings
        {
            Arguments = $"-NoProfile -ExecutionPolicy Bypass -File \"{scriptPath}\" {arguments}",
            WorkingDirectory = workDir,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            Silent = false
        };

        try
        {
            using (var process = context.ProcessRunner.Start("powershell.exe", processSettings))
            {
                if (process == null)
                {
                    summaryResult = false;
                    throw new Exception($"Failed to start Powershell script {scriptPath} with arguments '{arguments}'");
                }
                context.Log.Information($"Powershell script {scriptPath} with arguments '{arguments}' started");

                // Initialize output storage
                var standardOutput = new List<string>();
                var standardError = new List<string>();

                // Read output and error streams asynchronously
                Task outputTask = Task.Run(() =>
                {
                    foreach (var line in process.GetStandardOutput())
                    {
                        standardOutput.Add(line);
                        context.Log.Information(line); // Log output immediately
                    }
                });

                Task errorTask = Task.Run(() =>
                {
                    foreach (var line in process.GetStandardError())
                    {
                        standardError.Add(line);
                        context.Log.Error(line); // Log errors immediately
                    }
                });

                // Wait for the process to exit
                process.WaitForExit();

                // Ensure all output and error streams are read
                Task.WaitAll(outputTask, errorTask);

                // Check the exit code and handle result
                if (process.GetExitCode() == 0)
                {
                    context.Log.Information($"Powershell script {scriptPath} with arguments '{arguments}' finished successfully.");
                    retVal = ",OK";
                }
                else
                {
                    summaryResult = false;
                    context.Log.Error($"Powershell script {scriptPath} with arguments '{arguments}' failed with exit code: {process.GetExitCode()}");
                    context.Log.Error($"Standard Error Output: {string.Join(Environment.NewLine, standardError)}");
                    context.Log.Error($"Standard Output: {string.Join(Environment.NewLine, standardOutput)}");
                }
            }
        }
        catch (Exception ex)
        {
            context.Log.Error($"An exception occurred while running the Powershell script {scriptPath} with arguments '{arguments}' : {ex.Message}");
            summaryResult = false;
        }
        return retVal;
    }

    public static void DotNetClean(this BuildContext context, string slnFilePath, string arguments)
    {
        string workDir = Path.GetFullPath(Path.Combine(slnFilePath, ".."));
        string args = string.Concat($"clean \"{slnFilePath}\" ", arguments);
        context.Log.Information($"Dotnet clean command started with solution: {slnFilePath}");
        context.ProcessRunner.Start(Helpers.GetDotNetCommand(), new ProcessSettings()
        {
            Arguments = args,
            WorkingDirectory = workDir,
            RedirectStandardOutput = false,
            RedirectStandardError = false,
            Silent = false
        }).WaitForExit();
        context.Log.Information($"Dotnet clean command finished with solution: {slnFilePath}");
    }

    public static string DotNetClean(this BuildContext context, string slnFilePath, string arguments, ref bool summaryResult)
    {
        string workDir = Path.GetFullPath(Path.Combine(slnFilePath, ".."));
        string args = string.Concat($"clean \"{slnFilePath}\" ", arguments);
        context.Log.Information($"Dotnet clean command started with solution: {slnFilePath}");

        string retVal = ",NOK";

        var processSettings = new ProcessSettings
        {
            Arguments = args,
            WorkingDirectory = workDir,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            Silent = false
        };

        try
        {
            using (var process = context.ProcessRunner.Start(Helpers.GetDotNetCommand(), processSettings))
            {
                if (process == null)
                {
                    summaryResult = false;
                    throw new Exception("Failed to start the process.");
                }

                // Initialize output storage
                var standardOutput = new List<string>();
                var standardError = new List<string>();

                // Read output and error streams asynchronously
                Task outputTask = Task.Run(() =>
                {
                    foreach (var line in process.GetStandardOutput())
                    {
                        standardOutput.Add(line);
                        context.Log.Information(line); // Log output immediately
                    }
                });

                Task errorTask = Task.Run(() =>
                {
                    foreach (var line in process.GetStandardError())
                    {
                        standardError.Add(line);
                        context.Log.Error(line); // Log errors immediately
                    }
                });

                // Wait for the process to exit
                process.WaitForExit();

                // Ensure all output and error streams are read
                Task.WaitAll(outputTask, errorTask);

                // Check the exit code and handle result
                if (process.GetExitCode() == 0)
                {
                    context.Log.Information($"Dotnet clean command finished successfully with solution: {slnFilePath}");
                    retVal = ",OK";
                }
                else
                {
                    summaryResult = false;
                    context.Log.Error($"Dotnet clean command with solution: {slnFilePath} failed with exit code: {process.GetExitCode()}");
                    context.Log.Error($"Standard Error Output: {string.Join(Environment.NewLine, standardError)}");
                    context.Log.Error($"Standard Output: {string.Join(Environment.NewLine, standardOutput)}");
                }
            }
        }
        catch (Exception ex)
        {
            context.Log.Error($"An exception occurred while running the dotnet clean command: {ex.Message}");
            summaryResult = false;
        }
        return retVal;
    }

    public static string DotNetBuildWithResult(this BuildContext context, string slnFilePath, string arguments, ref bool summaryResult)
    {
        string workDir = Path.GetFullPath(Path.Combine(slnFilePath, ".."));
        string args = $"build \"{slnFilePath}\" {arguments}";
        context.Log.Information($"Dotnet build command started with solution: {slnFilePath}");

        string retVal = ",NOK";

        var processSettings = new ProcessSettings
        {
            Arguments = args,
            WorkingDirectory = workDir,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            Silent = false
        };

        try
        {
            using (var process = context.ProcessRunner.Start(Helpers.GetDotNetCommand(), processSettings))
            {
                if (process == null)
                {
                    summaryResult = false;
                    throw new Exception("Failed to start the process.");
                }

                // Initialize output storage
                var standardOutput = new List<string>();
                var standardError = new List<string>();

                // Read output and error streams asynchronously
                Task outputTask = Task.Run(() =>
                {
                    foreach (var line in process.GetStandardOutput())
                    {
                        standardOutput.Add(line);
                        context.Log.Information(line); // Log output immediately
                    }
                });

                Task errorTask = Task.Run(() =>
                {
                    foreach (var line in process.GetStandardError())
                    {
                        standardError.Add(line);
                        context.Log.Error(line); // Log errors immediately
                    }
                });

                // Wait for the process to exit
                process.WaitForExit();

                // Ensure all output and error streams are read
                Task.WaitAll(outputTask, errorTask);

                // Check the exit code and handle result
                if (process.GetExitCode() == 0)
                {
                    context.Log.Information($"Dotnet build command finished successfully with solution: {slnFilePath}");
                    retVal = ",OK";
                }
                else
                {
                    summaryResult = false;
                    context.Log.Error($"Dotnet build command with solution: {slnFilePath} failed with exit code: {process.GetExitCode()}");
                    context.Log.Error($"Standard Error Output: {string.Join(Environment.NewLine, standardError)}");
                    context.Log.Error($"Standard Output: {string.Join(Environment.NewLine, standardOutput)}");
                }
            }
        }
        catch (Exception ex)
        {
            context.Log.Error($"An exception occurred while running the dotnet build command: {ex.Message}");
            summaryResult = false;
        }
        return retVal;
    }

    public static string DotNetRunWithResult(this BuildContext context, string projectPath, string arguments, int timeoutInSeconds, ref bool summaryResult)
    {
        string workDir = Path.GetFullPath(Path.Combine(projectPath, ".."));
        string args = $"run --project \"{projectPath}\" {arguments}";
        context.Log.Information($"Dotnet run command started with project: {projectPath}");

        string retVal = ",NOK";

        // Configure the process
        var processStartInfo = new ProcessStartInfo
        {
            FileName = "dotnet",
            Arguments = args,
            WorkingDirectory = workDir,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using (var process = Process.Start(processStartInfo))
        {
            if (process == null)
            {
                summaryResult = false;
                throw new Exception("Failed to start the process.");
            }

            // Asynchronously read the output and error streams
            Task outputTask = Task.Run(() =>
            {
                while (!process.StandardOutput.EndOfStream)
                {
                    var line = process.StandardOutput.ReadLine();
                    if (!string.IsNullOrEmpty(line))
                    {
                        context.Log.Information($"[Output] {line}");
                    }
                }
            });

            Task errorTask = Task.Run(() =>
            {
                while (!process.StandardError.EndOfStream)
                {
                    var line = process.StandardError.ReadLine();
                    if (!string.IsNullOrEmpty(line))
                    {
                        context.Log.Error($"[Error] {line}");
                    }
                }
            });

            // Wait for 1 minute
            context.Log.Information($"Waiting for {timeoutInSeconds} seconds...");
            Task.Delay(1000 * timeoutInSeconds).Wait();

            // Check if the process is still running
            if (!process.HasExited)
            {
                context.Log.Information($"The application '{projectPath}' is still running after {timeoutInSeconds} seconds.");
                retVal = ",OK";
            }
            else
            {
                context.Log.Error($"The application '{projectPath}' has exited.");
            }

            // Ensure output and error tasks are complete
            Task.WhenAll(outputTask, errorTask);

            // Kill the process if it is still running
            if (!process.HasExited)
            {
                context.Log.Information($"Terminating the application '{projectPath}'...");
                process.Kill(true);
            }

            // Log exit code
            context.Log.Information($"Process exited with code: {process.ExitCode}");
            return retVal;
        }
    }
}