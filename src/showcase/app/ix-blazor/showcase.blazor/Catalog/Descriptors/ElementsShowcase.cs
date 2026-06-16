using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Elements ----------------------------------------------------------------------------

    // The Elements showcase keeps all five components in one Elements.st context with per-component
    // tagged regions (AxoDiDeclaration / AxoDiInitialization / AxoDiUsage, ...) rather than the
    // one-file-per-component ComponentDeclaration / Initialization convention the shared
    // Declaration()/Initialization() helpers assume. Snippet refs are therefore built inline so the
    // code-reference tab loads the same regions the original page did.
    private const string ElementsContextPath = "src/showcase/app/src/components.elements/Documentation/Elements.st";

    private static SnippetRef ElementsDecl(string region) =>
        new(ElementsContextPath, region, "language-iecst",
            Heading: "Declaration (ST)", RegionNote: $"<{region}> region");

    private static SnippetRef ElementsInit(string region) =>
        new(ElementsContextPath, region, "language-iecst",
            Heading: "Initialization & Usage (ST)", RegionNote: $"<{region}> region");

    private static SnippetRef ElementsUsage(string region) =>
        new(ElementsContextPath, region, "language-iecst",
            Heading: "Usage (ST)", RegionNote: $"<{region}> region");

    public static ShowcasePageDescriptor ElementsShowcase { get; } = new()
    {
        Route = "/components-elements/Documentation/ElementsShowcase",
        Title = "Elements",
        LibraryNamespace = "AXOpen.Components.Elements",
        Category = "Elements",
        Icon = "squares-2x2",
        BrandIcon = "squares-2x2",
        Description = "Basic I/O building blocks — digital inputs/outputs, analog inputs/outputs, signal tower, " +
                      "and rotary indexing table. A practical reference for integrating these components in SIMATIC AX applications.",
        Tags = ["elements", "io", "digital input", "digital output", "analog input", "analog output", "rotary indexing table", "axodi", "axodo", "axoai", "axoao"],
        NavGroup = "Components",
        NavOrder = 11,
        ContextSourcePath = ElementsContextPath,
        SourceFilePaths =
        [
            ElementsContextPath,
        ],
        LibraryDocs =
        [
            new("src/components.elements/docs/README.md", "README — Overview", Mono: false),
            new("src/components.elements/docs/AXODI.md", "AxoDi — Digital Input", Mono: false),
            new("src/components.elements/docs/AXODO.md", "AxoDo — Digital Output", Mono: false),
            new("src/components.elements/docs/AXOAI.md", "AxoAi — Analog Input", Mono: false),
            new("src/components.elements/docs/AXOAO.md", "AxoAo — Analog Output", Mono: false),
            new("src/components.elements/docs/HOWTO.md", "How-To Guide", Mono: false),
            new("src/components.elements/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoDi",
                MaturityKey = "Elements",
                Declaration = ElementsDecl("AxoDiDeclaration"),
                Initialization = ElementsInit("AxoDiInitialization"),
                ExtraSnippets = [ElementsUsage("AxoDiUsage")],
                Twin = c => c.elements_documentation.Cu._testDi,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoDo",
                MaturityKey = "Elements",
                Declaration = ElementsDecl("AxoDoDeclaration"),
                Initialization = ElementsInit("AxoDoInitialization"),
                ExtraSnippets = [ElementsUsage("AxoDoUsage")],
                Twin = c => c.elements_documentation.Cu._testDo,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoAi",
                MaturityKey = "Elements",
                Declaration = ElementsDecl("AxoAiDeclaration"),
                Initialization = ElementsInit("AxoAiInitialization"),
                Twin = c => c.elements_documentation.Cu._testAi,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoAo",
                MaturityKey = "Elements",
                Declaration = ElementsDecl("AxoAoDeclaration"),
                Initialization = ElementsInit("AxoAoInitialization"),
                Twin = c => c.elements_documentation.Cu._testAo,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoRotaryIndexingTable",
                MaturityKey = "Elements",
                Declaration = ElementsDecl("AxoCarouselDeclaration"),
                Initialization = ElementsInit("AxoCarouselInitialization"),
                Twin = c => c.elements_documentation.Cu._testCarousel,
            },
        ],
    };
}
