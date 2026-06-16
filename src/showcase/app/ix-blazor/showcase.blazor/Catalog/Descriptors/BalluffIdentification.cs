using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Balluff Identification --------------------------------------------------------------

    private const string BalluffDocDir = "src/showcase/app/src/components.balluff.identification/Documentation";
    private const string BalluffTemplate = "src/showcase/app/hwc/library_templates/balluff_identification_BIS_M_4XX_045/BNIPNT507005Z040.hwl.yml";

    private static HardwareRef BalluffHardware => new()
    {
        Label = "Balluff BIS M-4XX-045",
        InstancePath = PlcLine, DeviceRegion = "BalluffBisDevice",
        TemplatePath = BalluffTemplate, TemplateRegion = "BalluffBisTemplate",
        IoSystemPath = PlcLine, IoSystemRegion = "BalluffBisIoSystem",
    };

    public static ShowcasePageDescriptor BalluffIdentification { get; } = new()
    {
        Route = "/components-balluff-identification/Documentation/BalluffIdentification",
        Title = "Balluff Identification",
        LibraryNamespace = "AXOpen.Components.Balluff.Identification",
        Category = "Identification",
        Vendor = "Balluff",
        VendorUrl = "https://www.balluff.com/",
        Icon = "qr-code",
        BrandIcon = "qr-code",
        AccentColor = "#1d4ed8",
        Description = "This page combines runnable command widgets, live component status, and direct links to PLC source files. Use it as a practical reference for integrating Balluff identification readers in SIMATIC AX applications.",
        Tags = ["identification", "balluff", "rfid", "bis", "reader", "profinet"],
        NavGroup = "Vendor Components",
        NavOrder = 50,
        ContextSourcePath = $"{BalluffDocDir}/BalluffIdentification.st",
        SourceFilePaths =
        [
            $"{BalluffDocDir}/BalluffIdentification.st",
            $"{BalluffDocDir}/Axo_BIS_M_4XX_045.st",
            $"{BalluffDocDir}/Axo_BIS_M_4XX_045_ManualControl.st",
        ],
        LibraryDocs =
        [
            new("src/components.balluff.identification/docs/README.md", "README — Overview", Mono: false),
            new("src/components.balluff.identification/docs/Axo_BIS_M_4XX_045.md", "AxoBIS_M — Component guide", Mono: false),
            new("src/components.balluff.identification/docs/Axo_BIS_M_4XX_045.md", "AxoBIS_M (Example 2) — Component guide", Mono: false),
            new("src/components.balluff.identification/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.balluff.identification/ctrl/src/Axo_BIS_M_4XX_045.st"),
            new("src/components.balluff.identification/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new(BalluffTemplate),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoBIS_M (Example 1)",
                MaturityKey = "Balluff ID",
                Declaration = Declaration($"{BalluffDocDir}/Axo_BIS_M_4XX_045.st"),
                Initialization = Initialization($"{BalluffDocDir}/Axo_BIS_M_4XX_045.st"),
                Hardware = [BalluffHardware],
                Twin = c => c.balluff_identification_documentation.axo_BIS_M_4XX_045,
                Sequencer = c => c.balluff_identification_documentation.axo_BIS_M_4XX_045.Sequencer,
                Steps = c => c.balluff_identification_documentation.axo_BIS_M_4XX_045.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoBIS_M (Example 2)",
                MaturityKey = "Balluff ID",
                Declaration = Declaration($"{BalluffDocDir}/Axo_BIS_M_4XX_045_ManualControl.st"),
                Initialization = Initialization($"{BalluffDocDir}/Axo_BIS_M_4XX_045_ManualControl.st"),
                Hardware = [BalluffHardware],
                Twin = c => c.balluff_identification_documentation.axo_BIS_M_4XX_045_ManualControl,
            },
        ],
    };
}
