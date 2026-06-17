using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Rexroth Drives ----------------------------------------------------------------------

    private const string RexrothDrivesDocDir = "src/showcase/app/src/components.rexroth.drives/Documentation";

    public static ShowcasePageDescriptor RexrothDrives { get; } = new()
    {
        Route = "/components-rexroth-drives/Documentation/RexrothDrives",
        Title = "Rexroth Drives",
        LibraryNamespace = "AXOpen.Components.Rexroth.Drives",
        Category = "Drives",
        Vendor = "Bosch Rexroth",
        VendorUrl = "https://www.boschrexroth.com/",
        Icon = "bolt",
        BrandIcon = "bolt",
        AccentColor = "#dc2626",
        Description = "This page combines runnable command widgets, live component status, and direct links to PLC source files. Use it as a practical reference for integrating Bosch Rexroth drives (IndraDrive, ctrlX DRIVE) in SIMATIC AX applications.",
        Tags = ["drives", "rexroth", "bosch", "indradrive", "ctrlx", "servo", "motion", "profinet"],
        NavGroup = "Vendor Components",
        NavOrder = 22,
        ContextSourcePath = $"{RexrothDrivesDocDir}/RexrothDrives.st",
        SourceFilePaths =
        [
            $"{RexrothDrivesDocDir}/RexrothDrives.st",
            $"{RexrothDrivesDocDir}/AxoIndraDrive_Showcase.st",
            $"{RexrothDrivesDocDir}/AxoCtrlxDriveXsc_Showcase.st",
        ],
        LibraryDocs =
        [
            new("src/components.rexroth.drives/docs/README.md", "README — Overview", Mono: false),
            new("src/components.rexroth.drives/docs/AxoIndraDrive.md", "AxoIndraDrive — Component guide", Mono: false),
            new("src/components.rexroth.drives/docs/AxoCtrlxDriveXsc.md", "AxoCtrlxDriveXsc — Component guide", Mono: false),
            new("src/components.rexroth.drives/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.rexroth.drives/ctrl/src/AxoIndraDrive/AxoIndraDrive.st"),
            new("src/components.rexroth.drives/ctrl/src/AxoCtrlxDriveXsc/AxoCtrlxDriveXsc.st"),
            new("src/components.rexroth.drives/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new("src/components.rexroth.drives/ctrl/assets/rexroth_indradrive/rexroth_indradrive.hwl.yml"),
            new("src/components.rexroth.drives/ctrl/assets/rexroth_ctrlx_drive/rexroth_ctrlx_drive_xcs.hwl.yml"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "IndraDrive (Component 1)",
                MaturityKey = "Rexroth Drives",
                Declaration = Declaration($"{RexrothDrivesDocDir}/AxoIndraDrive_Showcase.st"),
                Initialization = Initialization($"{RexrothDrivesDocDir}/AxoIndraDrive_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Rexroth IndraDrive",
                        InstancePath = PlcLine, DeviceRegion = "RexrothIndraDriveDevice",
                        TemplatePath = "src/showcase/app/hwc/library_templates/rexroth_indradrive/rexroth_indradrive.hwl.yml",
                        TemplateRegion = "RexrothIndraDriveTemplate",
                        IoSystemPath = PlcLine, IoSystemRegion = "RexrothIndraDriveIoSystem",
                    },
                ],
                Twin = c => c.rexroth_drives_documentation.axoIndraDrive.IndraDrive,
                Sequencer = c => c.rexroth_drives_documentation.axoIndraDrive.Sequencer,
                Steps = c => c.rexroth_drives_documentation.axoIndraDrive.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "ctrlX DRIVE XSC (Component 2)",
                MaturityKey = "Rexroth Drives",
                Declaration = Declaration($"{RexrothDrivesDocDir}/AxoCtrlxDriveXsc_Showcase.st"),
                Initialization = Initialization($"{RexrothDrivesDocDir}/AxoCtrlxDriveXsc_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Rexroth ctrlX DRIVE",
                        InstancePath = PlcLine, DeviceRegion = "RexrothCtrlxDriveDevice",
                        TemplatePath = "src/showcase/app/hwc/library_templates/rexroth_ctrlx_drive/rexroth_ctrlx_drive_xcs.hwl.yml",
                        TemplateRegion = "RexrothCtrlxDriveTemplate",
                        IoSystemPath = PlcLine, IoSystemRegion = "RexrothCtrlxDriveIoSystem",
                    },
                ],
                Twin = c => c.rexroth_drives_documentation.axoCtrlxDriveXsc.CtrlXdrive,
                Sequencer = c => c.rexroth_drives_documentation.axoCtrlxDriveXsc.Sequencer,
                Steps = c => c.rexroth_drives_documentation.axoCtrlxDriveXsc.Steps,
            },
        ],
    };
}
