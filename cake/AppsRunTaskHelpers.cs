using Cake.Common.Diagnostics;
using Cake.Common.IO;
using Cake.Core.Diagnostics;
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using File = System.IO.File;
using Path = System.IO.Path;
// Build
// Copyright (c) 2023 MTS spol. s r.o,  and Contributors. All Rights Reserved.
// Contributors: https://github.com/inxton/AXOpen/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/AXOpen/blob/master/LICENSE
// Third party licenses: https://github.com/inxton/AXOpen/blob/master/notices.md


internal static class AppsRunTaskHelpers
{

    public static void BuildAndLoadPlc(BuildContext context, string appYamlFile, string appName, string logFilePath, ref bool summaryResult)
    {
        string plcName = context.PlcName;
        string plcIpAddress = context.PlcIpAddress;

        // Validate application YAML file
        if (string.IsNullOrWhiteSpace(appYamlFile))
        {
            context.Log.Error("The provided YAML of the application is empty.");
            return;
        }

        if (!File.Exists(appYamlFile))
        {
            context.Log.Error($"The provided application file does not exist: {appYamlFile}");
            return;
        }

        if (string.IsNullOrWhiteSpace(appName))
        {
            context.Log.Error("The provided application name is empty.");
            return;
        }

        string appFolder = Path.GetDirectoryName(appYamlFile);
        if (string.IsNullOrWhiteSpace(appFolder) || !Directory.Exists(appFolder))
        {
            context.Log.Error($"The provided path for the application does not exist: {appFolder}");
            return;
        }

        // Run "apax install"
        ApaxCmd.ApaxInstall(context, appFolder);

        // Run "apax plcsim"
        string plcSimResult = ApaxCmd.ApaxPlcSim(context, appFolder, ref summaryResult);
        WriteResult(context, plcSimResult, logFilePath, appendToSameLine: true);

        // Run "apax hwu"
        string hwuResult = ApaxCmd.ApaxHwu(context, appFolder, ref summaryResult);
        WriteResult(context, hwuResult, logFilePath, appendToSameLine: true);

        // Run "apax swfd"
        string swfdResult = ApaxCmd.ApaxSwfd(context, appFolder, ref summaryResult);
        WriteResult(context, swfdResult, logFilePath, appendToSameLine: true);
    }
    public static void AppRunDetailed(BuildContext context, string appYamlFile, string appName, string logFilePath, ref bool summaryResult)
    {
        string plcName = context.PlcName;
        string plcIpAddress = context.PlcIpAddress;

        // Validate application YAML file
        if (string.IsNullOrWhiteSpace(appYamlFile))
        {
            context.Log.Error("The provided YAML of the application is empty.");
            return;
        }

        if (!File.Exists(appYamlFile))
        {
            context.Log.Error($"The provided application file does not exist: {appYamlFile}");
            return;
        }

        if (string.IsNullOrWhiteSpace(appName))
        {
            context.Log.Error("The provided application name is empty.");
            return;
        }

        string appFolder = Path.GetDirectoryName(appYamlFile);
        if (string.IsNullOrWhiteSpace(appFolder) || !Directory.Exists(appFolder))
        {
            context.Log.Error($"The provided path for the application does not exist: {appFolder}");
            return;
        }

        // Run "apax install"
        string result = ApaxCmd.ApaxCommand(context, appFolder, "install", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Run "apax plcsim"
        result = ApaxCmd.ApaxPlcSim(context, appFolder, ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Run "apax gsd" # copy and install all gsdml files from libraries
        result = ApaxCmd.ApaxCommand(context, appFolder, "gsd", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Run "apax hwl" # copy all templates from libraries
        result = ApaxCmd.ApaxCommand(context, appFolder, "hwl", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Run "apax hwcc" # compile hardware configuration
        result = ApaxCmd.ApaxCommand(context, appFolder, "hwcc", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Run "apax hwid" # copy the generated HwIds from global constants into the type definition, matching the format as the TIA2AX tool creates
        result = ApaxCmd.ApaxCommand(context, appFolder, "hwid", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Run "apax hwadr" # copy the generated IoAddresses
        result = ApaxCmd.ApaxCommand(context, appFolder, "hwadr", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Run "apax hwdo" # download HW only using certificate
        result = ApaxCmd.ApaxCommand(context, appFolder, "hwdo", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Run "apax build --ignore-scripts" 
        result = ApaxCmd.ApaxCommand(context, appFolder, "build --ignore-scripts", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Run "dotnet ixc" 
        result = DotNetCmd.DotNetIxc(context, appFolder, ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Run "apax swfdo" # software full download only
        result = ApaxCmd.ApaxCommand(context, appFolder, "swfdo", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);


        // Recreate solution file by running the slngen script
        string slnGenPath = Path.GetFullPath(Path.GetFullPath(Path.Combine(appFolder, "..", "./slngen.ps1")));
        result = DotNetCmd.RunPowershellScript(context, slnGenPath, "", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Clean solution
        string solutionFile = Path.GetFullPath(Path.Combine(appFolder, "../this.sln"));
        result = DotNetCmd.DotNetClean(context, solutionFile, "-c Debug", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Build solution
        result = DotNetCmd.DotNetBuildWithResult(context, solutionFile, "-c Debug", ref summaryResult);
        WriteResult(context, result, logFilePath, appendToSameLine: true);

        // Get blazor projects
        var blazorFiles = Directory.GetFiles(appFolder, "*.csproj", SearchOption.AllDirectories).Where(file => file.Contains("blazor")).ToList();

        if (blazorFiles.Any())
        {
            foreach (var blazorFile in blazorFiles)
            {
                context.Log.Information($"Application 'blazor' file: {blazorFile}");

                // Filter out libraries by checking for <PackageId> in the project file
                string csprojContent = File.ReadAllText(blazorFile);
                if (!csprojContent.Contains("<PackageId>"))
                {
                    result = DotNetCmd.DotNetRunWithResult(context, blazorFile, "-c Debug --framework net9.0", 60, ref summaryResult);
                    WriteResult(context, result, logFilePath, appendToSameLine: true);
                }
            }
        }
        else
        {
            context.Log.Information("No files containing 'blazor' in the filename and ending with '.csproj' were found.");
        }
    }

    public static void BuildAndStartHmi(BuildContext context, string appYamlFile, string appName, string logFilePath, ref bool summaryResult)
    {
        // Validate application YAML file
        if (string.IsNullOrWhiteSpace(appYamlFile))
        {
            context.Log.Error("The provided YAML of the application is empty.");
            return;
        }

        if (!context.FileExists(appYamlFile))
        {
            context.Log.Error($"The provided application file does not exist: {appYamlFile}");
            return;
        }

        if (string.IsNullOrWhiteSpace(appName))
        {
            context.Log.Error("The provided application name is empty.");
            return;
        }

        string appFolder = Path.GetFullPath(Path.GetDirectoryName(appYamlFile));
        if (string.IsNullOrWhiteSpace(appFolder) || !context.DirectoryExists(appFolder))
        {
            context.Log.Error($"The provided path for the application does not exist: {appFolder}");
            return;
        }

        // Recreate solution file by running the slngen script
        string slnGenPath = Path.GetFullPath(Path.GetFullPath(Path.Combine(appFolder, "..", "./slngen.ps1")));
        DotNetCmd.RunPowershellScript(context, slnGenPath, "");

        // Clean solution
        string solutionFile = Path.GetFullPath(Path.Combine(appFolder, "../this.sln"));
        DotNetCmd.DotNetClean(context, solutionFile, "-c Debug");

        // Build solution
        string buildResult = DotNetCmd.DotNetBuildWithResult(context, solutionFile, "-c Debug", ref summaryResult);
        WriteResult(context, buildResult, logFilePath, appendToSameLine: true);

        // Get blazor projects
        var blazorFiles = Directory.GetFiles(appFolder, "*.csproj", SearchOption.AllDirectories).Where(file => file.Contains("blazor")).ToList();

        if (blazorFiles.Any())
        {
            foreach (var blazorFile in blazorFiles)
            {
                context.Log.Information($"Application 'blazor' file: {blazorFile}");

                // Filter out libraries by checking for <PackageId> in the project file
                string csprojContent = File.ReadAllText(blazorFile);
                if (!csprojContent.Contains("<PackageId>"))
                {
                    string runResult = DotNetCmd.DotNetRunWithResult(context, blazorFile, "-c Debug --framework net9.0", 60, ref summaryResult);
                    WriteResult(context, runResult, logFilePath, appendToSameLine: true);
                }
            }
        }
        else
        {
            context.Log.Information("No files containing 'blazor' in the filename and ending with '.csproj' were found.");
        }
    }

    public static (bool Success, string FilePath) CreateLogFile(BuildContext context, string fileNamePrefix = "app_test_result")
    {
        string timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss"); // Generate the timestamp
        string fileName = $"{fileNamePrefix}_{timestamp}.csv"; // Create the full file name
        string appsRunResultFileName = Path.GetFullPath(Path.Combine(context.AppTestResultsDir, fileName));

        // Create result directory
        try
        {
            context.EnsureDirectoryExists(context.AppTestResultsDir);
        }
        catch (Exception ex)
        {
            context.Log.Error($"Failed to create the directory {context.AppTestResultsDir}: {ex.Message}");
            return (false, null);
        }
        context.Log.Information($"Directory: {context.AppTestResultsDir} has been created.");

        // Create result file
        try
        {
            using (File.Create(appsRunResultFileName)) { }
            context.Log.Information($"File '{appsRunResultFileName}' has been created.");
            return (context.FileExists(appsRunResultFileName), appsRunResultFileName);
        }
        catch (Exception ex)
        {
            context.Log.Error($"Failed to create the file {appsRunResultFileName}: {ex.Message}");
            return (false, null);
        }
    }

    public static void DeleteJsonReposFolder(BuildContext context, string appFolder)
    {
        // Validate the instance name
        if (string.IsNullOrWhiteSpace(appFolder))
        {
            context.Log.Error("The provided instance name is empty.");
            return;
        }

        string jsonReposFolder = Path.Combine(appFolder, "JSONREPOS");
        if (context.DirectoryExists(jsonReposFolder))
        {
            // Delete all files and subfolders
            context.Log.Information($"The path {jsonReposFolder} already exists. It needs to be cleaned before.");
            try
            {
                context.CleanDirectory(jsonReposFolder, new CleanDirectorySettings() { Force = true });
                Directory.Delete(jsonReposFolder);
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to clean the directory {jsonReposFolder}: {ex.Message}");
            }
            context.Log.Information($"Directory {jsonReposFolder} has been cleaned.");
        }
    }

    public static void InitializePlcSimInstance(BuildContext context, string instanceName)
    {
        string plcSimSourceDir = context.SourceDirPlcSim;
        string memoryCardPath = context.PlcSimVirtualMemoryCardLocation;

        // Validate the memory card path
        if (!context.DirectoryExists(memoryCardPath))
        {
            context.Log.Error($"The provided path for the virtual memory card does not exist: {memoryCardPath}");
            return;
        }

        // Validate the instance name
        if (string.IsNullOrWhiteSpace(instanceName))
        {
            context.Log.Error("The provided instance name is empty.");
            return;
        }

        // Determine the instance path
        string instancePath = Path.GetFullPath(Path.Combine(memoryCardPath, instanceName));

        if (context.DirectoryExists(instancePath))
        {
            // Delete all files and subfolders
            context.Log.Information($"The instance path {instancePath} already exists. It needs to be cleaned before.");
            try
            {
                context.CleanDirectory(instancePath, new CleanDirectorySettings() { Force = true });
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to clean the directory {instancePath}: {ex.Message}");
            }
            context.Log.Information($"Directory {instancePath} has been cleaned.");
        }

        // Create the instance directory
        try
        {
            context.EnsureDirectoryExists(instancePath);
        }
        catch (Exception ex)
        {
            context.Log.Error($"Failed to create directory {instancePath}: {ex.Message}");
            return;
        }
        context.Log.Information($"Directory: {instancePath} has been created.");

        // Source directory for PLC Sim files
        if (!context.DirectoryExists(plcSimSourceDir))
        {
            context.Log.Error($"Source directory for the plcsim {plcSimSourceDir} does not exist.");
            return;
        }

        // Copy plcsim virtual memory card content
        try
        {
            context.CopyDirectory(plcSimSourceDir, instancePath);
        }
        catch (Exception ex)
        {
            context.Log.Error($"Failed to copy plcsim virtual memory card content from: {plcSimSourceDir} to: {instancePath}: {ex.Message}");
            return;
        }
        context.Log.Information($"Plcsim virtual memory card content has been copied succesfullt from: {plcSimSourceDir} to: {instancePath}");
    }

    public static void KillProcess(BuildContext context, string processName)
    {
        try
        {
            // Get all processes by name
            Process[] processes = Process.GetProcessesByName(processName);

            if (processes.Length > 0)
            {
                foreach (var process in processes)
                {
                    try
                    {
                        // Attempt to kill the process
                        process.Kill(true); // Forcefully terminate the process
                        context.Log.Information($"Successfully terminated process: {process.ProcessName} (ID: {process.Id})");
                    }
                    catch (Exception ex)
                    {
                        context.Log.Error($"Failed to terminate process: {process.ProcessName} (ID: {process.Id}) - {ex.Message}");
                    }
                }
            }
            else
            {
                context.Log.Information($"No processes named '{processName}' were found.");
            }
        }
        catch (Exception ex)
        {
            context.Log.Error($"An error occurred while attempting to find or kill processes: {ex.Message}");
        }
    }

    public static void OverwriteSecurityFiles(BuildContext context, string appYamlFile, string plcName)
    {
        string sourceDirSecurityFiles = context.SourceDirSecurityFiles;

        // Check application YAML file
        if (string.IsNullOrWhiteSpace(appYamlFile))
        {
            context.Log.Error("The provided YAML of the application is empty.");
            return;
        }

        if (!context.FileExists(appYamlFile))
        {
            context.Log.Error($"The provided application file does not exist: {appYamlFile}");
            return;
        }

        string appFolder = Path.GetFullPath(Path.GetDirectoryName(appYamlFile));
        if (string.IsNullOrWhiteSpace(appFolder) || !context.DirectoryExists(appFolder))
        {
            context.Log.Error($"The provided path for the application does not exist: {appFolder}");
            return;
        }


        if (string.IsNullOrWhiteSpace(plcName))
        {
            context.Log.Error("The provided PLC name is empty.");
            return;
        }

        // Check source directory
        if (string.IsNullOrWhiteSpace(sourceDirSecurityFiles))
        {
            context.Log.Error("The provided directory name for the source directory of the security files is empty.");
            return;
        }

        if (!context.DirectoryExists(sourceDirSecurityFiles))
        {
            context.Log.Error($"Source directory for the security file does not exist: {sourceDirSecurityFiles}");
            return;
        }

        // Handle certification folder
        string appCertFolder = Path.Combine(appFolder, "certs");
        if (context.DirectoryExists(appCertFolder))
        {
            context.Log.Information($"The application certification folder {appCertFolder} already exists. It needs to be cleaned before.");
            try
            {
                context.CleanDirectory(appCertFolder, new CleanDirectorySettings() { Force = true });
                context.Log.Information($"The application certification folder {appCertFolder} has been cleaned.");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to clean the application certification folder {appCertFolder}: {ex.Message}");
            }
        }
        else
        {
            try
            {
                context.EnsureDirectoryExists(appCertFolder);
                context.Log.Information($"The application certification folder {appCertFolder} has been created.");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to create the application certification folder {appCertFolder}: {ex.Message}");
            }
        }

        // Handle certification subfolder for the plc: 'plcName'
        string appCertSubFolder = Path.GetFullPath(Path.Combine(appCertFolder, plcName));
        try
        {
            context.EnsureDirectoryExists(appCertSubFolder);
            context.Log.Information($"The application certification  subfolder {appCertSubFolder} has been created.");
        }
        catch (Exception ex)
        {
            context.Log.Error($"Failed to create the application certification folder {appCertSubFolder}: {ex.Message}");
        }

        // Handle certification file
        string plcSourceCertificateFile = $"{plcName}.cer";
        string plcSourceCertificate = Path.GetFullPath(Path.Combine(sourceDirSecurityFiles, plcSourceCertificateFile));
        if (context.FileExists(plcSourceCertificate))
        {
            try
            {
                context.CopyFileToDirectory(plcSourceCertificate, appCertSubFolder);
                context.Log.Information($"Certification file '{plcSourceCertificateFile}' has been copied to: {appCertSubFolder}");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to copy the certification file '{plcSourceCertificateFile}': {ex.Message}");
            }
        }
        else
        {
            context.Log.Error($"Certification file '{plcSourceCertificateFile}' does not exist in the directory: {sourceDirSecurityFiles}");
        }

        // Handle hwc folder
        string appHwcFolder = Path.GetFullPath(Path.Combine(appFolder, "hwc"));
        if (!context.DirectoryExists(appHwcFolder))
        {
            context.Log.Error($"The application's hwc folder does not exist: {appHwcFolder}");
            return;
        }

        // Handle hwc.gen subfolder
        string appHwcGenFolder = Path.GetFullPath(Path.Combine(appHwcFolder, "hwc.gen"));
        if (context.DirectoryExists(appHwcGenFolder))
        {
            context.Log.Information($"The application's hwc.gen subfolder {appHwcGenFolder} already exists. It needs to be cleaned before.");
            try
            {
                context.CleanDirectory(appHwcGenFolder, new CleanDirectorySettings() { Force = true });
                context.Log.Information($"The application's hwc.gen subfolder {appHwcGenFolder} has been cleaned.");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to clean the application's hwc.gen subfolder {appHwcGenFolder}: {ex.Message}");
            }
        }
        else
        {
            try
            {
                context.EnsureDirectoryExists(appHwcGenFolder);
                context.Log.Information($"The application's hwc.gen subfolder {appHwcGenFolder} has been created.");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to create the application's hwc.gen subfolder {appHwcGenFolder}: {ex.Message}");
            }
        }

        // Handle secutity configuration file
        string securityConfigFileName = $"{plcName}.SecurityConfiguration.json";
        string securityConfigFile = Path.GetFullPath(Path.Combine(sourceDirSecurityFiles, securityConfigFileName));
        if (context.FileExists(securityConfigFile))
        {
            try
            {
                context.CopyFileToDirectory(securityConfigFile, appHwcGenFolder);
                context.Log.Information($"Security configuration file '{securityConfigFileName}' successfully copied to: {appHwcGenFolder}");
            }
            catch (Exception ex)
            {
                context.Log.Error($"Failed to copy the file: {ex.Message}");
            }
        }
        else
        {
            context.Log.Information($"Security configuration file '{securityConfigFileName}' does not exist in the directory: {sourceDirSecurityFiles}");
        }
    }

    public static void WriteResult(BuildContext context, string textToWrite, string logFilePath, bool appendToSameLine = false)
    {
        // Check if the log file exists
        if (!context.FileExists(logFilePath))
        {
            context.Log.Error($"The specified log file does not exist: {logFilePath}");
            return;
        }

        try
        {
            if (appendToSameLine)
            {
                // Append to the same line without a newline
                File.AppendAllText(logFilePath, textToWrite);
            }
            else
            {
                // Append text with a newline
                File.AppendAllText(logFilePath, textToWrite + Environment.NewLine);
            }

            context.Log.Information($"Text successfully written to file '{logFilePath}'.");
            context.Log.Information("File content:");

            // Read and display the content of the log file
            var fileContent = File.ReadAllText(logFilePath);
            context.Log.Information(fileContent);
        }
        catch (Exception ex)
        {
            context.Log.Error($"An error occurred while writing to the file: {ex.Message}");
        }
    }
}