using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Keyence Vision ----------------------------------------------------------------------

    private const string KeyenceDocDir = "src/showcase/app/src/components.keyence.vision/Documentation";

    public static ShowcasePageDescriptor KeyenceVision { get; } = new()
    {
        Route = "/components-keyence-vision/Documentation/KeyenceVision",
        Title = "Keyence Vision",
        LibraryNamespace = "AXOpen.Components.Keyence.Vision",
        Category = "Vision",
        Vendor = "Keyence",
        VendorUrl = "https://www.keyence.com/",
        Icon = "eye",
        BrandIcon = "eye",
        AccentColor = "#16a34a",
        Description = "Keyence vision systems (SR-750, SR-1000, IV3) over PROFINET in SIMATIC AX.",
        Tags = ["vision", "keyence", "camera", "sr-750", "sr-1000", "iv3", "barcode"],
        NavGroup = "Vendor Components",
        NavOrder = 31,
        ContextSourcePath = $"{KeyenceDocDir}/KeyenceVision.st",
        SourceFilePaths =
        [
            $"{KeyenceDocDir}/KeyenceVision.st",
            $"{KeyenceDocDir}/Axo_SR_750_Showcase.st",
            $"{KeyenceDocDir}/Axo_SR_1000_Showcase.st",
            $"{KeyenceDocDir}/Axo_IV3_Showcase.st",
        ],
        LibraryDocs =
        [
            new("src/components.keyence.vision/docs/README.md", "README — Overview", Mono: false),
            new("src/components.keyence.vision/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        HardwareAssets =
        [
            new("src/showcase/app/hwc/library_templates/Keyence_SR_750/Keyence_SR_750.hwl.yml"),
            new("src/showcase/app/hwc/library_templates/Keyence_SR_1000/Keyence_SR_1000.hwl.yml"),
            new("src/showcase/app/hwc/library_templates/Keyence_IV3/Keyence_IV3.hwl.yml"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoSR750",
                MaturityKey = "Keyence Vision",
                Declaration = Declaration($"{KeyenceDocDir}/Axo_SR_750_Showcase.st"),
                Initialization = Initialization($"{KeyenceDocDir}/Axo_SR_750_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Keyence SR-750",
                        InstancePath = PlcLine, DeviceRegion = "KeyenceSr750Device",
                        TemplatePath = "src/showcase/app/hwc/library_templates/Keyence_SR_750/Keyence_SR_750.hwl.yml",
                        TemplateRegion = "KeyenceSr750Template",
                        IoSystemPath = PlcLine, IoSystemRegion = "KeyenceSr750IoSystem",
                    },
                ],
                Twin = c => c.keyence_vision_documentation.axo_SR_750,
                Sequencer = c => c.keyence_vision_documentation.axo_SR_750.Sequencer,
                Steps = c => c.keyence_vision_documentation.axo_SR_750.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoSR1000",
                MaturityKey = "Keyence Vision",
                Declaration = Declaration($"{KeyenceDocDir}/Axo_SR_1000_Showcase.st"),
                Initialization = Initialization($"{KeyenceDocDir}/Axo_SR_1000_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Keyence SR-1000",
                        InstancePath = PlcLine, DeviceRegion = "KeyenceSr1000Device",
                        TemplatePath = "src/showcase/app/hwc/library_templates/Keyence_SR_1000/Keyence_SR_1000.hwl.yml",
                        TemplateRegion = "KeyenceSr1000Template",
                        IoSystemPath = PlcLine, IoSystemRegion = "KeyenceSr1000IoSystem",
                    },
                ],
                Twin = c => c.keyence_vision_documentation.axo_SR_1000,
                Sequencer = c => c.keyence_vision_documentation.axo_SR_1000.Sequencer,
                Steps = c => c.keyence_vision_documentation.axo_SR_1000.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoIV3",
                MaturityKey = "Keyence Vision",
                Declaration = Declaration($"{KeyenceDocDir}/Axo_IV3_Showcase.st"),
                Initialization = Initialization($"{KeyenceDocDir}/Axo_IV3_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Keyence IV3",
                        InstancePath = PlcLine, DeviceRegion = "KeyenceIv3Device",
                        TemplatePath = "src/showcase/app/hwc/library_templates/Keyence_IV3/Keyence_IV3.hwl.yml",
                        TemplateRegion = "KeyenceIv3Template",
                        IoSystemPath = PlcLine, IoSystemRegion = "KeyenceIv3IoSystem",
                    },
                ],
                Twin = c => c.keyence_vision_documentation.axo_IV3.Component,
                Sequencer = c => c.keyence_vision_documentation.axo_IV3.Sequencer,
                Steps = c => c.keyence_vision_documentation.axo_IV3.Steps,
            },
        ],
    };
}
