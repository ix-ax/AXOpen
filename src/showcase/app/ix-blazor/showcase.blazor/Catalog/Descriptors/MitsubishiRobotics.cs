using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Mitsubishi Robotics ------------------------------------------------------------------

    private const string MitsubishiDocDir = "src/showcase/app/src/components.mitsubishi.robotics/Documentation";
    private const string MitsubishiTemplate = "src/showcase/app/hwc/library_templates/mitsubishi_tz535/mitsubishi_tz535_64b_inout.hwl.yml";

    public static ShowcasePageDescriptor MitsubishiRobotics { get; } = new()
    {
        Route = "/components-mitsubishi-robotics/Documentation/MitsubishiRobotics",
        Title = "Mitsubishi Robotics",
        LibraryNamespace = "AXOpen.Components.Mitsubishi.Robotics",
        Category = "Robotics",
        Vendor = "Mitsubishi Electric",
        VendorUrl = "https://www.mitsubishielectric.com/",
        Icon = "cpu-chip",
        BrandIcon = "cpu-chip",
        AccentColor = "#b91c1c",
        Description = "This page combines runnable command widgets, live component status, and direct links to PLC source files. Use it as a practical reference for integrating Mitsubishi robots in SIMATIC AX applications.",
        Tags = ["robotics", "mitsubishi", "cr800", "robot", "profinet"],
        NavGroup = "Vendor Components",
        NavOrder = 42,
        ContextSourcePath = $"{MitsubishiDocDir}/MitsubishiRobotics.st",
        SourceFilePaths =
        [
            $"{MitsubishiDocDir}/MitsubishiRobotics.st",
            $"{MitsubishiDocDir}/AxoCr800_v_1_x_x_Showcase.st",
        ],
        LibraryDocs =
        [
            new("src/components.mitsubishi.robotics/docs/README.md", "README — Overview", Mono: false),
            new("src/components.mitsubishi.robotics/docs/AxoCr800_v_1_x_x.md", "AxoCr800 — Component guide", Mono: false),
            new("src/components.mitsubishi.robotics/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.mitsubishi.robotics/ctrl/src/AxoCr800_v_1_x_x.st"),
            new("src/components.mitsubishi.robotics/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new("src/components.mitsubishi.robotics/ctrl/assets/mitsubishi_tz535/mitsubishi_tz535_64b_inout.hwl.yml"),
            new("src/components.mitsubishi.robotics/ctrl/assets/mitsubishi_tz535/gsdml-v2.3-mitsubishi-tz535_pn-20140619.xml", "GSDML — Mitsubishi TZ535 v2.3"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoCr800 v_1_x_x",
                MaturityKey = "Mitsubishi CR800 v_1_x_x",
                Declaration = Declaration($"{MitsubishiDocDir}/AxoCr800_v_1_x_x_Showcase.st"),
                Initialization = Initialization($"{MitsubishiDocDir}/AxoCr800_v_1_x_x_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Mitsubishi TZ535 (CR800)",
                        InstancePath = PlcLine, DeviceRegion = "MitsubishiTz535Device",
                        TemplatePath = MitsubishiTemplate, TemplateRegion = "MitsubishiTz535Template",
                        IoSystemPath = PlcLine, IoSystemRegion = "MitsubishiTz535IoSystem",
                    },
                ],
                Twin = c => c.mitsubishi_robotics_documentation.axoCr800_v_1_x_x,
                Sequencer = c => c.mitsubishi_robotics_documentation.axoCr800_v_1_x_x.Sequencer,
                Steps = c => c.mitsubishi_robotics_documentation.axoCr800_v_1_x_x.Steps,
            },
        ],
    };
}
