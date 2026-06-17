using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Zebra Vision -------------------------------------------------------------------------

    private const string ZebraDocDir = "src/showcase/app/src/components.zebra.vision/Documentation";
    private const string ZebraTemplate = "src/showcase/app/hwc/library_templates/zebra_ea3600/zebra_ea3600_88in6out.hwl.yml";

    private static HardwareRef ZebraHardware => new()
    {
        Label = "Zebra EA3600",
        InstancePath = PlcLine, DeviceRegion = "ZebraEa3600Device",
        TemplatePath = ZebraTemplate, TemplateRegion = "ZebraEa3600Template",
        IoSystemPath = PlcLine, IoSystemRegion = "ZebraEa3600IoSystem",
    };

    public static ShowcasePageDescriptor ZebraVision { get; } = new()
    {
        Route = "/components-zebra-vision/Documentation/ZebraVision",
        Title = "Zebra Vision",
        LibraryNamespace = "AXOpen.Components.Zebra.Vision",
        Category = "Vision",
        Vendor = "Zebra Technologies",
        VendorUrl = "https://www.zebra.com/",
        Icon = "eye",
        BrandIcon = "eye",
        AccentColor = "#0ea5e9",
        Description = "This page combines runnable command widgets, live component status, and direct links to PLC source files. Use it as a practical reference for integrating Zebra vision systems in SIMATIC AX applications.",
        Tags = ["vision", "zebra", "camera", "ea3600", "scanner", "profinet"],
        NavGroup = "Vendor Components",
        NavOrder = 32,
        ContextSourcePath = $"{ZebraDocDir}/ZebraVision.st",
        SourceFilePaths =
        [
            $"{ZebraDocDir}/ZebraVision.st",
            $"{ZebraDocDir}/AxoEA3600_Showcase.st",
            $"{ZebraDocDir}/AxoEA3600_Showcase2.st",
        ],
        LibraryDocs =
        [
            new("src/components.zebra.vision/docs/README.md", "README — Overview", Mono: false),
            new("src/components.zebra.vision/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        HardwareAssets =
        [
            new(ZebraTemplate),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoEA3600 (Example 1)",
                MaturityKey = "Zebra Vision",
                Declaration = Declaration($"{ZebraDocDir}/AxoEA3600_Showcase.st"),
                Initialization = Initialization($"{ZebraDocDir}/AxoEA3600_Showcase.st"),
                Hardware = [ZebraHardware],
                Twin = c => c.zebra_vision_documentation.axoEA3600,
                Sequencer = c => c.zebra_vision_documentation.axoEA3600.Sequencer,
                Steps = c => c.zebra_vision_documentation.axoEA3600.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoEA3600 (Example 2)",
                MaturityKey = "Zebra Vision",
                Declaration = Declaration($"{ZebraDocDir}/AxoEA3600_Showcase2.st"),
                Initialization = Initialization($"{ZebraDocDir}/AxoEA3600_Showcase2.st"),
                Hardware = [ZebraHardware],
                Twin = c => c.zebra_vision_documentation.axoEA3600_2,
            },
        ],
    };
}
