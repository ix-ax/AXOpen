using CommandLine.Text;
using CommandLine;
using System.Diagnostics;

namespace axo.snippetify
{
    using System;
    using System.IO;
    using CommandLine;
    using CommandLine.Text;

    class Program
    {
        static void Main(string[] args)
        {
            ParserResult<Options> result = Parser.Default.ParseArguments<Options>(args);
            result.WithParsed(options =>
            {
                string sourceFile = options.SourceFile;
                string snippetName = options.SnippetName;
                string snippetFile = snippetName + ".json";
                string outputFile = options.OutputFile;

                try
                {
                    using (StreamReader reader = new StreamReader(sourceFile))
                    using (StreamWriter snippetWriter = new StreamWriter(outputFile))
                    {
                        snippetWriter.WriteLine("{");
                        snippetWriter.WriteLine("\t\"" + snippetName + "\": {");
                        snippetWriter.WriteLine("\t\t\"prefix\": [\"" + snippetName + "\"],");
                        snippetWriter.WriteLine("\t\t\"scope\": \"" + "st" + "\",");
                        snippetWriter.WriteLine("\t\t\"body\": [");

                        bool isFirstLine = true;
                        while (!reader.EndOfStream)
                        {
                            string line = reader.ReadLine();
                            string escapedLine = line.Replace("\\", "\\\\").Replace("\"", "\\\"");
                            snippetWriter.WriteLine("\t\t\"" + escapedLine + "\"" + (reader.EndOfStream ? "" : ","));
                            isFirstLine = false;
                        }

                        snippetWriter.WriteLine("\t\t],");
                        snippetWriter.WriteLine("\t\t\"description\": \"Snippet for " + snippetName + "\"");
                        snippetWriter.WriteLine("\t}");
                        snippetWriter.WriteLine("}");

                        Console.WriteLine("Snippet created successfully.");
                    }

                    Console.WriteLine("File processed successfully.");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("An error occurred: " + ex.Message);
                }
            })
            .WithNotParsed(errors =>
            {
                HelpText helpText = HelpText.AutoBuild(result);
                Console.WriteLine(helpText);
            });
        }
    }

    class Options
    {
        [Value(0, Required = true, HelpText = "The path to the source file.")]
        public string SourceFile { get; set; }

        [Value(1, Required = true, HelpText = "The name of the output file.")]
        public string OutputFile { get; set; }

        [Value(2, Required = true, HelpText = "The name of the snippet.")]
        public string SnippetName { get; set; }
    }

}