using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace showcase.Services
{
    /// <summary>
    /// Pre-processes DocFX-flavored markdown into standard markdown that Markdig can render.
    /// Resolves:
    ///   - [!code-LANG[](PATH?range=...)]  — inline code from file with line ranges
    ///   - [!code-LANG[](PATH?name=...)]   — inline code from file with tagged regions
    ///   - [!code-LANG[](PATH)]            — inline entire file as code block
    ///   - [!INCLUDE [Label](PATH)]        — inline file contents (recursive, depth-limited)
    /// </summary>
    public class DocFxMarkdownProcessor
    {
        private readonly string _basePath;
        private const int MaxIncludeDepth = 5;

        // [!code-smalltalk[](../../path/file.st?range=4-16,60)]
        // [!code-csharp[](path/file.cs?name=TagName)]
        // [!code-html[](path/file.razor)]
        private static readonly Regex CodeIncludeRegex = new(
            @"\[!code-(\w+)\[\]\(([^)]+)\)\]",
            RegexOptions.Compiled);

        // [!INCLUDE [Label](path/file.md)]
        private static readonly Regex FileIncludeRegex = new(
            @"\[!INCLUDE\s+\[[^\]]*\]\(([^)]+)\)\]",
            RegexOptions.Compiled | RegexOptions.IgnoreCase);

        private static readonly Dictionary<string, string> LangMap = new(StringComparer.OrdinalIgnoreCase)
        {
            ["smalltalk"] = "iecst",
            ["pascal"] = "iecst",
            ["csharp"] = "csharp",
            ["html"] = "html",
            ["xml"] = "xml",
            ["yaml"] = "yaml",
            ["json"] = "json",
            ["bash"] = "bash",
            ["powershell"] = "powershell",
        };

        public DocFxMarkdownProcessor(string basePath)
        {
            _basePath = basePath;
        }

        /// <summary>
        /// Process markdown content, resolving all DocFX directives.
        /// <paramref name="markdownFilePath"/> is the path of the markdown file
        /// (relative to basePath) used to resolve relative references.
        /// </summary>
        public async Task<string> ProcessAsync(string content, string markdownFilePath)
        {
            var mdDir = Path.GetDirectoryName(Path.Combine(_basePath, markdownFilePath)) ?? _basePath;
            return await ProcessContentAsync(content, mdDir, 0);
        }

        private async Task<string> ProcessContentAsync(string content, string contextDir, int depth)
        {
            if (depth > MaxIncludeDepth)
                return content;

            // Process [!INCLUDE] directives first (they may contain code includes)
            content = await ResolveIncludesAsync(content, contextDir, depth);

            // Process [!code-*] directives
            content = await ResolveCodeIncludesAsync(content, contextDir);

            return content;
        }

        private async Task<string> ResolveIncludesAsync(string content, string contextDir, int depth)
        {
            var matches = FileIncludeRegex.Matches(content);
            if (matches.Count == 0)
                return content;

            var sb = new StringBuilder(content);
            // Process in reverse order to preserve match positions
            for (int i = matches.Count - 1; i >= 0; i--)
            {
                var match = matches[i];
                var relativePath = match.Groups[1].Value;
                var fullPath = ResolvePath(contextDir, relativePath);

                string replacement;
                if (File.Exists(fullPath))
                {
                    var included = await File.ReadAllTextAsync(fullPath);
                    var includedDir = Path.GetDirectoryName(fullPath) ?? contextDir;
                    replacement = await ProcessContentAsync(included, includedDir, depth + 1);
                }
                else
                {
                    replacement = $"> *Include not found: `{relativePath}`*";
                }

                sb.Remove(match.Index, match.Length);
                sb.Insert(match.Index, replacement);
            }

            return sb.ToString();
        }

        private async Task<string> ResolveCodeIncludesAsync(string content, string contextDir)
        {
            var matches = CodeIncludeRegex.Matches(content);
            if (matches.Count == 0)
                return content;

            var sb = new StringBuilder(content);
            for (int i = matches.Count - 1; i >= 0; i--)
            {
                var match = matches[i];
                var lang = match.Groups[1].Value;
                var pathWithQuery = match.Groups[2].Value;

                var replacement = await ResolveCodeSnippetAsync(lang, pathWithQuery, contextDir);

                sb.Remove(match.Index, match.Length);
                sb.Insert(match.Index, replacement);
            }

            return sb.ToString();
        }

        private async Task<string> ResolveCodeSnippetAsync(string docfxLang, string pathWithQuery, string contextDir)
        {
            // Parse path and query string
            var queryIdx = pathWithQuery.IndexOf('?');
            var relativePath = queryIdx >= 0 ? pathWithQuery[..queryIdx] : pathWithQuery;
            var query = queryIdx >= 0 ? pathWithQuery[(queryIdx + 1)..] : string.Empty;

            var fullPath = ResolvePath(contextDir, relativePath);

            if (!File.Exists(fullPath))
                return $"```\n// File not found: {relativePath}\n```";

            var allLines = await File.ReadAllLinesAsync(fullPath);
            string[] selectedLines;

            if (TryParseQuery(query, out var tagName, out var ranges))
            {
                if (tagName != null)
                {
                    selectedLines = ExtractTaggedRegion(allLines, tagName);
                }
                else if (ranges != null)
                {
                    selectedLines = ExtractRanges(allLines, ranges);
                }
                else
                {
                    selectedLines = allLines;
                }
            }
            else
            {
                selectedLines = allLines;
            }

            var fenceLang = LangMap.TryGetValue(docfxLang, out var mapped) ? mapped : docfxLang;
            var code = TrimCommonIndent(selectedLines);
            return $"```{fenceLang}\n{code}\n```";
        }

        private static bool TryParseQuery(string query, out string? tagName, out List<(int start, int end)>? ranges)
        {
            tagName = null;
            ranges = null;

            if (string.IsNullOrEmpty(query))
                return false;

            var parts = query.Split('&');
            foreach (var part in parts)
            {
                var kv = part.Split('=', 2);
                if (kv.Length != 2) continue;

                var key = kv[0].Trim();
                var value = kv[1].Trim();

                if (key.Equals("name", StringComparison.OrdinalIgnoreCase))
                {
                    tagName = value;
                    return true;
                }

                if (key.Equals("range", StringComparison.OrdinalIgnoreCase))
                {
                    ranges = ParseRanges(value);
                    return true;
                }
            }

            return false;
        }

        private static List<(int start, int end)> ParseRanges(string rangeSpec)
        {
            var result = new List<(int start, int end)>();
            foreach (var segment in rangeSpec.Split(','))
            {
                var trimmed = segment.Trim();
                if (trimmed.Contains('-'))
                {
                    var parts = trimmed.Split('-', 2);
                    if (int.TryParse(parts[0].Trim(), out var s) && int.TryParse(parts[1].Trim(), out var e))
                        result.Add((s, e));
                }
                else
                {
                    if (int.TryParse(trimmed, out var line))
                        result.Add((line, line));
                }
            }
            return result;
        }

        private static string[] ExtractRanges(string[] allLines, List<(int start, int end)> ranges)
        {
            var result = new List<string>();
            foreach (var (start, end) in ranges)
            {
                var s = Math.Max(0, start - 1); // Convert to 0-based
                var e = Math.Min(allLines.Length, end);
                for (int i = s; i < e; i++)
                    result.Add(allLines[i]);
            }
            return result.ToArray();
        }

        private static string[] ExtractTaggedRegion(string[] lines, string tagName)
        {
            int start = -1;
            int end = -1;

            for (int i = 0; i < lines.Length; i++)
            {
                var t = lines[i].Trim();

                if (start < 0)
                {
                    if (IsOpenTag(t, tagName))
                        start = i + 1;
                }
                else
                {
                    if (IsCloseTag(t, tagName))
                    {
                        end = i;
                        break;
                    }
                }
            }

            if (start < 0 || end < 0 || end <= start)
                return [$"// Region '{tagName}' not found"];

            return lines[start..end];
        }

        private static bool IsOpenTag(string trimmedLine, string tagName)
        {
            // ST: //<TagName>
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
            // YAML: #<TagName>
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
            if (trimmedLine.StartsWith("//", StringComparison.Ordinal))
            {
                var inner = trimmedLine[2..].Trim().TrimStart('<').TrimStart('/').Trim().TrimEnd('>').Trim();
                return inner.Equals(tagName, StringComparison.OrdinalIgnoreCase);
            }
            if (trimmedLine.StartsWith("<!--", StringComparison.Ordinal) &&
                trimmedLine.EndsWith("-->", StringComparison.Ordinal))
            {
                var inner = trimmedLine[4..^3].Trim().TrimStart('<').TrimStart('/').Trim().TrimEnd('>').Trim();
                return inner.Equals(tagName, StringComparison.OrdinalIgnoreCase);
            }
            if (trimmedLine.StartsWith("#", StringComparison.Ordinal) &&
                !trimmedLine.StartsWith("##", StringComparison.Ordinal))
            {
                var inner = trimmedLine[1..].Trim().TrimStart('<').TrimStart('/').Trim().TrimEnd('>').Trim();
                return inner.Equals(tagName, StringComparison.OrdinalIgnoreCase);
            }
            return false;
        }

        private static string ResolvePath(string contextDir, string relativePath)
        {
            // Normalize forward slashes
            relativePath = relativePath.Replace('/', Path.DirectorySeparatorChar);
            var combined = Path.Combine(contextDir, relativePath);
            return Path.GetFullPath(combined);
        }

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
    }
}
