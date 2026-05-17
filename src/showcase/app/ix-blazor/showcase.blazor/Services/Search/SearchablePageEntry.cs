namespace showcase.Services.Search;

public class SearchablePageEntry
{
    public required string Route { get; init; }
    public required string PageTitle { get; init; }
    public required string LibraryNamespace { get; init; }
    public required string Category { get; init; }
    public string? Vendor { get; init; }
    public required string Description { get; init; }
    public required string Icon { get; init; }
    public string[] Tags { get; init; } = [];
    public string[] SourceFilePaths { get; init; } = [];
}
