namespace showcase.Services.Search;

public class ShowcaseSearchService
{
    private readonly List<SearchablePageEntry> _entries;
    private readonly ContentIndexService _contentIndex;

    public ShowcaseSearchService(ContentIndexService contentIndex)
    {
        _entries = ShowcasePageRegistry.GetAllPages();
        _contentIndex = contentIndex;
    }

    public List<SearchResult> Search(string query, int maxResults = 10)
    {
        if (string.IsNullOrWhiteSpace(query))
            return [];

        var tokens = query.Split(' ', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
        if (tokens.Length == 0)
            return [];

        var results = new List<SearchResult>();

        // Pass 1: Metadata search
        foreach (var entry in _entries)
        {
            var (score, matchedField) = ScoreEntry(entry, tokens, query);
            if (score > 0)
            {
                results.Add(new SearchResult
                {
                    Entry = entry,
                    Score = score,
                    MatchedField = matchedField,
                    HighlightSnippet = BuildSnippet(entry, matchedField)
                });
            }
        }

        // Pass 2: Content search
        if (_contentIndex.IsReady)
        {
            var tokensLower = tokens.Select(t => t.ToLowerInvariant()).ToArray();
            var seenPages = new HashSet<string>(results.Select(r => r.Entry.Route));

            foreach (var content in _contentIndex.Entries)
            {
                // Skip if this page already matched metadata
                if (seenPages.Contains(content.Page.Route))
                    continue;

                // AND semantics: all tokens must appear in the content
                if (!tokensLower.All(t => content.Content.Contains(t, StringComparison.Ordinal)))
                    continue;

                // Find first token match for snippet extraction
                var idx = content.Content.IndexOf(tokensLower[0], StringComparison.Ordinal);
                var (lineNumber, snippetText) = ExtractSnippet(content, idx);

                results.Add(new SearchResult
                {
                    Entry = content.Page,
                    Score = 1.0,
                    MatchedField = "Content",
                    HighlightSnippet = snippetText,
                    IsContentMatch = true,
                    MatchedFilePath = content.FilePath,
                    MatchedFileName = content.FileName,
                    MatchedLineNumber = lineNumber,
                    MatchedLanguage = content.Language,
                });

                seenPages.Add(content.Page.Route);
            }
        }

        return results
            .OrderByDescending(r => r.Score)
            .Take(maxResults)
            .ToList();
    }

    private static (double Score, string MatchedField) ScoreEntry(
        SearchablePageEntry entry, string[] tokens, string fullQuery)
    {
        double totalScore = 0;
        string bestField = string.Empty;
        double bestFieldScore = 0;

        foreach (var token in tokens)
        {
            double tokenBestScore = 0;

            tokenBestScore = Math.Max(tokenBestScore, ScoreField(entry.PageTitle, token, 10));
            tokenBestScore = Math.Max(tokenBestScore, ScoreField(entry.LibraryNamespace, token, 8));
            tokenBestScore = Math.Max(tokenBestScore, ScoreField(entry.Category, token, 6));
            tokenBestScore = Math.Max(tokenBestScore, ScoreField(entry.Vendor, token, 6));
            tokenBestScore = Math.Max(tokenBestScore, ScoreField(entry.Description, token, 2));
            tokenBestScore = Math.Max(tokenBestScore, ScoreFieldArray(entry.Tags, token, 4));

            if (tokenBestScore <= 0)
                return (0, string.Empty);

            totalScore += tokenBestScore;
        }

        if (entry.PageTitle.Contains(fullQuery, StringComparison.OrdinalIgnoreCase))
            totalScore += 20;

        foreach (var token in tokens)
        {
            CheckBestField(entry.PageTitle, token, 10, "Title", ref bestField, ref bestFieldScore);
            CheckBestField(entry.LibraryNamespace, token, 8, "Namespace", ref bestField, ref bestFieldScore);
            CheckBestField(entry.Category, token, 6, "Category", ref bestField, ref bestFieldScore);
            CheckBestField(entry.Vendor, token, 6, "Vendor", ref bestField, ref bestFieldScore);
            CheckBestField(entry.Description, token, 2, "Description", ref bestField, ref bestFieldScore);
        }

        return (totalScore, bestField);
    }

    private static double ScoreField(string? fieldValue, string token, double weight)
    {
        if (string.IsNullOrEmpty(fieldValue))
            return 0;
        return fieldValue.Contains(token, StringComparison.OrdinalIgnoreCase) ? weight : 0;
    }

    private static double ScoreFieldArray(string[] values, string token, double weight)
    {
        foreach (var value in values)
        {
            if (value.Contains(token, StringComparison.OrdinalIgnoreCase))
                return weight;
        }
        return 0;
    }

    private static void CheckBestField(string? fieldValue, string token, double weight,
        string fieldName, ref string bestField, ref double bestScore)
    {
        if (string.IsNullOrEmpty(fieldValue))
            return;
        if (fieldValue.Contains(token, StringComparison.OrdinalIgnoreCase) && weight > bestScore)
        {
            bestScore = weight;
            bestField = fieldName;
        }
    }

    private static string BuildSnippet(SearchablePageEntry entry, string matchedField)
    {
        return matchedField switch
        {
            "Namespace" => entry.LibraryNamespace,
            "Vendor" => entry.Vendor ?? entry.Description,
            _ => entry.Description
        };
    }

    private static (int LineNumber, string Snippet) ExtractSnippet(ContentIndexEntry content, int charIndex)
    {
        // Map character index to line number
        int charCount = 0;
        int lineNumber = 0;
        for (int i = 0; i < content.Lines.Length; i++)
        {
            if (charCount + content.Lines[i].Length >= charIndex)
            {
                lineNumber = i;
                break;
            }
            charCount += content.Lines[i].Length + 1; // +1 for newline
        }

        // Extract ±1 line of context
        var start = Math.Max(0, lineNumber - 1);
        var end = Math.Min(content.Lines.Length - 1, lineNumber + 1);

        var snippetLines = content.Lines[start..(end + 1)];
        var snippet = string.Join(" ", snippetLines.Select(l => l.Trim()).Where(l => l.Length > 0));

        if (snippet.Length > 150)
            snippet = snippet[..147] + "...";

        return (lineNumber + 1, snippet);
    }
}
