// Build
// Copyright (c)2024 MTS spol. s r.o. and Contributors All Rights Reserved.
// Contributors: https://github.com/inxton/AXOpen/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/inxton/AXOpen/blob/master/LICENSE
// Third party licenses: https://github.com/inxton/AXOpen/blob/master/notices.md

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using YamlDotNet.Core;
using YamlDotNet.RepresentationModel;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;
using Path = Cake.Core.IO.Path;

namespace Build;

public static class ApaxTraversal
{
    public static List<ApaxFileInfo> CollectApaxFileInfo(string directoryPath, List<string> excludedPatterns)
    {
        var allFiles = new List<string>();
        var directories = Directory.GetDirectories(directoryPath, "*", SearchOption.AllDirectories);

        // Filter directories based on exclusion patterns
        // var excludedRegexes = excludedPatterns.Select(pattern => 
        //     new Regex("^" + Regex.Escape(pattern).Replace("\\*", ".*") + "$")).ToList();
        //
        // var includedDirectories = directories.Where(dir => 
        //     !excludedRegexes.Any(regex => regex.IsMatch(new DirectoryInfo(dir).Name)));

        CollectApaxFileInfoRecursively(directoryPath, excludedPatterns, allFiles);
        
        // // Include the root directory if it's not excluded
        // if (!excludedRegexes.Any(regex => regex.IsMatch(new DirectoryInfo(directoryPath).Name)))
        // {
        //     includedDirectories = includedDirectories.Append(directoryPath);
        // }
        //
        // foreach (var dir in includedDirectories)
        // {
        //     allFiles.AddRange(Directory.GetFiles(dir, "apax.yml"));
        // }

        var deserializer = new DeserializerBuilder()
            .WithNamingConvention(UnderscoredNamingConvention.Instance) // Adjust this as per your YAML file's naming convention
            .IgnoreFields()
            .IgnoreUnmatchedProperties()
            .Build();

        
        var fileInfoList = new List<ApaxFileInfo>(); // Assuming FileInfo is a class you've defined to store file information
        foreach (var filePath in allFiles)
        {
            try
            {
                var yamlContent = File.ReadAllText(filePath);
                var fileInfo = deserializer.Deserialize<ApaxFileInfo>(yamlContent);
                fileInfoList.Add(fileInfo);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error processing file {filePath}: {ex.Message}");
            }
        }

        return fileInfoList;
    }

   
    internal static void CollectApaxFileInfoRecursively(string directoryPath, List<string> excludedDirectories, List<string> allFiles)
    {
        foreach (var directory in Directory.GetDirectories(directoryPath))
        {
            if (excludedDirectories.Any(excluded => new DirectoryInfo(directory).Name.Equals(excluded, StringComparison.OrdinalIgnoreCase)))
            {
                continue; // Skip this directory
            }

            CollectApaxFileInfoRecursively(directory, excludedDirectories, allFiles); // Recurse into subdirectories
        }

        allFiles.AddRange(Directory.GetFiles(directoryPath, "apax.yml")); // Add .yml files from current directory
    }
    
    private static void CreateDependenciesFile(List<ApaxFileInfo> dependencies, string filePath)
    {
        //var serializer = new SerializerBuilder()
        //    .WithNamingConvention(CamelCaseNamingConvention.Instance) // Adjust this as per your desired YAML file's naming convention
        //    .Build();

        //var dependenciesDictionary = new Dictionary<string, string>();

        //foreach (var dependency in dependencies.Where(p => p.Name != "apax.traversal" 
        //                                                   && p.Name != "@inxton/ax-sdk" 
        //                                                   && !p.Name.EndsWith("-test")
        //                                                   && p.Name != "inxton"))
        //{
        //    if (!dependenciesDictionary.ContainsKey(dependency.Name))
        //    {
        //        dependenciesDictionary.Add(dependency.Name , dependency.Version);    
        //    }
        //}

        //var yamlContent = serializer.Serialize(new { name = "apax.traversal", 
        //                                                        version = "0.0.0-dev.0", 
        //                                                        type = "app",
        //                                                        targets = new string[] {"\"1500\""},
        //                                                        registries = new Dictionary<string, string>()
        //                                                            { {"@inxton", "https://npm.pkg.github.com/"} },
        //                                                        devDependencies = new Dictionary<string, string>() 
        //                                                            { {"@inxton/ax-sdk", dependencies.First(p => p.Name == "@inxton/ax-sdk").Version} },
        //                                                        dependencies = dependenciesDictionary,
        //                                                        installStrategy = "overridable"});

        //File.WriteAllText(filePath, yamlContent);

        var dependenciesDictionary = new Dictionary<string, string>();
        foreach (var dependency in dependencies.Where(p =>
            p.Name != "apax.traversal" &&
            p.Name != "@inxton/ax-sdk" &&
            !p.Name.EndsWith("-test") &&
            p.Name != "inxton"))
        {
            if (!dependenciesDictionary.ContainsKey(dependency.Name))
            {
                dependenciesDictionary.Add(dependency.Name, dependency.Version);
            }
        }

        // Build YAML manually with correct quoting
        var yaml = new YamlStream();
        var root = new YamlMappingNode
        {
            { "name", new YamlScalarNode("apax.traversal") { Style = ScalarStyle.DoubleQuoted } },
            { "version", new YamlScalarNode("0.0.0-dev.0") { Style = ScalarStyle.DoubleQuoted } },
            { "type", new YamlScalarNode("app") { Style = ScalarStyle.DoubleQuoted } },
            { "targets", new YamlSequenceNode(new YamlScalarNode("1500") { Style = ScalarStyle.DoubleQuoted }) },
            { "registries", new YamlMappingNode
                {
                    { "@inxton", new YamlScalarNode("https://npm.pkg.github.com/") { Style = ScalarStyle.DoubleQuoted } }
                }
            },
            { "devDependencies", new YamlMappingNode
                {
                    { "@inxton/ax-sdk", new YamlScalarNode(dependencies.First(p => p.Name == "@inxton/ax-sdk").Version) { Style = ScalarStyle.DoubleQuoted } }
                }
            },
            { "dependencies", new YamlMappingNode(
                dependenciesDictionary.Select(kv =>
                    new KeyValuePair<YamlNode, YamlNode>(
                        new YamlScalarNode(kv.Key) { Style = ScalarStyle.DoubleQuoted },
                        new YamlScalarNode(kv.Value) { Style = ScalarStyle.DoubleQuoted }
                    )
                )
            )},
            { "installStrategy", new YamlScalarNode("overridable") { Style = ScalarStyle.DoubleQuoted } }
        };

        yaml.Documents.Add(new YamlDocument(root));

        using (var writer = new StreamWriter(filePath))
        {
            yaml.Save(writer, assignAnchors: false);
        }
    }

    public static void CreateApaxTraversal(this BuildContext context, string dir, string outputFile)
    {
        CreateDependenciesFile(CollectApaxFileInfo(dir, new List<string>() { ".apax", "traversals"}), outputFile);
    }
    
    public class ApaxFileInfo
    {
        public string Name { get; set; }
        public string Version { get; set; }       
    }
}