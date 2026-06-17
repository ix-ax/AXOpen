using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace showcase.Models.Showcase;

/// <summary>
/// The single descriptor for one showcase page. It is the catalog's unit of truth and drives page
/// rendering, navigation, the index matrix, and search. Pages with <see cref="UsesLayout"/> =
/// <c>false</c> keep their own markup but still appear in navigation / index / search.
/// </summary>
public sealed class ShowcasePageDescriptor
{
    public required string Route { get; init; }
    public required string Title { get; init; }
    public required string LibraryNamespace { get; init; }
    public required string Category { get; init; }
    public string? Vendor { get; init; }
    public string? VendorUrl { get; init; }
    public string Icon { get; init; } = "document-text";
    public required string Description { get; init; }
    public string[] Tags { get; init; } = Array.Empty<string>();
    public string[] SourceFilePaths { get; init; } = Array.Empty<string>();

    // Navigation
    public required string NavGroup { get; init; }
    public int NavOrder { get; init; }
    public bool ShowInNav { get; init; } = true;

    // Sidebar resources
    public string? ContextSourcePath { get; init; }
    public List<SourceRef> LibraryDocs { get; init; } = new();
    public List<SourceRef> LibrarySources { get; init; } = new();
    public List<SourceRef> HardwareAssets { get; init; } = new();

    // Body
    public List<ComponentShowcase> Components { get; init; } = new();

    /// <summary>For zero-component utility pages: the context node to render and poll directly.</summary>
    public Func<ShowcaseContext, ITwinObject>? RootBind { get; init; }

    /// <summary>Optional banner rendered above the component tab set.</summary>
    public RenderFragment? Intro { get; init; }

    /// <summary>False for bespoke pages that keep their own markup (catalog entry for nav/search only).</summary>
    public bool UsesLayout { get; init; } = true;

    // Visual presentation (pure data; falls back to the Momentum --color-primary default when null)
    public string? AccentColor { get; init; }
    public string? BrandIcon { get; init; }

    /// <summary>Source references shown in the sidebar: the page context plus each component declaration.</summary>
    public IEnumerable<SourceRef> SourceReferences()
    {
        if (!string.IsNullOrWhiteSpace(ContextSourcePath))
            yield return new SourceRef(ContextSourcePath!);
        foreach (var c in Components)
            if (c.Declaration is not null)
                yield return new SourceRef(c.Declaration.Path);
    }
}
