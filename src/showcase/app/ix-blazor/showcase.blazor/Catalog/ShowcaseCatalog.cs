using AXOpen.Core;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components;
using showcase.Models.Showcase;
using showcase.Services;
using showcase.Services.Search;

namespace showcase.Catalog;

/// <summary>
/// The single hand-maintained list of showcase documentation pages. Every other surface —
/// page rendering, navigation, the index matrix, and search — derives from here.
/// </summary>
public static partial class ShowcaseCatalog
{
    /// <summary>Builds a RenderFragment from a raw HTML string (for concise inline intros/notes).</summary>
    internal static RenderFragment Html(string html) => builder => builder.AddMarkupContent(0, html);

    // Helpers below (Declaration / Initialization / PlcLine) are shared with descriptor partials.

    // ---- Cognex Vision -----------------------------------------------------------------------

    private const string CognexNs = "AXOpen.Components.Cognex.Vision";
    private const string PlcLine = "src/showcase/app/hwc/plc_line.hwl.yml";
    private const string ProgramCs = "src/showcase/app/ix-blazor/showcase.blazor/Program.cs";
    private const string CognexDocDir = "src/showcase/app/src/components.cognex.vision/Documentation";

    private static SnippetRef Declaration(string path) =>
        new(path, "ComponentDeclaration", "language-iecst",
            Heading: "Component declaration (ST)", RegionNote: "<ComponentDeclaration> region");

    private static SnippetRef Initialization(string path) =>
        new(path, "Initialization", "language-iecst",
            Heading: "Component Run call (ST)", RegionNote: "<Initialization> region");

    public static ShowcasePageDescriptor CognexVision { get; } = new()
    {
        Route = "/components-cognex-vision/Documentation/CognexVision",
        Title = "Cognex Vision",
        LibraryNamespace = CognexNs,
        Category = "Vision",
        Vendor = "Cognex",
        VendorUrl = "https://www.cognex.com/",
        Icon = "eye",
        BrandIcon = "eye",
        AccentColor = "#0891b2",
        Description = "Cognex In-Sight and DataMan vision systems — PROFINET and TCP/.NET integration in SIMATIC AX.",
        Tags = ["vision", "cognex", "camera", "insight", "dataman", "visionpro", "barcode"],
        NavGroup = "Vendor Components",
        NavOrder = 30,
        ContextSourcePath = $"{CognexDocDir}/CognexVision.st",
        SourceFilePaths =
        [
            $"{CognexDocDir}/CognexVision.st",
            $"{CognexDocDir}/AxoInsight_v_6_0_0.st",
            $"{CognexDocDir}/AxoDataman.st",
            $"{CognexDocDir}/AxoDataman_Secondary.st",
            $"{CognexDocDir}/AxoInsight_v_24_0_0.st",
            $"{CognexDocDir}/AxoVisionPro.st",
            $"{CognexDocDir}/AxoVisionProNet.st",
        ],
        LibraryDocs =
        [
            new("src/components.cognex.vision/docs/README.md", "README — Overview", Mono: false),
            new("src/components.cognex.vision/docs/AxoInsight_v_6_0_0_0.md", "AxoInsight v6 — Component guide", Mono: false),
            new("src/components.cognex.vision/docs/AxoDataman.md", "AxoDataman v6 — Component guide", Mono: false),
            new("src/components.cognex.vision/docs/AxoInsight_v_24_0_0.md", "AxoInsight v24 — Component guide", Mono: false),
            new("src/components.cognex.vision/docs/AxoVisionPro.md", "AxoVisionPro — Component guide", Mono: false),
            new("src/components.cognex.vision/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.cognex.vision/ctrl/src/AxoInsight/v_6_0_0/AxoInsight.st"),
            new("src/components.cognex.vision/ctrl/src/AxoInsight/v_24_0_0/AxoInsight.st"),
            new("src/components.cognex.vision/ctrl/src/AxoDataman/v_6_0_0/AxoDataman.st"),
            new("src/components.cognex.vision/ctrl/src/AxoVisionPro/AxoVisionPro.st"),
            new("src/components.cognex.vision/ctrl/src/AxoVisionProNet/AxoVisionProNet.st"),
            new("src/components.cognex.vision/src/AXOpen.Components.Cognex.Vision/AxoVisonProNet/AxoVisionProNet.TcpClient.cs"),
            new("src/components.cognex.vision/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new("src/showcase/app/hwc/library_templates/Cognex_Vision_Insight_V_6_0_0/Cognex_Vision_Insight_V_6_0_0.hwl.yml"),
            new("src/showcase/app/hwc/library_templates/cognex_vision_dataman280/Cognex_Dataman280.hwl.yml"),
            new("src/showcase/app/hwc/library_templates/cognex_vision_dataman380/Cognex_Dataman380.hwl.yml"),
            new("src/showcase/app/hwc/library_templates/cognex_vision_insight_2800/Cognex_Insight2800.hwl.yml"),
            new("src/showcase/app/hwc/library_templates/cognex_vision_pro/cognex_vision_pro.hwl.yml"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoInsight 7600",
                MaturityKey = "Cognex Insight v_24_0_0",
                Declaration = Declaration($"{CognexDocDir}/AxoInsight_v_6_0_0.st"),
                Initialization = Initialization($"{CognexDocDir}/AxoInsight_v_6_0_0.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Cognex In-Sight 7600",
                        InstancePath = PlcLine, DeviceRegion = "CognexInsight7600Device",
                        TemplatePath = "src/showcase/app/hwc/library_templates/Cognex_Vision_Insight_V_6_0_0/Cognex_Vision_Insight_V_6_0_0.hwl.yml",
                        TemplateRegion = "CognexInsight7600Template",
                        IoSystemPath = PlcLine, IoSystemRegion = "CognexInsight7600IoSystem",
                    },
                ],
                Twin = c => c.cognex_vision_documentation.axoInsight_v_6_0_0_0,
                Sequencer = c => c.cognex_vision_documentation.axoInsight_v_6_0_0_0.Sequencer,
                Steps = c => c.cognex_vision_documentation.axoInsight_v_6_0_0_0.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoDataman 280",
                MaturityKey = "Cognex Insight v_24_0_0",
                Declaration = Declaration($"{CognexDocDir}/AxoDataman.st"),
                Initialization = Initialization($"{CognexDocDir}/AxoDataman.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Cognex DataMan 280",
                        InstancePath = PlcLine, DeviceRegion = "CognexDataman280Device",
                        TemplatePath = "src/showcase/app/hwc/library_templates/cognex_vision_dataman280/Cognex_Dataman280.hwl.yml",
                        TemplateRegion = "CognexDataman280Template",
                        IoSystemPath = PlcLine, IoSystemRegion = "CognexDataman280IoSystem",
                    },
                ],
                Twin = c => c.cognex_vision_documentation.axoDataman_v_6_0_0_0,
                Sequencer = c => c.cognex_vision_documentation.axoDataman_v_6_0_0_0.Sequencer,
                Steps = c => c.cognex_vision_documentation.axoDataman_v_6_0_0_0.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoDataman 380",
                MaturityKey = "Cognex Insight v_24_0_0",
                Declaration = Declaration($"{CognexDocDir}/AxoDataman_Secondary.st"),
                Initialization = Initialization($"{CognexDocDir}/AxoDataman_Secondary.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Cognex DataMan 380",
                        InstancePath = PlcLine, DeviceRegion = "CognexDataman380Device",
                        TemplatePath = "src/showcase/app/hwc/library_templates/cognex_vision_dataman380/Cognex_Dataman380.hwl.yml",
                        TemplateRegion = "CognexDataman380Template",
                        IoSystemPath = PlcLine, IoSystemRegion = "CognexDataman380IoSystem",
                    },
                ],
                Twin = c => c.cognex_vision_documentation.axoDataman_v_6_0_0_0_2,
                Sequencer = c => c.cognex_vision_documentation.axoDataman_v_6_0_0_0_2.Sequencer,
                Steps = c => c.cognex_vision_documentation.axoDataman_v_6_0_0_0_2.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoInsight 2800",
                MaturityKey = "Cognex Insight v_24_0_0",
                Declaration = Declaration($"{CognexDocDir}/AxoInsight_v_24_0_0.st"),
                Initialization = Initialization($"{CognexDocDir}/AxoInsight_v_24_0_0.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Cognex In-Sight 2800",
                        InstancePath = PlcLine, DeviceRegion = "CognexInsight2800Device",
                        TemplatePath = "src/showcase/app/hwc/library_templates/cognex_vision_insight_2800/Cognex_Insight2800.hwl.yml",
                        TemplateRegion = "CognexInsight2800Template",
                        IoSystemPath = PlcLine, IoSystemRegion = "CognexInsight2800IoSystem",
                    },
                ],
                Twin = c => c.cognex_vision_documentation.axoInsight_v_24_0_0,
                Sequencer = c => c.cognex_vision_documentation.axoInsight_v_24_0_0.Sequencer,
                Steps = c => c.cognex_vision_documentation.axoInsight_v_24_0_0.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoVisionPro",
                MaturityKey = "Cognex Insight v_24_0_0",
                Declaration = Declaration($"{CognexDocDir}/AxoVisionPro.st"),
                Initialization = Initialization($"{CognexDocDir}/AxoVisionPro.st"),
                Hardware =
                [
                    new HardwareRef
                    {
                        Label = "Cognex VisionPro",
                        InstancePath = PlcLine, DeviceRegion = "CognexVisionProDevice",
                        TemplatePath = "src/showcase/app/hwc/library_templates/cognex_vision_pro/cognex_vision_pro.hwl.yml",
                        TemplateRegion = "CognexVisionProTemplate",
                        IoSystemPath = PlcLine, IoSystemRegion = "CognexVisionProIoSystem",
                    },
                ],
                Twin = c => c.cognex_vision_documentation.axoVisionPro,
                Sequencer = c => c.cognex_vision_documentation.axoVisionPro.Sequencer,
                Steps = c => c.cognex_vision_documentation.axoVisionPro.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoVisionProNet",
                // The Cognex vision library is tracked as one maturity entry; align with the other
                // five components (the original "Cognex VisionPro Net" key had no row, so the badge
                // silently fell back to the red/red/red default).
                MaturityKey = "Cognex Insight v_24_0_0",
                Declaration = Declaration($"{CognexDocDir}/AxoVisionProNet.st"),
                Initialization = Initialization($"{CognexDocDir}/AxoVisionProNet.st"),
                ExtraSnippets =
                [
                    new($"{CognexDocDir}/AxoVisionProNet.st", "VisionProNetCommissioning", "language-iecst",
                        Heading: "Commissioning task (ST)", RegionNote: "<VisionProNetCommissioning> region (manual-mode only)"),
                ],
                Intro = Html(
                    "<div class=\"rounded-alert border border-border bg-background-light p-3 text-sm text-text-light\">" +
                    "<span class=\"font-medium text-text\">TCP / .NET alternative.</span> " +
                    "AxoVisionProNet talks to the Vision PC over a TCP socket from its .NET twin &mdash; no PROFINET hardware. " +
                    "Each operation is an <span class=\"font-mono\">AxoRemoteTask</span> (Trigger, SetRecipe, InspectionResult, " +
                    "TriggerWithSpecificData, ReceiveSpecificData, SendSpecificDataAndTypes). " +
                    "The socket is opened once from <span class=\"font-mono\">Program.cs</span>.</div>"),
                CustomTabs =
                [
                    new CustomTab
                    {
                        Title = ".NET connection",
                        Snippet = new(ProgramCs, "AxoVisionProNetInitialize", "language-csharp",
                            RegionNote: "<AxoVisionProNetInitialize> region"),
                        Note = Html(
                            "<div class=\"rounded-alert border border-border bg-background-light p-3 text-sm text-text-light\">" +
                            "Remote-task handlers self-initialize in the twin's <span class=\"font-mono\">PostConstruct</span>, " +
                            "so no per-task <span class=\"font-mono\">Initialize()</span> wiring is needed. Until the TCP client is " +
                            "connected, the PLC tasks report <span class=\"font-mono\">HasRemoteException</span> &mdash; exercise the " +
                            "Error-recovery step to clear them.</div>"),
                    },
                ],
                Twin = c => c.cognex_vision_documentation.axoVisionProNet,
                Sequencer = c => c.cognex_vision_documentation.axoVisionProNet.Sequencer,
                Steps = c => c.cognex_vision_documentation.axoVisionProNet.Steps,
            },
        ],
    };

    // ---- Dukane Welders ----------------------------------------------------------------------

    private const string DukaneDocDir = "src/showcase/app/src/components.dukane.welders/Documentation";
    private const string DukaneTemplate = "src/showcase/app/hwc/library_templates/dukane_welders_iq_series/DukaneIqSeriesWelder.hwl.yml";

    private static HardwareRef DukaneHardware => new()
    {
        Label = "Dukane IQ-Series Welder",
        InstancePath = PlcLine, DeviceRegion = "DukaneIqWelderDevice",
        TemplatePath = DukaneTemplate, TemplateRegion = "DukaneIqWelderTemplate",
        IoSystemPath = PlcLine, IoSystemRegion = "DukaneIqWelderIoSystem",
    };

    public static ShowcasePageDescriptor DukaneWelders { get; } = new()
    {
        Route = "/components-dukane-welders/Documentation/DukaneWelders",
        Title = "Dukane Welders",
        LibraryNamespace = "AXOpen.Components.Dukane.Welders",
        Category = "Welders",
        Vendor = "Dukane",
        VendorUrl = "https://www.dukane.com/",
        Icon = "bolt",
        BrandIcon = "bolt",
        AccentColor = "#ea580c",
        Description = "Dukane IQ-Series ultrasonic welders over PROFINET in SIMATIC AX.",
        Tags = ["welder", "dukane", "ultrasonic", "iq-series", "welding"],
        NavGroup = "Vendor Components",
        NavOrder = 35,
        ContextSourcePath = $"{DukaneDocDir}/DukaneWelders.st",
        SourceFilePaths =
        [
            $"{DukaneDocDir}/DukaneWelders.st",
            $"{DukaneDocDir}/Axo_IQ_SeriesWelder_Showcase.st",
            $"{DukaneDocDir}/Axo_IQ_SeriesWelder_Showcase2.st",
        ],
        LibraryDocs =
        [
            new("src/components.dukane.welders/docs/README.md", "README — Overview", Mono: false),
            new("src/components.dukane.welders/docs/Axo_IQ_SeriesWelder.md", "IQ Series Welder — Component reference", Mono: false),
            new("src/components.dukane.welders/docs/TROUBLES.md", "Troubleshooting", Mono: false),
        ],
        LibrarySources =
        [
            new("src/components.dukane.welders/ctrl/src/AxoIQSeriesWelder/Axo_IQ_SeriesWelder.st"),
            new("src/components.dukane.welders/ctrl/apax.yml"),
        ],
        HardwareAssets =
        [
            new("src/components.dukane.welders/ctrl/assets/dukane_welders_iq_series/DukaneIqSeriesWelder.hwl.yml"),
            new("src/components.dukane.welders/ctrl/assets/dukane_welders_iq_series/GSDML-V2.31-DUKANE-IQ-20190110.xml", "GSDML — Dukane IQ"),
        ],
        Components =
        [
            new ComponentShowcase
            {
                DisplayName = "AxoIQ Welder (Example 1)",
                MaturityKey = "Dukane Welders",
                Declaration = Declaration($"{DukaneDocDir}/Axo_IQ_SeriesWelder_Showcase.st"),
                Initialization = Initialization($"{DukaneDocDir}/Axo_IQ_SeriesWelder_Showcase.st"),
                Hardware = [DukaneHardware],
                Twin = c => c.dukane_welders_documentation.axo_IQ_SeriesWelder.Dukane_IQ_SeriesWelder,
                Sequencer = c => c.dukane_welders_documentation.axo_IQ_SeriesWelder.Sequencer,
                Steps = c => c.dukane_welders_documentation.axo_IQ_SeriesWelder.Steps,
            },
            new ComponentShowcase
            {
                DisplayName = "AxoIQ Welder (Example 2)",
                MaturityKey = "Dukane Welders",
                Declaration = Declaration($"{DukaneDocDir}/Axo_IQ_SeriesWelder_Showcase2.st"),
                Initialization = Initialization($"{DukaneDocDir}/Axo_IQ_SeriesWelder_Showcase2.st"),
                Hardware = [DukaneHardware],
                Twin = c => c.dukane_welders_documentation.axo_IQ_SeriesWelder_2.Dukane_IQ_SeriesWelder,
                Sequencer = c => c.dukane_welders_documentation.axo_IQ_SeriesWelder_2.Sequencer,
                Steps = c => c.dukane_welders_documentation.axo_IQ_SeriesWelder_2.Steps,
            },
        ],
    };

    // ---- Catalog -----------------------------------------------------------------------------

    /// <summary>Every showcase page, in catalog order. The single source of truth.</summary>
    public static IReadOnlyList<ShowcasePageDescriptor> All { get; } =
    [
        CognexVision,
        DukaneWelders,
        AbbRobotics,
        KukaRobotics,
        MitsubishiRobotics,
        UrRobotics,
        KeyenceVision,
        ZebraVision,
        BalluffIdentification,
        SiemIdentification,
        SiemCommunication,
        DesoutterTightening,
        RexrothTightening,
        RexrothDrives,
        FestoDrives,
        RexrothPress,
        DrivesShowcase,
        ElementsShowcase,
        PneumaticsShowcase,
        ComponentsAbstractionsShowcase,
        RoboticsShowcase,
        AbstractionsShowcase,
        InspectorsShowcase,
        IoShowcase,
        ProbersShowcase,
        Simatic1500Showcase,
        TimersShowcase,
        UtilsShowcase,
        CoreAxoTask,
        CoreAxoSequencer,
        CoreAxoComponent,
        CoreAxoMessaging,
        CoreAxoIncidentBar,
        CoreAxoLogger,
        CoreAxoDialogs,
        DataExchange,
        VisualComposerPage,
        SecurityPage,
    ];

    /// <summary>Projects a descriptor to the search/content-index entry shape.</summary>
    public static SearchablePageEntry ToSearchableEntry(ShowcasePageDescriptor d) => new()
    {
        Route = d.Route,
        PageTitle = d.Title,
        LibraryNamespace = d.LibraryNamespace,
        Category = d.Category,
        Vendor = d.Vendor,
        Description = d.Description,
        Icon = d.Icon,
        Tags = d.Tags,
        SourceFilePaths = d.SourceFilePaths,
    };

    /// <summary>
    /// Dev-time invariant check: every descriptor has a route/title (and source paths when it uses
    /// the layout), and every component maturity key resolves. Throws on the first batch of errors.
    /// </summary>
    public static void Validate(ComponentMaturityService maturity)
    {
        var errors = new List<string>();
        var warnings = new List<string>();
        var routes = new HashSet<string>();

        foreach (var d in All)
        {
            var id = string.IsNullOrWhiteSpace(d.Title) ? d.Route : d.Title;

            if (string.IsNullOrWhiteSpace(d.Route)) errors.Add($"Descriptor '{id}' has an empty Route");
            else if (!routes.Add(d.Route)) errors.Add($"Duplicate route '{d.Route}'");

            if (string.IsNullOrWhiteSpace(d.Title)) errors.Add($"Descriptor at '{d.Route}' has an empty Title");
            if (d.UsesLayout && d.SourceFilePaths.Length == 0)
                errors.Add($"Descriptor '{id}' uses the layout but has no SourceFilePaths");

            foreach (var c in d.Components)
            {
                // Maturity gaps are surfaced loudly but are NOT fatal: COMPONENTS_MATURITY.md does
                // not track every component variant, and the badge falls back to the lowest level.
                if (!maturity.HasMaturity(c.MaturityKey))
                    warnings.Add($"Descriptor '{id}' component '{c.DisplayName}': MaturityKey '{c.MaturityKey}' is not in COMPONENTS_MATURITY.md (badge falls back to the lowest level)");
            }
        }

        if (warnings.Count > 0)
            Console.Error.WriteLine("ShowcaseCatalog maturity warnings:" + Environment.NewLine + " - "
                + string.Join(Environment.NewLine + " - ", warnings));

        if (errors.Count > 0)
            throw new InvalidOperationException(
                "ShowcaseCatalog validation failed:" + Environment.NewLine + " - " + string.Join(Environment.NewLine + " - ", errors));
    }
}
