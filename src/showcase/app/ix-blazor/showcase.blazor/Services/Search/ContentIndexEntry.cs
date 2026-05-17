namespace showcase.Services.Search;

public class ContentIndexEntry
{
    public required SearchablePageEntry Page { get; init; }
    public required string FilePath { get; init; }
    public required string Content { get; init; }
    public required string[] Lines { get; init; }
    public required string Language { get; init; }
    public required string FileName { get; init; }
}
