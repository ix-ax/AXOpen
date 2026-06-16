using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Components Abstractions -------------------------------------------------------------

    private const string ComponentsAbstractionsDocDir = "src/showcase/app/src/components.abstractions";

    public static ShowcasePageDescriptor ComponentsAbstractionsShowcase { get; } = new()
    {
        Route = "/components-abstractions/Documentation/ComponentsAbstractionsShowcase",
        Title = "Components Abstractions Showcase",
        LibraryNamespace = "AXOpen.Components.Abstractions",
        Category = "Abstractions",
        Icon = "document-text",
        BrandIcon = "document-text",
        Description = "Standard interface contracts for all AXOpen components: IAxoDrive, IAxoRobotics, " +
                      "IAxoCodeReader, IAxoVisionSensor, IAxo_Power, and shared data types (coordinates, " +
                      "movement params, status). Vendor implementations must conform to these interfaces.",
        Tags = ["abstractions", "interfaces", "contracts", "iaxodrive", "iaxorobotics", "iaxocodereader", "iaxovisionsensor", "iaxo_power"],
        NavGroup = "Components",
        NavOrder = 13,
        ContextSourcePath = $"{ComponentsAbstractionsDocDir}/ComponentsAbstractionsShowcase.st",
        SourceFilePaths =
        [
            $"{ComponentsAbstractionsDocDir}/ComponentsAbstractionsShowcase.st",
        ],
        LibraryDocs =
        [
            new("src/components.abstractions/docs/README.md", "README — Overview", Mono: false),
            new("src/components.abstractions/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.abstractions/ctrl/apax.yml"),
        ],
        RootBind = c => c.components_abstractions_documentation,
    };
}
