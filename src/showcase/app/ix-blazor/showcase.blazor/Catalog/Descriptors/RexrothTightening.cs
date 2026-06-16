using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Rexroth Tightening ------------------------------------------------------------------

    private const string RexrothTighteningDocDir = "src/showcase/app/src/components.rexroth.tightening/Documentation";
    private const string RexrothCs351Template = "src/showcase/app/hwc/library_templates/rexroth_tightening_cs351/rexroth_tightening_cs351.hwl.yml";

    private static HardwareRef RexrothCs351Hardware => new()
    {
        Label = "Rexroth CS351",
        InstancePath = PlcLine, DeviceRegion = "RexrothCs351Device",
        TemplatePath = RexrothCs351Template, TemplateRegion = "RexrothCs351Template",
        IoSystemPath = PlcLine, IoSystemRegion = "RexrothCs351IoSystem",
    };

    public static ShowcasePageDescriptor RexrothTightening { get; } = new()
    {
        Route = "/components-rexroth-tightening/Documentation/RexrothTightening",
        Title = "Rexroth Tightening",
        LibraryNamespace = "AXOpen.Components.Rexroth.Tightening",
        Category = "Tightening",
        Vendor = "Bosch Rexroth",
        VendorUrl = "https://www.boschrexroth.com/",
        Icon = "wrench",
        BrandIcon = "wrench",
        AccentColor = "#dc2626",
        Description = "This page combines runnable command widgets, live component status, and direct links to PLC source files. Use it as a practical reference for integrating Bosch Rexroth tightening controllers in SIMATIC AX applications.",
        Tags = ["tightening", "rexroth", "bosch", "cs351", "screwdriving", "profinet"],
        NavGroup = "Vendor Components",
        NavOrder = 61,
        ContextSourcePath = $"{RexrothTighteningDocDir}/RexrothTightening.st",
        SourceFilePaths =
        [
            $"{RexrothTighteningDocDir}/RexrothTightening.st",
            $"{RexrothTighteningDocDir}/Axo_CS351_compact_Showcase.st",
            $"{RexrothTighteningDocDir}/Axo_CS351_compact_Showcase2.st",
        ],
        LibraryDocs =
        [
            new("src/components.rexroth.tightening/docs/README.md", "README — Overview", Mono: false),
            new("src/components.rexroth.tightening/docs/Axo_CS351_compact.md", "CS351 Compact", Mono: false),
            new("src/components.rexroth.tightening/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.rexroth.tightening/ctrl/src/Axo_CS351_compact/Axo_CS351_compact.st"),
            new("src/components.rexroth.tightening/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new("src/components.rexroth.tightening/ctrl/assets/rexroth_tightening_cs351/rexroth_tightening_cs351.hwl.yml"),
            new("src/components.rexroth.tightening/ctrl/assets/rexroth_tightening_cs351/GSDML-V2.0-Rexroth-Schraubsystem350-20090127.xml", "GSDML — Rexroth Schraubsystem 350"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoCS351 (Example 1)",
                MaturityKey = "Rexroth Tightening",
                Declaration = Declaration($"{RexrothTighteningDocDir}/Axo_CS351_compact_Showcase.st"),
                Initialization = Initialization($"{RexrothTighteningDocDir}/Axo_CS351_compact_Showcase.st"),
                Hardware = [RexrothCs351Hardware],
                Twin = c => c.rexroth_tightening_documentation.axo_CS351_compact.ExampleComponent,
                Sequencer = c => c.rexroth_tightening_documentation.axo_CS351_compact.Sequencer,
                Steps = c => c.rexroth_tightening_documentation.axo_CS351_compact.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoCS351 (Example 2)",
                MaturityKey = "Rexroth Tightening",
                Declaration = Declaration($"{RexrothTighteningDocDir}/Axo_CS351_compact_Showcase2.st"),
                Initialization = Initialization($"{RexrothTighteningDocDir}/Axo_CS351_compact_Showcase2.st"),
                Hardware = [RexrothCs351Hardware],
                Twin = c => c.rexroth_tightening_documentation.axo_CS351_compact_2.ExampleComponent,
                Sequencer = c => c.rexroth_tightening_documentation.axo_CS351_compact_2.Sequencer,
                Steps = c => c.rexroth_tightening_documentation.axo_CS351_compact_2.Steps,
            },
        ],
    };
}
