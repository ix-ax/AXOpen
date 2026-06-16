using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Probers -----------------------------------------------------------------------------

    private const string ProbersDocDir = "src/showcase/app/src/probers";

    public static ShowcasePageDescriptor ProbersShowcase { get; } = new()
    {
        Route = "/probers/Documentation/ProbersShowcase",
        Title = "Probers Showcase",
        LibraryNamespace = "AXOpen.Probers",
        Category = "Probers",
        Vendor = null,
        Icon = "beaker",
        BrandIcon = "beaker",
        Description = "Test probing utilities for cyclic and conditional test execution. " +
                      "AxoProberWithCounterBase runs a test for N cycles; AxoProberWithCompletedCondition runs until a condition is met.",
        Tags = ["probers", "test", "probe", "counter", "condition", "utilities"],
        NavGroup = "Foundation",
        NavOrder = 83,
        ContextSourcePath = $"{ProbersDocDir}/ProbersShowcase.st",
        SourceFilePaths =
        [
            $"{ProbersDocDir}/ProbersShowcase.st",
        ],
        LibraryDocs =
        [
            new("src/probers/docs/README.md", "README — Overview", Mono: false),
            new("src/probers/docs/AxoProber.md", "AxoProber — Guide", Mono: false),
        ],
        LibrarySources =
        [
            new("src/probers/ctrl/src/Probers/AxoProber.st"),
            new("src/probers/ctrl/apax.yml"),
        ],
        // Zero-component utility library: the page renders the documentation context directly
        // (no per-component tabs). The layout drives rendering and polling from RootBind.
        RootBind = c => c.probers_documentation,
    };
}
