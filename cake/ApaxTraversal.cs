// Build
// Copyright (c)2024 Peter Kurhajec and Contributors All Rights Reserved.
// Contributors: https://github.com/PTKu/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/PTKu/ix/blob/master/LICENSE
// Third party licenses: https://github.com/PTKu/ix/blob/master/notices.md

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
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

    private static void CollectApaxFileInfoRecursively(string directoryPath, List<string> excludedDirectories, List<string> allFiles)
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
        var serializer = new SerializerBuilder()
            .WithNamingConvention(CamelCaseNamingConvention.Instance) // Adjust this as per your desired YAML file's naming convention
            .Build();

        var dependenciesDictionary = new Dictionary<string, string>();

        foreach (var dependency in dependencies.Where(p => p.Name != "apax.traversal" 
                                                           && p.Name != "@ix-ax/ax-sdk" 
                                                           && !p.Name.EndsWith("-test")
                                                           && p.Name != "ix-ax"))
        {
            if (!dependenciesDictionary.ContainsKey(dependency.Name))
            {
                dependenciesDictionary.Add(dependency.Name , dependency.Version);    
            }
        }
        
        var yamlContent = serializer.Serialize(new { name = "apax.traversal", 
                                                                version = "0.0.0", 
                                                                type = "app",
                                                                targets = new string[] {"plcsim", "llvm"},
                                                                devDependencies = new Dictionary<string, string>() { {"@ix-ax/ax-sdk", dependencies.First(p => p.Name == "@ix-ax/ax-sdk").Version} }, 
                                                                dependencies = dependenciesDictionary});

        File.WriteAllText(filePath, yamlContent);
    }

    public static void CreateApaxTraversal(this BuildContext context, string dir, string outputFile)
    {
        CreateDependenciesFile(CollectApaxFileInfo(dir,new List<string>() { ".apax", "traversals"}), outputFile);
    }
    
    public class ApaxFileInfo
    {
        public string Name { get; set; }
        public string Version { get; set; }
    }
}