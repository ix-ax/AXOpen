using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Rexroth Press -----------------------------------------------------------------------

    private const string RexrothPressDocDir = "src/showcase/app/src/components.rexroth.press/Documentation";
    private const string RexrothPressTemplate = "src/showcase/app/hwc/library_templates/rexroth_sfk_press/rexroth_sfk_press.hwl.yml";

    public static ShowcasePageDescriptor RexrothPress { get; } = new()
    {
        Route = "/components-rexroth-press/Documentation/RexrothPress",
        Title = "Rexroth Press",
        LibraryNamespace = "AXOpen.Components.Rexroth.Press",
        Category = "Press",
        Vendor = "Bosch Rexroth",
        VendorUrl = "https://www.boschrexroth.com/",
        Icon = "arrow-down-on-square",
        BrandIcon = "arrow-down-on-square",
        AccentColor = "#dc2626",
        Description = "This page combines runnable command widgets, live component status, and direct links to PLC source files. Use it as a practical reference for integrating Bosch Rexroth Smart Function Kit press systems in SIMATIC AX applications.",
        Tags = ["press", "rexroth", "bosch", "smart-function-kit", "sfk", "profinet"],
        NavGroup = "Vendor Components",
        NavOrder = 70,
        ContextSourcePath = $"{RexrothPressDocDir}/RexrothPress.st",
        SourceFilePaths =
        [
            $"{RexrothPressDocDir}/RexrothPress.st",
            $"{RexrothPressDocDir}/AxoSmartFunctionKit_v_4_x_x_Showcase.st",
        ],
        LibraryDocs =
        [
            new("src/components.rexroth.press/docs/README.md", "README — Overview", Mono: false),
            new("src/components.rexroth.press/docs/AxoSmartFunctionKit_v_4_x_x.md", "AxoSmartFunctionKit — Component guide", Mono: false),
            new("src/components.rexroth.press/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.rexroth.press/ctrl/src/AxoSmartFunctionKit_v_4_x_x.st"),
            new("src/components.rexroth.press/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new(RexrothPressTemplate),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoSmartFunctionKit",
                MaturityKey = "Rexroth Smart Function Kit",
                Declaration = Declaration($"{RexrothPressDocDir}/AxoSmartFunctionKit_v_4_x_x_Showcase.st"),
                Initialization = Initialization($"{RexrothPressDocDir}/AxoSmartFunctionKit_v_4_x_x_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Rexroth Smart Function Kit Press",
                        InstancePath = PlcLine, DeviceRegion = "RexrothSfkPressDevice",
                        TemplatePath = RexrothPressTemplate, TemplateRegion = "RexrothSfkPressTemplate",
                        IoSystemPath = PlcLine, IoSystemRegion = "RexrothSfkPressIoSystem",
                    },
                ],
                Twin = c => c.rexroth_press_documentation.axoSmartFunctionKit_v_4_x_x.AxoSmartFunctionKit,
                Sequencer = c => c.rexroth_press_documentation.axoSmartFunctionKit_v_4_x_x.Sequencer,
                Steps = c => c.rexroth_press_documentation.axoSmartFunctionKit_v_4_x_x.Steps,
            },
        ],
    };
}