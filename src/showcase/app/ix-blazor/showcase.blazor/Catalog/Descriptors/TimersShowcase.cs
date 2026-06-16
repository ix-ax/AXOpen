using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Timers (generic) --------------------------------------------------------------------

    // The Timers showcase keeps its declarations and usage in one TimersShowcase.st context with
    // tagged regions (TimerDeclarations / TimerUsage) rather than the one-file-per-component
    // ComponentDeclaration / Initialization convention the shared Declaration()/Initialization()
    // helpers assume. Snippet refs are therefore built inline so the code-reference tab loads the
    // same regions the original page did.
    private const string TimersContextPath = "src/showcase/app/src/timers/TimersShowcase.st";

    public static ShowcasePageDescriptor TimersShowcase { get; } = new()
    {
        Route = "/timers/Documentation/TimersShowcase",
        Title = "Timers Showcase",
        LibraryNamespace = "AXOpen.Timers",
        Category = "Timers",
        Icon = "clock",
        BrandIcon = "clock",
        Description = "OnDelayTimer, OffDelayTimer, PulseTimer, and AxoBlinker for time-based control logic. " +
                      "Use this page as a practical reference for integrating timer functionality in SIMATIC AX applications.",
        Tags = ["timers", "ondelaytimer", "offdelaytimer", "pulsetimer", "axoblinker", "timing", "foundation"],
        NavGroup = "Foundation",
        NavOrder = 85,
        ContextSourcePath = TimersContextPath,
        SourceFilePaths =
        [
            TimersContextPath,
        ],
        LibrarySources =
        [
            new("src/timers/ctrl/apax.yml"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "Timers",
                MaturityKey = "Timers",
                Declaration = new(TimersContextPath, "TimerDeclarations", "language-iecst",
                    Heading: "Timer declarations (ST)", RegionNote: "<TimerDeclarations> region"),
                Initialization = new(TimersContextPath, "TimerUsage", "language-iecst",
                    Heading: "Timer usage (ST)", RegionNote: "<TimerUsage> region"),
                Twin = c => c.timers_documentation,
                Sequencer = c => c.timers_documentation._automat,
                Steps = c => c.timers_documentation._automat.Steps,
            },
        ],
    };
}
