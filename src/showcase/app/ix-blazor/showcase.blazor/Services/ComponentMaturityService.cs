using System;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;

namespace showcase.Services
{
    public class ComponentMaturityService
    {
        private readonly Dictionary<string, MaturityInfo> _maturityMap = new(StringComparer.OrdinalIgnoreCase);

        public ComponentMaturityService(string basePath = null)
        {
            var root = basePath ?? GetProjectRoot();
            var mdPath = Path.Combine(root, "COMPONENTS_MATURITY.md");
            if (File.Exists(mdPath))
            {
                Parse(File.ReadAllText(mdPath));
            }
        }

        public MaturityInfo GetMaturity(string componentName)
        {
            if (componentName != null && _maturityMap.TryGetValue(componentName, out var info))
                return info;
            return new MaturityInfo("red", "red", "red");
        }

        private void Parse(string markdown)
        {
            // Match table rows: | [Name](path) | Domain | Impl | Tested | BattleTested | ...
            var rowPattern = new Regex(
                @"\|\s*\[([^\]]+)\]\([^)]*\)\s*\|[^|]*\|\s*([^|]*)\|\s*([^|]*)\|\s*([^|]*)\|",
                RegexOptions.Compiled);

            foreach (Match m in rowPattern.Matches(markdown))
            {
                var name = m.Groups[1].Value.Trim();
                var implemented = EmojiToColor(m.Groups[2].Value.Trim());
                var tested = EmojiToColor(m.Groups[3].Value.Trim());
                var battleTested = EmojiToColor(m.Groups[4].Value.Trim());

                _maturityMap[name] = new MaturityInfo(implemented, tested, battleTested);
            }
        }

        private static string EmojiToColor(string emoji) => emoji switch
        {
            "🟢" => "green",
            "🟡" => "yellow",
            "🔴" => "red",
            _ => "red"
        };

        private static string GetProjectRoot()
        {
            var currentDir = AppContext.BaseDirectory;
            var root = new DirectoryInfo(currentDir);
            int levels = 0;
            while (root.Parent != null && levels < 15)
            {
                if (File.Exists(Path.Combine(root.FullName, "Directory.Build.props")) ||
                    File.Exists(Path.Combine(root.FullName, "COMPONENTS_MATURITY.md")))
                {
                    return root.FullName;
                }
                root = root.Parent;
                levels++;
            }

            // Fallback
            root = new DirectoryInfo(currentDir);
            for (int i = 0; i < 8; i++)
            {
                if (root.Parent != null)
                    root = root.Parent;
            }
            return root.FullName;
        }
    }

    public record MaturityInfo(string Implemented, string Tested, string BattleTested);
}
