using AXOpen.Core;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;

namespace showcase.Models.Showcase;

/// <summary>
/// One live component rendered as an outer tab on a showcase page: its declaration/initialization
/// snippets, hardware references, custom tabs, and the three compile-safe delegates that resolve
/// its live twin objects from the single <see cref="ShowcaseContext"/> — no reflection.
/// </summary>
public sealed class ComponentShowcase
{
    public required string DisplayName { get; init; }

    /// <summary>Exact component name in <c>COMPONENTS_MATURITY.md</c>, resolved via the maturity service.</summary>
    public required string MaturityKey { get; init; }

    public SnippetRef? Declaration { get; init; }
    public SnippetRef? Initialization { get; init; }

    /// <summary>Additional code-reference snippets (e.g. a commissioning region).</summary>
    public List<SnippetRef> ExtraSnippets { get; init; } = new();

    public List<HardwareRef> Hardware { get; init; } = new();
    public List<CustomTab> CustomTabs { get; init; } = new();

    /// <summary>Optional banner rendered above the component's tab set.</summary>
    public RenderFragment? Intro { get; init; }

    /// <summary>Source file scanned for sequencer step blocks. Defaults to the declaration path.</summary>
    public string? StepSourcePath { get; init; }

    /// <summary>Resolves the live twin for <c>RenderableContentControl</c>.</summary>
    public required Func<ShowcaseContext, ITwinObject> Twin { get; init; }

    /// <summary>Resolves the sequencer for command views and polling. Null if the component has none.</summary>
    public Func<ShowcaseContext, AxoSequencer>? Sequencer { get; init; }

    /// <summary>Resolves the step collection for the step-card map and polling.</summary>
    public Func<ShowcaseContext, IEnumerable<AxoStep>>? Steps { get; init; }

    /// <summary>The .st file the layout scans for step logic blocks (declaration path by default).</summary>
    public string? ResolvedStepSource => StepSourcePath ?? Declaration?.Path;

    public bool HasSequence => Sequencer is not null && Steps is not null;
}
