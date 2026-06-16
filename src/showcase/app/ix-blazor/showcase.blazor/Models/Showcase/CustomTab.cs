using Microsoft.AspNetCore.Components;

namespace showcase.Models.Showcase;

/// <summary>
/// An extra tab on a component beyond the standard set (automatic rendering / code reference /
/// hardware / example sequence). Either renders a loaded code <see cref="Snippet"/> with an
/// optional <see cref="Note"/>, or fully bespoke <see cref="Content"/>.
/// </summary>
public sealed class CustomTab
{
    public required string Title { get; init; }

    /// <summary>A snippet the layout loads and renders through the standard ladder.</summary>
    public SnippetRef? Snippet { get; init; }

    /// <summary>Optional note rendered beneath the snippet.</summary>
    public RenderFragment? Note { get; init; }

    /// <summary>Fully bespoke content (used when the tab is not snippet-based, e.g. Festo).</summary>
    public RenderFragment? Content { get; init; }
}
