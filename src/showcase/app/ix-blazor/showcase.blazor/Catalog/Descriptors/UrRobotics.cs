using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- Universal Robots ---------------------------------------------------------------------

    private const string UrDocDir = "src/showcase/app/src/components.ur.robotics/Documentation";
    private const string UrTemplate = "src/showcase/app/hwc/library_templates/ur_robotics/ur_robot.hwl.yml";

    public static ShowcasePageDescriptor UrRobotics { get; } = new()
    {
        Route = "/components-ur-robotics/Documentation/UrRobotics",
        Title = "UR Robotics",
        LibraryNamespace = "AXOpen.Components.Ur.Robotics",
        Category = "Robotics",
        Vendor = "Universal Robots",
        VendorUrl = "https://www.universal-robots.com/",
        Icon = "cpu-chip",
        BrandIcon = "cpu-chip",
        AccentColor = "#2563eb",
        Description = "Universal Robots CB3 controllers over PROFINET in SIMATIC AX.",
        Tags = ["robotics", "universal robots", "ur", "cb3", "cobot", "profinet"],
        NavGroup = "Vendor Components",
        NavOrder = 43,
        ContextSourcePath = $"{UrDocDir}/UrRobotics.st",
        SourceFilePaths =
        [
            $"{UrDocDir}/UrRobotics.st",
            $"{UrDocDir}/AxoUrCb3_v_3_x_x_Showcase.st",
        ],
        LibraryDocs =
        [
            new("src/components.ur.robotics/docs/README.md", "README — Overview", Mono: false),
            new("src/components.ur.robotics/docs/AxoUrCb3_v_3_x_x_Showcase.md", "AxoUrCb3 — Component guide", Mono: false),
            new("src/components.ur.robotics/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.ur.robotics/ctrl/src/AxoUrCb3/AxoUrCb3_v_3_x_x.st"),
            new("src/components.ur.robotics/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new("src/components.ur.robotics/ctrl/assets/ur_robotics/ur_robot.hwl.yml"),
            new("src/components.ur.robotics/ctrl/assets/ur_robotics/GSDML-V2.31-ur-UR-20160505.xml", "GSDML — UR v2.31"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoUrCb3 (v3.x.x)",
                MaturityKey = "UR CB3 v_3_x_x",
                Declaration = Declaration($"{UrDocDir}/AxoUrCb3_v_3_x_x_Showcase.st"),
                Initialization = Initialization($"{UrDocDir}/AxoUrCb3_v_3_x_x_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Universal Robots CB3",
                        InstancePath = PlcLine, DeviceRegion = "UrRobotDevice",
                        TemplatePath = UrTemplate, TemplateRegion = "UrRobotTemplate",
                        IoSystemPath = PlcLine, IoSystemRegion = "UrRobotIoSystem",
                    },
                ],
                Twin = c => c.ur_robotics_documentation.axoUrCb3_v_3_x_x,
                Sequencer = c => c.ur_robotics_documentation.axoUrCb3_v_3_x_x.Sequencer,
                Steps = c => c.ur_robotics_documentation.axoUrCb3_v_3_x_x.Steps,
            },
        ],
    };
}
