using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Inspectors (generic) ----------------------------------------------------------------

    // Zero-component utility page: a single InspectorsShowcase context (digital / analogue / data
    // inspectors) rendered through one RenderableContentControl via RootBind. No per-component tabs.
    private const string InspectorsContextPath = "src/showcase/app/src/inspectors/InspectorsShowcase.st";

    public static ShowcasePageDescriptor InspectorsShowcase { get; } = new()
    {
        Route = "/inspectors/Documentation/InspectorsShowcase",
        Title = "Inspectors Showcase",
        LibraryNamespace = "AXOpen.Inspectors",
        Category = "Inspectors",
        Vendor = null,
        Icon = "magnifying-glass",
        BrandIcon = "magnifying-glass",
        Description = "Digital, analogue, and data inspectors with configurable pass/fail times, comprehensive result aggregation, " +
                      "and failure-handling strategies (carry on, retry, dialog). " +
                      "Use this page as a practical reference for integrating inspection logic in SIMATIC AX applications.",
        Tags = ["inspectors", "inspection", "digital inspector", "analogue inspector", "data inspector", "axoinspector", "pass/fail", "comprehensive result", "quality"],
        NavGroup = "Foundation",
        NavOrder = 81,
        ContextSourcePath = InspectorsContextPath,
        SourceFilePaths =
        [
            InspectorsContextPath,
        ],
        LibraryDocs =
        [
            new("src/inspectors/docs/README.md", "README — Overview", Mono: false),
            new("src/inspectors/docs/AXODIGITALINSPECTOR.md", "AxoDigitalInspector", Mono: false),
            new("src/inspectors/docs/AXOANALOGUEINSPECTOR.md", "AxoAnalogueInspector", Mono: false),
            new("src/inspectors/docs/AXODATAINSPECTOR.md", "AxoDataInspector", Mono: false),
        ],
        RootBind = c => c.inspectors_documentation,
    };
}
