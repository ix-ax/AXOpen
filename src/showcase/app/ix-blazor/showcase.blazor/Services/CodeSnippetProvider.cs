using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace showcase.Services
{
    /// <summary>
    /// Provides code snippets from actual source files for display in documentation pages.
    /// </summary>
    public class CodeSnippetProvider
    {
        private readonly string _basePath;

        public CodeSnippetProvider(string basePath = null)
        {
            // Default to the project root if not specified
            _basePath = basePath ?? GetProjectRoot();
        }

        /// <summary>
        /// Retrieves code snippet from a file, optionally extracting a range of lines.
        /// </summary>
        public async Task<CodeSnippet> GetSnippetAsync(string filePath, int? startLine = null, int? endLine = null)
        {
            try
            {
                var fullPath = Path.Combine(_basePath, filePath);
                var normalizedPath = Path.GetFullPath(fullPath);

                System.Diagnostics.Debug.WriteLine($"CodeSnippetProvider: Looking for file at {normalizedPath}");
                Console.WriteLine($"CodeSnippetProvider: Looking for file at {normalizedPath}");
                Console.WriteLine($"CodeSnippetProvider: Base path is {_basePath}");

                if (!File.Exists(normalizedPath))
                {
                    // Try alternative paths
                    var altPaths = new[]
                    {
                        Path.Combine(_basePath, "..", filePath),
                        Path.Combine(AppContext.BaseDirectory, "..", "..", "..", "..", "..", filePath)
                    };

                    foreach (var altPath in altPaths)
                    {
                        var normalized = Path.GetFullPath(altPath);
                        Console.WriteLine($"CodeSnippetProvider: Trying alternative path {normalized}");
                        if (File.Exists(normalized))
                        {
                            normalizedPath = normalized;
                            break;
                        }
                    }

                    if (!File.Exists(normalizedPath))
                    {
                        return new CodeSnippet
                        {
                            FilePath = filePath,
                            Content = $"// File not found at: {normalizedPath}",
                            Language = GetLanguageFromExtension(filePath),
                            IsError = true
                        };
                    }
                }

                var allLines = await File.ReadAllLinesAsync(normalizedPath);
                var snippet = ExtractLines(allLines, startLine, endLine);

                return new CodeSnippet
                {
                    FilePath = filePath,
                    Content = TrimCommonIndent(snippet),
                    Language = GetLanguageFromExtension(filePath),
                    StartLine = startLine ?? 1,
                    EndLine = endLine ?? allLines.Length
                };
            }
            catch (Exception ex)
            {
                Console.WriteLine($"CodeSnippetProvider Error: {ex}");
                return new CodeSnippet
                {
                    FilePath = filePath,
                    Content = $"// Error reading file: {ex.Message}",
                    Language = GetLanguageFromExtension(filePath),
                    IsError = true
                };
            }
        }

        /// <summary>
        /// Extracts the code region delimited by open/close tag markers.
        /// Supports ST-style:     //<TagName>  …  //</TagName>
        /// Supports Razor/HTML:   <!-- <TagName> -->  …  <!-- </TagName> -->
        /// Supports YAML/shell:   #<TagName>  …  #</TagName>
        /// Matching is case-insensitive and tolerates extra whitespace inside the markers.
        /// </summary>
        public async Task<CodeSnippet> GetTaggedRegionAsync(string filePath, string tagName)
        {
            var full = await GetSnippetAsync(filePath);
            if (full.IsError)
                return full;

            var lines = full.Content.Split(new[] { "\r\n", "\n" }, StringSplitOptions.None);
            int start = -1;
            int end   = -1;

            for (int i = 0; i < lines.Length; i++)
            {
                var t = lines[i].Trim();

                if (start < 0)
                {
                    if (IsOpenTag(t, tagName))
                        start = i + 1;   // content starts on the next line
                }
                else
                {
                    if (IsCloseTag(t, tagName))
                    {
                        end = i;         // content ends before this line
                        break;
                    }
                }
            }

            if (start < 0 || end < 0 || end <= start)
                return new CodeSnippet
                {
                    FilePath = filePath,
                    Content  = $"// Region '<{tagName}>' not found in {filePath}",
                    Language = full.Language,
                    IsError  = true
                };

            return new CodeSnippet
            {
                FilePath  = filePath,
                Content   = TrimCommonIndent(lines[start..end]),
                Language  = full.Language,
                StartLine = start + 1,
                EndLine   = end
            };
        }

        private static bool IsOpenTag(string trimmedLine, string tagName)
        {
            // ST:   //<TagName>   or   //< TagName>
            if (trimmedLine.StartsWith("//", StringComparison.Ordinal))
            {
                var inner = trimmedLine[2..].Trim().Trim('<', '>').Trim();
                return inner.Equals(tagName, StringComparison.OrdinalIgnoreCase);
            }
            // HTML: <!-- <TagName> -->
            if (trimmedLine.StartsWith("<!--", StringComparison.Ordinal) &&
                trimmedLine.EndsWith("-->", StringComparison.Ordinal))
            {
                var inner = trimmedLine[4..^3].Trim().Trim('<', '>').Trim();
                return inner.Equals(tagName, StringComparison.OrdinalIgnoreCase);
            }
            // YAML/shell:   #<TagName>   or   # <TagName>
            if (trimmedLine.StartsWith("#", StringComparison.Ordinal) &&
                !trimmedLine.StartsWith("##", StringComparison.Ordinal))
            {
                var inner = trimmedLine[1..].Trim().Trim('<', '>').Trim();
                return inner.Equals(tagName, StringComparison.OrdinalIgnoreCase);
            }
            return false;
        }

        private static bool IsCloseTag(string trimmedLine, string tagName)
        {
            // ST:   //</TagName>   or   //< /TagName>
            if (trimmedLine.StartsWith("//", StringComparison.Ordinal))
            {
                var inner = trimmedLine[2..].Trim().TrimStart('<').TrimStart('/').Trim().TrimEnd('>').Trim();
                return inner.Equals(tagName, StringComparison.OrdinalIgnoreCase);
            }
            // HTML: <!-- </TagName> -->
            if (trimmedLine.StartsWith("<!--", StringComparison.Ordinal) &&
                trimmedLine.EndsWith("-->", StringComparison.Ordinal))
            {
                var inner = trimmedLine[4..^3].Trim().TrimStart('<').TrimStart('/').Trim().TrimEnd('>').Trim();
                return inner.Equals(tagName, StringComparison.OrdinalIgnoreCase);
            }
            // YAML/shell:   #</TagName>   or   # </TagName>
            if (trimmedLine.StartsWith("#", StringComparison.Ordinal) &&
                !trimmedLine.StartsWith("##", StringComparison.Ordinal))
            {
                var inner = trimmedLine[1..].Trim().TrimStart('<').TrimStart('/').Trim().TrimEnd('>').Trim();
                return inner.Equals(tagName, StringComparison.OrdinalIgnoreCase);
            }
            return false;
        }

        /// <summary>
        /// Extracts full sequencer step blocks from ST code.
        /// Looks for patterns: IF(Steps[x].Execute(...)) THEN ... END_IF;
        /// </summary>
        public async Task<List<StepLogicBlock>> GetStepLogicBlocksAsync(string filePath)
        {
            var result = new List<StepLogicBlock>();
            var snippet = await GetSnippetAsync(filePath);

            if (snippet.IsError || string.IsNullOrWhiteSpace(snippet.Content))
            {
                return result;
            }

            var lines = snippet.Content.Split(new[] { "\r\n", "\n" }, StringSplitOptions.None);
            StepLogicBlock current = null;
            var currentLines = new List<string>();
            var nestingDepth = 0;

            for (var i = 0; i < lines.Length; i++)
            {
                var line = lines[i];
                var trimmed = line.Trim();

                var isStepStart = current == null && trimmed.StartsWith("IF(") && trimmed.Contains(".Execute(");

                if (isStepStart)
                {
                    var stepSymbol = ParseStepSymbol(trimmed);
                    var stepNo = ParseStepNumber(trimmed);
                    var title = ParseStepTitle(trimmed);

                    current = new StepLogicBlock
                    {
                        StepNumber = stepNo,
                        StepSymbol = stepSymbol,
                        Title = title,
                        StartLine = i + 1
                    };

                    currentLines.Clear();
                    currentLines.Add(line);
                    nestingDepth = 1;
                    continue;
                }

                if (current == null)
                {
                    continue;
                }

                currentLines.Add(line);

                if (trimmed.StartsWith("IF(") || trimmed.StartsWith("IF "))
                {
                    nestingDepth++;
                }

                if (trimmed.StartsWith("END_IF;"))
                {
                    nestingDepth--;
                }

                if (nestingDepth == 0)
                {
                    current.EndLine = i + 1;
                    current.Logic = TrimCommonIndent(currentLines.ToArray());
                    result.Add(current);

                    current = null;
                    currentLines.Clear();
                }
            }

            return result;
        }

        private static string ParseStepSymbol(string stepLine)
        {
            // Extracts the identifier between IF( and .Execute(  e.g. "Steps[2]" from "IF(Steps[2].Execute(..."
            var ifStart = stepLine.IndexOf("IF(", StringComparison.Ordinal);
            if (ifStart < 0) return string.Empty;

            var symbolStart = ifStart + "IF(".Length;
            var executeIdx = stepLine.IndexOf(".Execute(", symbolStart, StringComparison.Ordinal);
            if (executeIdx < 0) return string.Empty;

            return stepLine.Substring(symbolStart, executeIdx - symbolStart);
        }

        private static int ParseStepNumber(string stepLine)
        {
            var start = stepLine.IndexOf("Steps[", StringComparison.Ordinal);
            if (start < 0) return -1;

            start += "Steps[".Length;
            var end = stepLine.IndexOf(']', start);
            if (end < 0) return -1;

            var token = stepLine.Substring(start, end - start);
            return int.TryParse(token, out var number) ? number : -1;
        }

        private static string ParseStepTitle(string stepLine)
        {
            var firstQuote = stepLine.IndexOf('\'', StringComparison.Ordinal);
            if (firstQuote < 0) return "Unnamed step";

            var secondQuote = stepLine.IndexOf('\'', firstQuote + 1);
            if (secondQuote < 0) return "Unnamed step";

            return stepLine.Substring(firstQuote + 1, secondQuote - firstQuote - 1);
        }

        /// <summary>
        /// Removes the common leading whitespace from all non-empty lines so snippets
        /// render left-aligned regardless of their indentation in the source file.
        /// </summary>
        private static string TrimCommonIndent(string[] lines)
        {
            var nonEmpty = lines.Where(l => !string.IsNullOrWhiteSpace(l)).ToArray();
            if (nonEmpty.Length == 0)
                return string.Join(Environment.NewLine, lines);

            int common = nonEmpty
                .Select(l => l.Length - l.TrimStart().Length)
                .Min();

            return string.Join(
                Environment.NewLine,
                lines.Select(l => l.Length >= common ? l[common..] : l.TrimStart())
            );
        }

        private string[] ExtractLines(string[] allLines, int? startLine, int? endLine)
        {
            var start = (startLine.HasValue ? startLine.Value - 1 : 0);
            var end = (endLine.HasValue ? Math.Min(endLine.Value, allLines.Length) : allLines.Length);

            if (start < 0 || start >= allLines.Length)
                return allLines;

            return allLines[start..end];
        }

        private string GetLanguageFromExtension(string filePath)
        {
            var ext = Path.GetExtension(filePath).ToLowerInvariant();
            return ext switch
            {
                ".st" => "structured-text",
                ".cs" => "csharp",
                ".razor" => "html",
                ".json" => "json",
                ".xml" => "xml",
                ".yml" => "yaml",
                ".md" => "markdown",
                _ => "plaintext"
            };
        }

        private string GetProjectRoot()
        {
            // Start from the current directory and navigate up to find the solution root
            var currentDir = AppContext.BaseDirectory;
            var root = new DirectoryInfo(currentDir);

            // Look for repo root markers
            int levels = 0;
            while (root.Parent != null && levels < 15)
            {
                // Check for repo root markers
                if (File.Exists(Path.Combine(root.FullName, "Directory.Build.props")) ||
                    File.Exists(Path.Combine(root.FullName, "Directory.Packages.props")) ||
                    (Directory.Exists(Path.Combine(root.FullName, "src", "showcase", "app", "src")) &&
                     Directory.Exists(Path.Combine(root.FullName, "src", "showcase", "app", "ix-blazor"))))
                {
                    return root.FullName;
                }
                root = root.Parent;
                levels++;
            }

            // Fallback: go up from bin/Debug/net10.0 structure
            // From: c:\...\ix-blazor\showcase.blazor\bin\Debug\net10.0
            // To:   c:\...\axopen (repo root)
            root = new DirectoryInfo(currentDir);
            for (int i = 0; i < 8; i++)
            {
                if (root.Parent != null)
                    root = root.Parent;
            }

            return root.FullName;
        }
    }

    public class CodeSnippet
    {
        public string FilePath { get; set; }
        public string Content { get; set; }
        public string Language { get; set; }
        public int StartLine { get; set; } = 1;
        public int EndLine { get; set; }
        public bool IsError { get; set; }
    }

    public class StepLogicBlock
    {
        public int StepNumber { get; set; }
        /// <summary>
        /// The raw identifier of the step as written in ST source, e.g. "Steps[2]".
        /// Used to correlate to the live AxoStep twin via its Symbol tail.
        /// </summary>
        public string StepSymbol { get; set; } = string.Empty;
        public string Title { get; set; }
        public string Logic { get; set; }
        public int StartLine { get; set; }
        public int EndLine { get; set; }
    }
}
