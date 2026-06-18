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
using System.Runtime.InteropServices;
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
using Cake.Core.Diagnostics;


public partial class BuildContext : FrostingContext
{

    public bool IsGitHubActions { get; set; }

    public bool IsGitLabCI { get; set; }

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
        IsGitLabCI = context.EnvironmentVariable("GITLAB_CI") == "true";
    }

    #region Libraries

    // ─────────────────────────────────────────────────────────────────────────────
    // Library discovery
    //
    // The libraries the per-library build tasks iterate (clean, catalog-install,
    // provision, apax build/test, apax pack) are discovered from the file system so a
    // newly scaffolded library under 'src/<folder>' (see
    // scripts/create_library_from_template.ps1) is picked up automatically - WITHOUT
    // editing this file.
    //
    // The effective set is:  CuratedBaseLibraries  ∪  auto-discovered component libraries,
    // de-duplicated by folder with the curated entry winning.
    // ─────────────────────────────────────────────────────────────────────────────

    // Non-standard entries that must NOT be auto-inferred: they either do not follow the
    // 'src/<folder>/ctrl/apax.yml' component pattern, have a folder name that differs from
    // their apax name (sdk-ax -> ax-sdk), or carry deliberately non-default pack/test flags
    // (template.axolibrary is never packed or tested). These are always excluded from
    // discovery and emitted verbatim.
    private static readonly (string folder, string name, bool pack, bool app_run, bool test)[] CuratedBaseLibraries =
    {
        ("ax.axopen.min",       "ax.axopen.min",       true,  false, false),
        ("ax.axopen.hwlibrary", "ax.axopen.hwlibrary", true,  false, false),
        ("ax.axopen.app",       "ax.axopen.app",       true,  false, false),
        ("sdk-ax",              "ax-sdk",              true,  false, false),
        ("template.axolibrary", "template.axolibrary", false, false, false),
    };

    // Folders under 'src' that must never be treated as buildable libraries.
    // ► Add a folder name here to exclude it from the whole per-library build pipeline. ◄
    // (The CuratedBaseLibraries folders above are excluded from discovery automatically.)
    private static readonly HashSet<string> DiscoveryExcludes = new(StringComparer.OrdinalIgnoreCase)
    {
        "components.citemplate", // throwaway library scaffolded + deleted by TemplateTestTask
    };

    // Per-folder flag overrides for discovered libraries. Discovery defaults every library
    // to pack=true, test=true; list a folder here only to deviate from that default
    // (null = keep the default). 'io' and 'probers' build & pack but are intentionally
    // excluded from the apax test run.
    private static readonly Dictionary<string, (bool? pack, bool? test)> DiscoveryOverrides =
        new(StringComparer.OrdinalIgnoreCase)
    {
        { "io",      (pack: null, test: false) },
        { "probers", (pack: null, test: false) },
    };

    private IReadOnlyList<(string folder, string name, bool pack, bool app_run, bool test)> _libraries;

    public IEnumerable<(string folder, string name, bool pack, bool app_run, bool test)> Libraries =>
        _libraries ??= BuildLibrarySet();

    private IReadOnlyList<(string folder, string name, bool pack, bool app_run, bool test)> BuildLibrarySet()
    {
        // Curated entries are concatenated first so they win on any folder collision.
        return CuratedBaseLibraries
            .Concat(DiscoverComponentLibraries())
            .GroupBy(l => l.folder, StringComparer.OrdinalIgnoreCase)
            .Select(g => g.First())
            .ToList();
    }

    private IEnumerable<(string folder, string name, bool pack, bool app_run, bool test)> DiscoverComponentLibraries()
    {
        if (!Directory.Exists(RootDir))
        {
            yield break;
        }

        // Curated-base folders are always excluded from discovery (added verbatim instead).
        var excluded = new HashSet<string>(DiscoveryExcludes, StringComparer.OrdinalIgnoreCase);
        foreach (var curated in CuratedBaseLibraries)
        {
            excluded.Add(curated.folder);
        }

        // Ordinal sort -> deterministic, machine-independent ordering of discovered libraries.
        foreach (var dir in Directory.GetDirectories(RootDir).OrderBy(Path.GetFileName, StringComparer.Ordinal))
        {
            var folder = Path.GetFileName(dir);
            if (excluded.Contains(folder))
            {
                continue;
            }

            // A controller library is identified by 'ctrl/apax.yml'. This naturally skips
            // non-library folders such as 'traversals', 'styling', 'showcase', 'docs'.
            var ctrlApax = Path.Combine(dir, "ctrl", "apax.yml");
            if (!File.Exists(ctrlApax))
            {
                continue;
            }

            string name;
            try
            {
                name = ApaxFile.CreateApaxDto(ctrlApax).Name;
            }
            catch (Exception ex)
            {
                Log.Warning($"Skipping '{folder}': could not read apax name from '{ctrlApax}': {ex.Message}");
                continue;
            }

            if (string.IsNullOrWhiteSpace(name))
            {
                Log.Warning($"Skipping '{folder}': empty apax name in '{ctrlApax}'.");
                continue;
            }

            // Strip the registry prefix: '@inxton/axopen.components.drives' -> 'axopen.components.drives'.
            if (name.StartsWith("@"))
            {
                var slash = name.IndexOf('/');
                if (slash >= 0 && slash < name.Length - 1)
                {
                    name = name.Substring(slash + 1);
                }
            }

            var ov = DiscoveryOverrides.TryGetValue(folder, out var o) ? o : (pack: (bool?)null, test: (bool?)null);
            var pack = ov.pack ?? true;
            var test = ov.test ?? true;

            yield return (folder, name, pack, false, test);
        }
    }
    #endregion
    
    public string GitHubUser { get; } = System.Environment.GetEnvironmentVariable("GH_USER");

    public string GitHubToken { get; } = System.Environment.GetEnvironmentVariable("GH_TOKEN");

    public string ApaxSignKey { get; } = System.Environment.GetEnvironmentVariable("APAX_KEY");

    // GitLab CI predefined variables (https://docs.gitlab.com/ci/variables/predefined_variables/).
    // CI_JOB_TOKEN authenticates the project Package Registry and Releases API for the running job.
    // GITLAB_API_TOKEN is an optional PAT fallback for the Releases API when job-token API access is off.
    public string GitLabToken { get; } = System.Environment.GetEnvironmentVariable("CI_JOB_TOKEN");

    public string GitLabApiV4Url { get; } = System.Environment.GetEnvironmentVariable("CI_API_V4_URL");

    public string GitLabProjectId { get; } = System.Environment.GetEnvironmentVariable("CI_PROJECT_ID");

    public string GitLabApiToken { get; } = System.Environment.GetEnvironmentVariable("GITLAB_API_TOKEN");

    // Project-scoped GitLab endpoints derived from the predefined variables above.
    public string GitLabNuGetSource => $"{GitLabApiV4Url}/projects/{GitLabProjectId}/packages/nuget/index.json";

    public string GitLabNpmRegistry => $"{GitLabApiV4Url}/projects/{GitLabProjectId}/packages/npm/";

    public string GitLabReleasesApi => $"{GitLabApiV4Url}/projects/{GitLabProjectId}/releases";

    public IEnumerable<string> GetAxFolders((string folder, string name, bool pack, bool app_run, bool test) library)
    {
        var paths = new string[]
        {
            Path.Combine(Path.Combine(RootDir, library.folder), "ctrl"),
            Path.Combine(Path.Combine(RootDir, library.folder), "ax")
        };

        return paths.Where(p => File.Exists(Path.Combine(p, "apax.yml")));
    }

    public IEnumerable<string> GetApplicationAxFolders((string folder, string name, bool pack) library)
    {
        var paths = new string[]
        {
            Path.Combine(Path.Combine(RootDir, library.folder), "ax")
        };

        return paths.Where(p => File.Exists(Path.Combine(p, "apax.yml")));
    }

    public IEnumerable<string> GetLibraryAxFolders((string folder, string name, bool pack, bool app_run, bool test) library)
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

    public string GetLibFolder((string folder, string name, bool pack, bool app_run, bool test) library)
    {
        return Path.Combine(Path.Combine(RootDir, library.folder), "ctrl");
    }

    public string GetAppFolder((string folder, string name) library)
    {
        return Path.Combine(Path.Combine(RootDir, library.folder), "app");
    }

    public string GetAppFolder((string folder, string name, bool pack, bool app_run, bool test) library)
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

    
    public IEnumerable<string> GetApaxFiles((string folder, string name, bool pack, bool app_run, bool test) library)
    {
        var paths = new string[]
        {
            Path.Combine(Path.Combine(RootDir, library.folder), "ctrl", "apax.yml"),
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

    internal void ProvisionNodeJs()
    {
        // Check if node is available
        var nodeCommand = RuntimeInformation.IsOSPlatform(OSPlatform.Linux) ? "node" : "node.exe";
        var npmCommand = RuntimeInformation.IsOSPlatform(OSPlatform.Linux) ? "npm" : "npm.cmd";

        try
        {
            var nodeProcess = ProcessRunner.Start(nodeCommand, new ProcessSettings()
            {
                Arguments = "--version",
                RedirectStandardOutput = true,
                RedirectStandardError = true,
                Silent = true
            });

            nodeProcess.WaitForExit();

            if (nodeProcess.GetExitCode() == 0)
            {
                var version = string.Join("", nodeProcess.GetStandardOutput());
                Log.Information($"Node.js is already installed: {version.Trim()}");
                return;
            }
        }
        catch (Exception ex)
        {
            Log.Warning($"Node.js not found or failed to execute: {ex.Message}");
        }

        // Node.js is not available, provision it
        Log.Information("Node.js not found. Provisioning Node.js...");

        if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
        {
            // Use winget to install Node.js on Windows
            Log.Information("Attempting to install Node.js using winget...");
            var wingetProcess = ProcessRunner.Start("winget", new ProcessSettings()
            {
                Arguments = "install OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements",
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                Silent = false
            });

            wingetProcess.WaitForExit();

            if (wingetProcess.GetExitCode() != 0)
            {
                Log.Warning("winget installation failed. Trying Chocolatey...");
                
                // Fallback to Chocolatey
                var chocoProcess = ProcessRunner.Start("choco", new ProcessSettings()
                {
                    Arguments = "install nodejs-lts -y",
                    RedirectStandardOutput = false,
                    RedirectStandardError = false,
                    Silent = false
                });

                chocoProcess.WaitForExit();

                if (chocoProcess.GetExitCode() != 0)
                {
                    throw new Exception("Failed to provision Node.js. Please install Node.js manually from https://nodejs.org/");
                }
            }
        }
        else
        {
            // Linux - use package manager or nvm
            Log.Information("Attempting to install Node.js on Linux...");
            
            // Try using apt (Debian/Ubuntu)
            var aptProcess = ProcessRunner.Start("bash", new ProcessSettings()
            {
                Arguments = "-c \"curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && sudo apt-get install -y nodejs\"",
                RedirectStandardOutput = false,
                RedirectStandardError = false,
                Silent = false
            });

            aptProcess.WaitForExit();

            if (aptProcess.GetExitCode() != 0)
            {
                throw new Exception("Failed to provision Node.js on Linux. Please install Node.js manually.");
            }
        }

        Log.Information("Node.js provisioning completed.");
    }
}