using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Desoutter Tightening ----------------------------------------------------------------

    private const string DesoutterDocDir = "src/showcase/app/src/components.desoutter.tightening/Documentation";
    private const string DesoutterTemplate = "src/showcase/app/hwc/library_templates/desoutter_tightenning_CVIC_II/Desoutter_CVIC_II.hwl.yml";

    public static ShowcasePageDescriptor DesoutterTightening { get; } = new()
    {
        Route = "/components-desoutter-tightening/Documentation/DesoutterTightening",
        Title = "Desoutter Tightening",
        LibraryNamespace = "AXOpen.Components.Desoutter.Tightening",
        Category = "Tightening",
        Vendor = "Desoutter",
        VendorUrl = "https://www.desouttertools.com/",
        Icon = "wrench",
        BrandIcon = "wrench",
        AccentColor = "#0891b2",
        Description = "This page combines runnable command widgets, live component status, and direct links to PLC source files. Use it as a practical reference for integrating Desoutter tightening controllers in SIMATIC AX applications.",
        Tags = ["tightening", "desoutter", "cvic", "screwdriver", "screwing", "profinet"],
        NavGroup = "Vendor Components",
        NavOrder = 60,
        ContextSourcePath = $"{DesoutterDocDir}/DesoutterTightening.st",
        SourceFilePaths =
        [
            $"{DesoutterDocDir}/DesoutterTightening.st",
            $"{DesoutterDocDir}/AxoCVIC_II.st",
        ],
        LibraryDocs =
        [
            new("src/components.desoutter.tightening/docs/README.md", "README — Overview", Mono: false),
            new("src/components.desoutter.tightening/docs/AxoCVIC_II.md", "AxoCVIC_II — Component guide", Mono: false),
            new("src/components.desoutter.tightening/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.desoutter.tightening/ctrl/src/CVIC_II/AxoCVIC_II.st"),
            new("src/components.desoutter.tightening/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new("src/components.desoutter.tightening/ctrl/assets/desoutter_tightenning_CVIC_II/Desoutter_CVIC_II.hwl.yml"),
            new("src/components.desoutter.tightening/ctrl/assets/desoutter_tightenning_CVIC_II/GSDML-V2.2-DESOUTTER-PRT-20100408.xml", "GSDML — Desoutter PRT"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoCVIC_II",
                MaturityKey = "Desoutter Tightening",
                Declaration = Declaration($"{DesoutterDocDir}/AxoCVIC_II.st"),
                Initialization = Initialization($"{DesoutterDocDir}/AxoCVIC_II.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Desoutter CVIC II",
                        InstancePath = PlcLine, DeviceRegion = "DesoutterCvicIiDevice",
                        TemplatePath = DesoutterTemplate, TemplateRegion = "DesoutterCvicIiTemplate",
                        IoSystemPath = PlcLine, IoSystemRegion = "DesoutterCvicIiIoSystem",
                    },
                ],
                Twin = c => c.desoutter_tightening_documentation.axoCVIC_II.ExampleScrewdriver,
                Sequencer = c => c.desoutter_tightening_documentation.axoCVIC_II.Sequencer,
                Steps = c => c.desoutter_tightening_documentation.axoCVIC_II.Steps,
            },
        ],
    };
}
