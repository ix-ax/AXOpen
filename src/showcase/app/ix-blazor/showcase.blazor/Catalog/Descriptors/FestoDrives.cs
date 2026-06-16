using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Festo Drives ------------------------------------------------------------------------

    private const string FestoDrivesDocDir = "src/showcase/app/src/components.festo.drives/Documentation";

    public static ShowcasePageDescriptor FestoDrives { get; } = new()
    {
        Route = "/components-festo-drives/Documentation/FestoDrives",
        Title = "Festo Drives",
        LibraryNamespace = "AXOpen.Components.Festo.Drives",
        Category = "Drives",
        Vendor = "Festo",
        VendorUrl = "https://www.festo.com/de/en/",
        Icon = "bolt",
        BrandIcon = "bolt",
        AccentColor = "#2563eb",
        Description = "This page combines runnable command widgets, live component status, and direct links to PLC source files. Use it as a practical reference for integrating Festo drives in SIMATIC AX applications.",
        Tags = ["drives", "festo", "cmmt-as", "servo", "motion", "profinet"],
        NavGroup = "Vendor Components",
        NavOrder = 23,
        ContextSourcePath = $"{FestoDrivesDocDir}/FestoDrives.st",
        SourceFilePaths =
        [
            $"{FestoDrivesDocDir}/FestoDrives.st",
            $"{FestoDrivesDocDir}/AxoCmmtAs_Showcase.st",
            $"{FestoDrivesDocDir}/AxoCmmtAs_Showcase2.st",
        ],
        LibraryDocs =
        [
            new("src/components.festo.drives/docs/README.md", "README — Overview", Mono: false),
            new("src/components.festo.drives/docs/AxoCmmtAs_Showcase.md", "AxoCmmtAs — Component guide", Mono: false),
            new("src/components.festo.drives/docs/AxoCmmtAs_Showcase2.md", "AxoCmmtAs (Ex.2) — Component guide", Mono: false),
            new("src/components.festo.drives/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.festo.drives/ctrl/src/AxoCmmtAs/AxoCmmtAs.st"),
            new("src/components.festo.drives/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new("src/components.festo.drives/ctrl/assets/festo_drives_cmmt_as/FestoCmmtAs.hwl.yml"),
            new("src/components.festo.drives/ctrl/assets/festo_drives_cmmt_as/gsdml-v2.41-festo-cmmt-as-20230601.xml", "GSDML — CMMT-AS v2.41"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoCmmtAs",
                MaturityKey = "Festo Drives",
                Declaration = Declaration($"{FestoDrivesDocDir}/AxoCmmtAs_Showcase.st"),
                Initialization = Initialization($"{FestoDrivesDocDir}/AxoCmmtAs_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Festo CMMT-AS",
                        InstancePath = PlcLine, DeviceRegion = "FestoCmmtAsDevice",
                        TemplatePath = "src/showcase/app/hwc/library_templates/festo_drives_cmmt_as/FestoCmmtAs.hwl.yml",
                        TemplateRegion = "FestoCmmtAsTemplate",
                        IoSystemPath = PlcLine, IoSystemRegion = "FestoCmmtAsIoSystem",
                    },
                ],
                Twin = c => c.festo_drives_documentation.axoCmmtAs.AxoCmmtAs,
                Sequencer = c => c.festo_drives_documentation.axoCmmtAs.Sequencer,
                Steps = c => c.festo_drives_documentation.axoCmmtAs.Steps,
            },
        ],
    };
}
