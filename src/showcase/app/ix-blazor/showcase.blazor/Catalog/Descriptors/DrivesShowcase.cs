using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Drives (generic) --------------------------------------------------------------------

    private const string DrivesDocDir = "src/showcase/app/src/components.drives/Documentation";

    public static ShowcasePageDescriptor DrivesShowcase { get; } = new()
    {
        Route = "/components-drives/Documentation/DrivesShowcase",
        Title = "Drives Showcase",
        LibraryNamespace = "AXOpen.Components.Drives",
        Category = "Drives",
        Icon = "bolt",
        BrandIcon = "bolt",
        Description = "Abstract drive component providing a vendor-neutral foundation for motion control in SIMATIC AX. " +
                      "Use this page as a practical reference for integrating the generic AxoDrive base in your applications.",
        Tags = ["drives", "motion", "axodrive", "generic", "servo"],
        NavGroup = "Components",
        NavOrder = 10,
        ContextSourcePath = $"{DrivesDocDir}/Drives.st",
        SourceFilePaths =
        [
            $"{DrivesDocDir}/Drives.st",
            $"{DrivesDocDir}/AxoDriveExample_Showcase.st",
        ],
        LibraryDocs =
        [
            new("src/components.drives/docs/README.md", "README — Overview", Mono: false),
            new("src/components.drives/docs/AxoDriveExample_Showcase.md", "AxoDrive — Component guide", Mono: false),
            new("src/components.drives/docs/AxoDriveExample_Showcase2.md", "Component 2 — Component guide", Mono: false),
            new("src/components.drives/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.drives/ctrl/src/AxoDrives/AxoDrive.st"),
            new("src/components.drives/ctrl/apax.yml"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoDrive",
                MaturityKey = "Generic Drives",
                Declaration = Declaration($"{DrivesDocDir}/AxoDriveExample_Showcase.st"),
                Initialization = Initialization($"{DrivesDocDir}/AxoDriveExample_Showcase.st"),
                Twin = c => c.drives_documentation.axoDriveExample.AxoDrive_,
                Sequencer = c => c.drives_documentation.axoDriveExample.Sequencer,
                Steps = c => c.drives_documentation.axoDriveExample.Steps,
            },
        ],
    };
}
