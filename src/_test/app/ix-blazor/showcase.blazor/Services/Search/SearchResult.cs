namespace showcase.Services.Search;

public class SearchResult
{
    public required SearchablePageEntry Entry { get; init; }
    public double Score { get; init; }
    public string MatchedField { get; init; } = string.Empty;
    public string HighlightSnippet { get; init; } = string.Empty;
    public bool IsContentMatch { get; init; }
    public string? MatchedFilePath { get; init; }
    public string? MatchedFileName { get; init; }
    public int MatchedLineNumber { get; init; }
    public string? MatchedLanguage { get; init; }
}
