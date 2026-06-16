using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Pneumatics --------------------------------------------------------------------------

    private const string PneumaticsDocDir = "src/showcase/app/src/components.pneumatics/Documentation";

    public static ShowcasePageDescriptor PneumaticsShowcase { get; } = new()
    {
        Route = "/components-pneumatics/Documentation/PneumaticsShowcase",
        Title = "Pneumatics Showcase",
        LibraryNamespace = "AXOpen.Components.Pneumatics",
        Category = "Pneumatics",
        Icon = "arrows-pointing-out",
        BrandIcon = "arrows-pointing-out",
        Description = "AxoCylinder component for controlling pneumatic cylinders with move-in / move-out / stop actions, " +
                      "sensor feedback, and configurable suspend/abort conditions. " +
                      "Use this page as a practical reference for integrating pneumatic components in SIMATIC AX applications.",
        Tags = ["pneumatics", "cylinder", "axocylinder", "valve", "aventics", "profinet"],
        NavGroup = "Components",
        NavOrder = 12,
        ContextSourcePath = $"{PneumaticsDocDir}/AxoCylinder.st",
        SourceFilePaths =
        [
            $"{PneumaticsDocDir}/PneumaticsShowcase.st",
            $"{PneumaticsDocDir}/AxoCylinder.st",
        ],
        LibraryDocs =
        [
            new("src/components.pneumatics/docs/README.md", "README — Overview", Mono: false),
            new("src/components.pneumatics/docs/AxoCylinder.md", "AxoCylinder — Guide", Mono: false),
            new("src/components.pneumatics/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.pneumatics/ctrl/src/AxoCylinder.st"),
            new("src/components.pneumatics/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new("src/showcase/app/hwc/library_templates/AventicsPneumatics/AventicsPneumaticsAES.hwl.yml"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoCylinder",
                MaturityKey = "Pneumatics",
                Declaration = Declaration($"{PneumaticsDocDir}/AxoCylinder.st"),
                Initialization = Initialization($"{PneumaticsDocDir}/AxoCylinder.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Aventics Pneumatics",
                        InstancePath = PlcLine, DeviceRegion = "AventicsPneumaticsDevice",
                        TemplatePath = "src/showcase/app/hwc/library_templates/AventicsPneumatics/AventicsPneumaticsAES.hwl.yml",
                        TemplateRegion = "AventicsPneumaticsTemplate",
                        IoSystemPath = PlcLine, IoSystemRegion = "AventicsPneumaticsIoSystem",
                    },
                ],
                Twin = c => c.pneumatics_documentation.axoCylinder.AxoCylinder_,
            },
        ],
    };
}
