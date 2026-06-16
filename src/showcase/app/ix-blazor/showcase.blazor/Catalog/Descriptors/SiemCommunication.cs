using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Siemens Communication ---------------------------------------------------------------

    private const string SiemCommunicationDocDir = "src/showcase/app/src/components.siem.communication/Documentation";
    private const string SiemCommunicationComponentSt = $"{SiemCommunicationDocDir}/AxoCmPtp_Showcase.st";
    private const string SiemCommunicationTemplate = "src/showcase/app/hwc/library_templates/siemens_communication/et200sp.hwl.yml";

    public static ShowcasePageDescriptor SiemCommunication { get; } = new()
    {
        Route = "/components-siem-communication/Documentation/SiemCommunication",
        Title = "Siemens Communication",
        LibraryNamespace = "AXOpen.Components.Siem.Communication",
        Category = "Communication",
        Vendor = "Siemens",
        VendorUrl = "https://www.siemens.com/",
        Icon = "chat-bubble-left-right",
        BrandIcon = "chat-bubble-left-right",
        AccentColor = "#0d9488",
        Description = "Point-to-point serial communication via Siemens ET200SP CM PtP module. " +
                      "Use this page as a practical reference for integrating Siemens communication components in SIMATIC AX applications.",
        Tags = ["communication", "siemens", "serial", "point-to-point", "ptp", "et200sp", "cm"],
        NavGroup = "Vendor Components",
        NavOrder = 52,
        ContextSourcePath = $"{SiemCommunicationDocDir}/SiemCommunication.st",
        SourceFilePaths =
        [
            $"{SiemCommunicationDocDir}/SiemCommunication.st",
            SiemCommunicationComponentSt,
        ],
        LibraryDocs =
        [
            new("src/components.siem.communication/docs/README.md", "README — Overview", Mono: false),
            new("src/components.siem.communication/docs/AxoCmPtp_Showcase.md", "AxoCmPtp — Component guide", Mono: false),
            new("src/components.siem.communication/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        HardwareAssets =
        [
            new(SiemCommunicationTemplate),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoCmPtp",
                MaturityKey = "SiemCommunication",
                Declaration = Declaration(SiemCommunicationComponentSt),
                Initialization = Initialization(SiemCommunicationComponentSt),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Siemens ET200SP CM PtP",
                        InstancePath = PlcLine, DeviceRegion = "SiemCommunicationDevice",
                        TemplatePath = SiemCommunicationTemplate, TemplateRegion = "SiemCommunicationTemplate",
                        IoSystemPath = PlcLine, IoSystemRegion = "SiemCommunicationIoSystem",
                    },
                ],
                Twin = c => c.siem_communication_documentation.axoCmPtp,
                Sequencer = c => c.siem_communication_documentation.axoCmPtp.Sequencer,
                Steps = c => c.siem_communication_documentation.axoCmPtp.Steps,
            },
        ],
    };
}
