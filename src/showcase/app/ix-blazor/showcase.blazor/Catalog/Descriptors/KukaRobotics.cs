using AXOpen.Core;
using AXSharp.Connector;
using showcase.Models.Showcase;

namespace showcase.Catalog;

public static partial class ShowcaseCatalog
{
    // ---- KUKA Robotics -----------------------------------------------------------------------

    private const string KukaDocDir = "src/showcase/app/src/components.kuka.robotics/Documentation";
    private const string KukaKrc4Template = "src/components.kuka.robotics/ctrl/assets/kuka_krc4/kuka_krc4_dio512.hwl.yml";
    private const string KukaKrc5Template = "src/components.kuka.robotics/ctrl/assets/kuka_krc5/kuka_krc5_dio512.hwl.yml";

    public static ShowcasePageDescriptor KukaRobotics { get; } = new()
    {
        Route = "/components-kuka-robotics/Documentation/KukaRobotics",
        Title = "KUKA Robotics",
        LibraryNamespace = "AXOpen.Components.Kuka.Robotics",
        Category = "Robotics",
        Vendor = "KUKA",
        VendorUrl = "https://www.kuka.com/",
        Icon = "cpu-chip",
        BrandIcon = "cpu-chip",
        AccentColor = "#ff7900",
        Description = "KUKA KRC4 and KRC5 robot controllers over PROFINET in SIMATIC AX.",
        Tags = ["robotics", "kuka", "robot", "krc4", "krc5", "profinet"],
        NavGroup = "Vendor Components",
        NavOrder = 41,
        ContextSourcePath = $"{KukaDocDir}/KukaRobotics.st",
        SourceFilePaths =
        [
            $"{KukaDocDir}/KukaRobotics.st",
            $"{KukaDocDir}/AxoKrc4_v_5_x_x_Showcase.st",
            $"{KukaDocDir}/AxoKrc5_v_5_x_x_Showcase.st",
        ],
        LibraryDocs =
        [
            new("src/components.kuka.robotics/docs/README.md", "README — Overview", Mono: false),
            new("src/components.kuka.robotics/docs/AxoKrc4_v_5_x_x.md", "AxoKrc4 — Component guide", Mono: false),
            new("src/components.kuka.robotics/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.kuka.robotics/ctrl/src/AxoKrc4/v_5_x_x/AxoKrc4.st"),
            new("src/components.kuka.robotics/ctrl/src/AxoKrc5/v_5_x_x/AxoKrc5.st"),
            new("src/components.kuka.robotics/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new(KukaKrc4Template, "KRC4 hwl asset"),
            new(KukaKrc5Template, "KRC5 hwl asset"),
            new("src/components.kuka.robotics/ctrl/assets/kuka_krc4/GSDML-V2.33-KUKA-KRC4-ProfiNet_5.0-20181102.xml", "GSDML — KUKA KRC4 v2.33"),
            new("src/components.kuka.robotics/ctrl/assets/kuka_krc5/GSDML-V2.4-KUKA-KR C5-20220704.xml", "GSDML — KUKA KRC5 v2.4"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoKrc4 — Sequenced workflow",
                MaturityKey = "KUKA KRC4 v_5_x_x",
                Declaration = Declaration($"{KukaDocDir}/AxoKrc4_v_5_x_x_Showcase.st"),
                Initialization = Initialization($"{KukaDocDir}/AxoKrc4_v_5_x_x_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "KUKA KRC4",
                        InstancePath = PlcLine, DeviceRegion = "KukaKrc4Device",
                        TemplatePath = KukaKrc4Template, TemplateRegion = "KukaKrc4Template",
                        IoSystemPath = PlcLine, IoSystemRegion = "KukaKrc4IoSystem",
                    },
                ],
                Twin = c => c.kuka_robotics_documentation.axoKrc4_v_5_x_x.ExampleRobot,
                Sequencer = c => c.kuka_robotics_documentation.axoKrc4_v_5_x_x.Sequencer,
                Steps = c => c.kuka_robotics_documentation.axoKrc4_v_5_x_x.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoKrc5 — Sequenced workflow",
                MaturityKey = "KUKA KRC5 v_5_x_x",
                Declaration = Declaration($"{KukaDocDir}/AxoKrc5_v_5_x_x_Showcase.st"),
                Initialization = Initialization($"{KukaDocDir}/AxoKrc5_v_5_x_x_Showcase.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "KUKA KRC5",
                        InstancePath = PlcLine, DeviceRegion = "KukaKrc5Device",
                        TemplatePath = KukaKrc5Template, TemplateRegion = "KukaKrc5Template",
                        IoSystemPath = PlcLine, IoSystemRegion = "KukaKrc5IoSystem",
                    },
                ],
                Twin = c => c.kuka_robotics_documentation.axoKrc5_v_5_x_x.ExampleRobot,
                Sequencer = c => c.kuka_robotics_documentation.axoKrc5_v_5_x_x.Sequencer,
                Steps = c => c.kuka_robotics_documentation.axoKrc5_v_5_x_x.Steps,
            },
        ],
    };
}
