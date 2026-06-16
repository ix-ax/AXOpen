using showcase.Models.Showcase;

namespace showcase.Catalog;

// Bespoke pages (Core / Data / Security / Visual Composer) keep their own hand-written markup.
// They appear in the catalog as `UsesLayout = false` entries purely so navigation, the index, and
// search cover them — the layout never renders them.
public static partial class ShowcaseCatalog
{
    // ---- Core framework ----------------------------------------------------------------------

    public static ShowcasePageDescriptor CoreAxoTask { get; } = new()
    {
        Route = "/core/AxoTask",
        Title = "AxoTask",
        LibraryNamespace = "AXOpen.Core",
        Category = "Core",
        Icon = "play",
        Description = "Task execution for PLC programs. Covers AxoTask, AxoMomentaryTask, AxoToggleTask, and AxoRemoteTask.",
        Tags = ["task", "fire and forget", "momentary", "toggle", "remote task", "control flow", "error", "aborted", "state", "disabled"],
        NavGroup = "Core", NavOrder = 1, UsesLayout = false,
        SourceFilePaths =
        [
            "src/showcase/app/src/core/AXOpen.AxoTask/AxoTaskDocuExample.st",
            "src/showcase/app/src/core/AXOpen.AxoTask/AxoTaskExample.st",
            "src/showcase/app/src/core/AXOpen.AxoTask/AxoTaskErrorExample.st",
            "src/showcase/app/src/core/AXOpen.AxoTask/AxoTaskAbortedExample.st",
            "src/showcase/app/src/core/AXOpen.AxoMomentaryTask/AxoMomentaryTaskDocuExample.st",
            "src/showcase/app/src/core/AXOpen.AxoToggleTask/AxoToggleTaskDocuExample.st",
            "src/showcase/app/src/core/AXOpen.AxoRemoteTask/AxoRemoteTaskDocuExample.st",
            "src/core/docs/AxoTask.md",
            "src/core/docs/AxoMomentaryTask.md",
            "src/core/docs/AxoToggleTask.md",
            "src/core/docs/AxoRemoteTask.md",
        ],
    };

    public static ShowcasePageDescriptor CoreAxoSequencer { get; } = new()
    {
        Route = "/core/AxoSequencer",
        Title = "AxoSequencer",
        LibraryNamespace = "AXOpen.Core",
        Category = "Core",
        Icon = "queue-list",
        Description = "Sequencer and step coordination. Triggers steps in order with step-by-step and continuous modes, analytics, and AxoSequencerContainer.",
        Tags = ["sequencer", "step", "sequence", "coordination", "state machine"],
        NavGroup = "Core", NavOrder = 2, UsesLayout = false,
        SourceFilePaths =
        [
            "src/showcase/app/src/core/AXOpen.AxoSequencer/AxoSequencerDocuExample.st",
            "src/showcase/app/src/core/AXOpen.AxoSequencer/AxoSequencerExample.st",
            "src/showcase/app/src/core/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st",
            "src/core/docs/AxoSequencer.md",
            "src/core/docs/AxoSequencerContainer.md",
            "src/core/docs/AxoStep.md",
        ],
    };

    public static ShowcasePageDescriptor CoreAxoComponent { get; } = new()
    {
        Route = "/core/AxoComponent",
        Title = "AxoComponent",
        LibraryNamespace = "AXOpen.Core",
        Category = "Core",
        Icon = "puzzle-piece",
        Description = "Base class for all AXOpen components. Standardized lifecycle, automatic UI rendering with header/detail sections, and a consistent restore pattern.",
        Tags = ["component", "base class", "lifecycle", "restore", "header", "detail"],
        NavGroup = "Core", NavOrder = 3, UsesLayout = false,
        SourceFilePaths =
        [
            "src/showcase/app/src/core/AXOpen.AxoComponent/AxoComponentExample.st",
            "src/showcase/app/src/core/AXOpen.AxoComponent/AxoComponentHeaderOnlyExample.st",
            "src/core/docs/AxoComponent.md",
            "src/core/ctrl/src/AxoComponent/AxoComponent.st",
        ],
    };

    public static ShowcasePageDescriptor CoreAxoMessaging { get; } = new()
    {
        Route = "/core/AxoMessaging",
        Title = "AxoMessaging",
        LibraryNamespace = "AXOpen.Core",
        Category = "Core",
        Icon = "chat-bubble-left-right",
        Description = "AxoMessenger provides categorized PLC messages with acknowledgement. AxoTextList maps message codes to human-readable text.",
        Tags = ["messaging", "messenger", "text list", "diagnostics", "acknowledgement"],
        NavGroup = "Core", NavOrder = 4, UsesLayout = false,
        SourceFilePaths =
        [
            "src/showcase/app/src/core/AXOpen.Messaging/AxoStaticMessengerDocuExample.st",
            "src/showcase/app/src/core/AXOpen.TextList/AxoTextListExample.st",
            "src/core/docs/AxoMessenger.md",
            "src/core/docs/AxoTextList.md",
        ],
    };

    public static ShowcasePageDescriptor CoreAxoIncidentBar { get; } = new()
    {
        Route = "/core/AxoIncidentBar",
        Title = "AxoIncidentBar",
        LibraryNamespace = "AXOpen.Core",
        Category = "Core",
        Icon = "bell-alert",
        Description = "AxoCauseAnalyzer ranks active Error+ messengers by severity, burst-root, topology, and ack state; AxoIncidentBarView renders the top probable cause as a persistent bar.",
        Tags = ["incident", "alarm", "probable cause", "root cause", "cause analyzer", "diagnostics", "topology", "operator"],
        NavGroup = "Core", NavOrder = 5, UsesLayout = false,
        SourceFilePaths =
        [
            "src/showcase/app/src/core/AXOpen.Messaging/AxoIncidentBarExample.st",
            "src/core/src/AXOpen.Core/AxoMessenger/Static/AxoCauseAnalyzer.cs",
            "src/core/src/AXOpen.Core.Blazor/AxoMessenger/Static/AxoIncidentBarView.razor",
        ],
    };

    public static ShowcasePageDescriptor CoreAxoLogger { get; } = new()
    {
        Route = "/core/AxoLogger",
        Title = "AxoLogger",
        LibraryNamespace = "AXOpen.Core",
        Category = "Core",
        Icon = "document-magnifying-glass",
        Description = "PLC-to-.NET logging bridge. Log entries are queued on the PLC with severity, sender identity, and message codes, then dequeued asynchronously to Serilog.",
        Tags = ["logger", "logging", "serilog", "dequeue", "diagnostics", "log level"],
        NavGroup = "Core", NavOrder = 6, UsesLayout = false,
        SourceFilePaths =
        [
            "src/showcase/app/src/core/AXOpen.Logging/AxoLoggerDocuExample.st",
            "src/core/src/AXOpen.Core/AxoLogger/AxoLogger.cs",
            "src/core/docs/AxoLogger.md",
        ],
    };

    public static ShowcasePageDescriptor CoreAxoDialogs { get; } = new()
    {
        Route = "/core/AxoDialogs",
        Title = "AxoDialogs",
        LibraryNamespace = "AXOpen.Core",
        Category = "Core",
        Icon = "chat-bubble-bottom-center-text",
        Description = "Interactive user prompts triggered from PLC code with configurable buttons and types. AxoAlert shows timed banners; both integrate via SignalR for real-time delivery.",
        Tags = ["dialog", "alert", "prompt", "notification", "SignalR", "user interaction"],
        NavGroup = "Core", NavOrder = 7, UsesLayout = false,
        SourceFilePaths =
        [
            "src/showcase/app/src/core/AXOpen.Dialogs/AxoDialogExamples.st",
            "src/showcase/app/src/core/AXOpen.Dialogs/AxoAlertDocuExample.st",
            "src/core/docs/AxoDialog.md",
            "src/core/docs/AxoAlertDialog.md",
        ],
    };

    // ---- Data management ---------------------------------------------------------------------

    public static ShowcasePageDescriptor DataExchange { get; } = new()
    {
        Route = "/data/DataExchange",
        Title = "Data Exchange",
        LibraryNamespace = "AXOpen.Data",
        Category = "Data",
        Icon = "arrows-right-left",
        Description = "CRUD operations between PLC and .NET repositories: standard exchange, fragment-based exchange, persistent storage, and distributed data patterns.",
        Tags = ["data", "CRUD", "repository", "persistence", "fragment", "distributed", "exchange"],
        NavGroup = "Data", NavOrder = 1, UsesLayout = false,
        SourceFilePaths =
        [
            "src/showcase/app/src/data/AxoDataExchange/AxoDataExchangeExample.st",
            "src/showcase/app/src/data/AxoDataFragmentExchange/AxoDataFragmentExchangeExample.st",
            "src/showcase/app/src/data/AxoDataPersistentExchange/AxoDataPersistentExchangeExample.st",
            "src/showcase/app/src/data/AxoDataDistributed/AxoDataDistributedExample.st",
            "src/data/docs/AxoDataExchange.md",
            "src/data/docs/DistributedDataExchange.md",
        ],
    };

    // ---- Administration (kept as static nav items; here for index + search only) -------------

    public static ShowcasePageDescriptor VisualComposerPage { get; } = new()
    {
        Route = "/VisualComposer",
        Title = "Visual Composer",
        LibraryNamespace = "AXOpen.VisualComposer",
        Category = "Visual Composer",
        Icon = "eye",
        Description = "Drag-and-drop HMI composition surface for assembling AXOpen views without code.",
        Tags = ["visual composer", "HMI", "drag and drop", "layout", "designer"],
        NavGroup = "Administration", NavOrder = 1, ShowInNav = false, UsesLayout = false,
    };

    public static ShowcasePageDescriptor SecurityPage { get; } = new()
    {
        Route = "/Security",
        Title = "Security",
        LibraryNamespace = "AXOpen.Security",
        Category = "Security",
        Icon = "lock-closed",
        Description = "User and role management with role-based access control for the showcase application.",
        Tags = ["security", "authentication", "authorization", "user", "role", "RBAC"],
        NavGroup = "Administration", NavOrder = 2, ShowInNav = false, UsesLayout = false,
    };
}
