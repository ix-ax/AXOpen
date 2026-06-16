namespace showcase.Models.Showcase;

/// <summary>
/// A reference to a tagged source region, loaded at runtime via
/// <c>CodeSnippetProvider.GetTaggedRegionAsync(Path, Region)</c>. Pure data — the layout does the
/// loading, so descriptors stay free of per-component snippet plumbing.
/// </summary>
public sealed record SnippetRef(
    string Path,
    string Region,
    string Language = "language-iecst",
    string? Heading = null,
    string? RegionNote = null,
    string? MaxHeight = null)
{
    /// <summary>Stable cache key for the loaded snippet.</summary>
    public string Key => $"{Path}::{Region}";
}

/// <summary>A repo-relative source file reference rendered as a clickable link in the sidebar.</summary>
public sealed record SourceRef(string Path, string? Label = null, bool Mono = true);
