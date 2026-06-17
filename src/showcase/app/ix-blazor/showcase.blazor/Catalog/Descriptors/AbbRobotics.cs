using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- ABB Robotics ------------------------------------------------------------------------

    private const string AbbDocDir = "src/showcase/app/src/components.abb.robotics/Documentation";

    public static ShowcasePageDescriptor AbbRobotics { get; } = new()
    {
        Route = "/components-abb-robotics/Documentation/AbbRobotics",
        Title = "ABB Robotics",
        LibraryNamespace = "AXOpen.Components.Abb.Robotics",
        Category = "Robotics",
        Vendor = "ABB",
        VendorUrl = "https://new.abb.com/products/robotics",
        Icon = "cpu-chip",
        BrandIcon = "cpu-chip",
        AccentColor = "#dc2626",
        Description = "This page combines runnable command widgets, live component status, and direct links to PLC source files. Use it as a practical reference for integrating ABB robots in SIMATIC AX applications.",
        Tags = ["robotics", "abb", "irc5", "omnicore", "robot", "profinet"],
        NavGroup = "Vendor Components",
        NavOrder = 40,
        ContextSourcePath = $"{AbbDocDir}/AbbRobotics.st",
        SourceFilePaths =
        [
            $"{AbbDocDir}/AbbRobotics.st",
            $"{AbbDocDir}/AxoIrc5_v_1_x_x_Showcase.st",
            $"{AbbDocDir}/AxoOmnicore_v_1_x_x_Showcase.st",
        ],
        LibraryDocs =
        [
            new("src/components.abb.robotics/docs/README.md", "README — Overview", Mono: false),
            new("src/components.abb.robotics/docs/AxoIrc5_v_1_x_x.md", "AxoIrc5 — Component guide", Mono: false),
            new("src/components.abb.robotics/docs/AxoOmnicore_v_1_x_x.md", "AxoOmnicore — Component guide", Mono: false),
            new("src/components.abb.robotics/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.abb.robotics/ctrl/src/AxoIrc5_v_1_x_x.st"),
            new("src/components.abb.robotics/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new("src/components.abb.robotics/ctrl/assets/abb_robotics_irc5/abb_irc5_robot_in64b_out64b.hwl.yml"),
            new("src/components.abb.robotics/ctrl/assets/abb_robotics_irc5/gsdml-v2.33-abb-robotics-robot-device-20180814.xml", "GSDML — ABB IRC5 v2.33"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoIrc5",
                MaturityKey = "ABB OmniCore v_1_x_x",
                Declaration = Declaration($"{AbbDocDir}/AxoIrc5_v_1_x_x_Showcase.st"),
                Initialization = Initialization($"{AbbDocDir}/AxoIrc5_v_1_x_x_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "ABB IRC5",
                        InstancePath = PlcLine, DeviceRegion = "AbbIrc5Device",
                        TemplatePath = "src/showcase/app/hwc/library_templates/abb_robotics_irc5/abb_irc5_robot_in64b_out64b.hwl.yml",
                        TemplateRegion = "AbbIrc5Template",
                        IoSystemPath = PlcLine, IoSystemRegion = "AbbIrc5IoSystem",
                    },
                ],
                Twin = c => c.abb_robotics_documentation.axoIrc5_v_1_x_x,
                Sequencer = c => c.abb_robotics_documentation.axoIrc5_v_1_x_x.Sequencer,
                Steps = c => c.abb_robotics_documentation.axoIrc5_v_1_x_x.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoOmnicore",
                MaturityKey = "ABB OmniCore v_1_x_x",
                Declaration = Declaration($"{AbbDocDir}/AxoOmnicore_v_1_x_x_Showcase.st"),
                Initialization = Initialization($"{AbbDocDir}/AxoOmnicore_v_1_x_x_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "ABB OmniCore",
                        InstancePath = PlcLine, DeviceRegion = "AbbOmnicoreDevice",
                        TemplatePath = "src/showcase/app/hwc/library_templates/abb_robotics_omnicore/abb_omnicore_robot_in64b_out64b.hwl.yml",
                        TemplateRegion = "AbbOmnicoreTemplate",
                        IoSystemPath = PlcLine, IoSystemRegion = "AbbOmnicoreIoSystem",
                    },
                ],
                Twin = c => c.abb_robotics_documentation.axoOmnicore_v_1_x_x,
                Sequencer = c => c.abb_robotics_documentation.axoOmnicore_v_1_x_x.Sequencer,
                Steps = c => c.abb_robotics_documentation.axoOmnicore_v_1_x_x.Steps,
            },
        ],
    };
}
