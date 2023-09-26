using System;
using System.IO;
using System.Linq;
using CommandLine;

namespace FileCopyUtility
{
    class Program
    {
        private static readonly string[] ExcludedDirectories = { ".apax", "bin", "obj", "wwwroot"};

        static void Main(string[] args)
        {
            Parser.Default.ParseArguments<Options>(args)
                .WithParsed(opts => RunCopy(opts))
                .WithNotParsed((errs) => HandleParseError(errs));
        }

        private static void HandleParseError(IEnumerable<Error> errs)
        {
            // Handle errors
            Console.WriteLine("Error parsing arguments.");
        }

        private static void RunCopy(Options opts)
        {
            if (!Directory.Exists(opts.DestinationDirectory))
            {
                Directory.CreateDirectory(opts.DestinationDirectory);
            }

            CopyFiles(opts.SourceDirectory, opts.DestinationDirectory);

            Console.WriteLine("Files copied successfully!");
        }

        private static void CopyFiles(string sourceDirectory, string destinationDirectory)
        {
           foreach (var file in Directory.GetFiles(sourceDirectory, "*.*", SearchOption.AllDirectories)
                .Where(file => (new[] { ".md", ".svg", ".png", ".gif", "toc.yml" }.Any(ext => file.EndsWith(ext)))
                            && !ExcludedDirectories.Any(ex => file.Contains($@"\{ex}\"))))
            {
                var destFile = file.Replace(sourceDirectory, destinationDirectory);
                var destDir = Path.GetDirectoryName(destFile);

                if (!Directory.Exists(destDir))
                {
                    Directory.CreateDirectory(destDir);
                }

                File.Copy(file, destFile, true);
        }       
    }
    }

    public class Options
    {
        [Option('s', "source", Required = true, HelpText = "Source directory path.")]
        public string SourceDirectory { get; set; }

        [Option('d', "destination", Required = true, HelpText = "Destination directory path.")]
        public string DestinationDirectory { get; set; }
    }
}


