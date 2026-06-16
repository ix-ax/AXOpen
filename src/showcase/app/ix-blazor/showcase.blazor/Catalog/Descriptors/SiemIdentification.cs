using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Siemens Identification --------------------------------------------------------------

    private const string SiemIdentDocDir = "src/showcase/app/src/components.siem.identification/Documentation";
    private const string SiemIdentTemplate = "src/showcase/app/hwc/library_templates/siemens_identification/rf186c.hwl.yml";

    private static HardwareRef SiemIdentHardware => new()
    {
        Label = "Siemens RF186C",
        InstancePath = PlcLine, DeviceRegion = "SiemIdentificationDevice",
        TemplatePath = SiemIdentTemplate, TemplateRegion = "SiemIdentificationTemplate",
        IoSystemPath = PlcLine, IoSystemRegion = "SiemIdentificationIoSystem",
    };

    public static ShowcasePageDescriptor SiemIdentification { get; } = new()
    {
        Route = "/components-siem-identification/Documentation/SiemIdentification",
        Title = "Siemens Identification",
        LibraryNamespace = "AXOpen.Components.Siem.Identification",
        Category = "Identification",
        Vendor = "Siemens",
        VendorUrl = "https://www.siemens.com/",
        Icon = "qr-code",
        BrandIcon = "qr-code",
        AccentColor = "#0d9488",
        Description = "RFID readers via Ident profile, IO-Link, and cyclic communication using Siemens RF186C / RF260R / RF340R hardware. Use this page as a practical reference for integrating Siemens identification components in SIMATIC AX applications.",
        Tags = ["identification", "siemens", "rfid", "ident", "io-link", "rf186c", "rf260r", "rf340r"],
        NavGroup = "Vendor Components",
        NavOrder = 51,
        ContextSourcePath = $"{SiemIdentDocDir}/SiemIdentification.st",
        SourceFilePaths =
        [
            $"{SiemIdentDocDir}/SiemIdentification.st",
            $"{SiemIdentDocDir}/Axo_IdentDevice_Showcase.st",
            $"{SiemIdentDocDir}/AxoIOLink_RF200Device_Showcase.st",
            $"{SiemIdentDocDir}/AxoSimaticIdentCyclic_Showcase.st",
            $"{SiemIdentDocDir}/AxoSimaticIdentCyclic_Showcase2.st",
        ],
        LibraryDocs =
        [
            new("src/components.siem.identification/docs/README.md", "README — Overview", Mono: false),
            new("src/components.siem.identification/docs/Axo_IdentDevice.md", "AxoIdentDevice — Ident Profile", Mono: false),
            new("src/components.siem.identification/docs/AxoIOLink_RF200Device.md", "AxoIOLink_RF200 — IO-Link RF200", Mono: false),
            new("src/components.siem.identification/docs/AxoSimaticIdentCyclic.md", "AxoSimaticIdentCyclic — Cyclic", Mono: false),
            new("src/components.siem.identification/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        HardwareAssets =
        [
            new(SiemIdentTemplate),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoIdentDevice (Profile)",
                MaturityKey = "Siemens ID",
                Declaration = Declaration($"{SiemIdentDocDir}/Axo_IdentDevice_Showcase.st"),
                Initialization = Initialization($"{SiemIdentDocDir}/Axo_IdentDevice_Showcase.st"),
                Hardware = [SiemIdentHardware],
                Twin = c => c.siem_identification_documentation.axo_IdentDevice,
                Sequencer = c => c.siem_identification_documentation.axo_IdentDevice.Sequencer,
                Steps = c => c.siem_identification_documentation.axo_IdentDevice.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoIOLink RF200",
                MaturityKey = "Siemens ID",
                Declaration = Declaration($"{SiemIdentDocDir}/AxoIOLink_RF200Device_Showcase.st"),
                Initialization = Initialization($"{SiemIdentDocDir}/AxoIOLink_RF200Device_Showcase.st"),
                Hardware = [SiemIdentHardware],
                Twin = c => c.siem_identification_documentation.axoIOLink_RF200Device,
                Sequencer = c => c.siem_identification_documentation.axoIOLink_RF200Device.Sequencer,
                Steps = c => c.siem_identification_documentation.axoIOLink_RF200Device.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoSimaticIdent RF260R",
                MaturityKey = "Siemens ID",
                Declaration = Declaration($"{SiemIdentDocDir}/AxoSimaticIdentCyclic_Showcase.st"),
                Initialization = Initialization($"{SiemIdentDocDir}/AxoSimaticIdentCyclic_Showcase.st"),
                Hardware = [SiemIdentHardware],
                Twin = c => c.siem_identification_documentation.axoSimaticIdentCyclic,
                Sequencer = c => c.siem_identification_documentation.axoSimaticIdentCyclic.Sequencer,
                Steps = c => c.siem_identification_documentation.axoSimaticIdentCyclic.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoSimaticIdent RF340R",
                MaturityKey = "Siemens ID",
                Declaration = Declaration($"{SiemIdentDocDir}/AxoSimaticIdentCyclic_Showcase2.st"),
                Initialization = Initialization($"{SiemIdentDocDir}/AxoSimaticIdentCyclic_Showcase2.st"),
                Hardware = [SiemIdentHardware],
                Twin = c => c.siem_identification_documentation.axoSimaticIdentCyclic_2,
                Sequencer = c => c.siem_identification_documentation.axoSimaticIdentCyclic_2.Sequencer,
                Steps = c => c.siem_identification_documentation.axoSimaticIdentCyclic_2.Steps,
            },
        ],
    };
}
