namespace showcase.Services.Search;

/// <summary>
/// Static registry of all searchable showcase pages.
/// When adding a new showcase page, add a corresponding entry here
/// including SourceFilePaths for full-text content search.
/// </summary>
public static class ShowcasePageRegistry
{
    public static List<SearchablePageEntry> GetAllPages() =>
    [
        // ── Core Framework ──────────────────────────────────────────────
        new()
        {
            Route = "/core/AxoTask",
            PageTitle = "AxoTask",
            LibraryNamespace = "AXOpen.Core",
            Category = "Core",
            Description = "Task execution for PLC programs. Covers AxoTask, AxoMomentaryTask, AxoToggleTask, and AxoRemoteTask.",
            Icon = "play",
            Tags = ["task", "fire and forget", "momentary", "toggle", "remote task", "control flow"],
            SourceFilePaths = [
                "src/showcase/app/src/core/AXOpen.AxoTask/AxoTaskDocuExample.st",
                "src/showcase/app/src/core/AXOpen.AxoTask/AxoTaskExample.st",
                "src/showcase/app/src/core/AXOpen.AxoMomentaryTask/AxoMomentaryTaskDocuExample.st",
                "src/showcase/app/src/core/AXOpen.AxoToggleTask/AxoToggleTaskDocuExample.st",
                "src/showcase/app/src/core/AXOpen.AxoRemoteTask/AxoRemoteTaskDocuExample.st",
                "src/core/ctrl/src/AxoTask/AxoTask.st",
                "src/core/ctrl/src/AxoMomentaryTask/AxoMomentaryTask.st",
                "src/core/ctrl/src/AxoToggleTask/AxoToggleTask.st",
                "src/core/ctrl/src/AxoRemoteTask/AxoRemoteTask.st",
                "src/core/src/AXOpen.Core/AxoRemoteTask/AxoRemoteTask.cs",
                "src/showcase/app/ix-blazor/showcase.blazor/Program.cs",
                "src/core/docs/AxoTask.md",
                "src/core/docs/AxoMomentaryTask.md",
                "src/core/docs/AxoToggleTask.md",
                "src/core/docs/AxoRemoteTask.md",
                "src/core/docs/AxoBoolArray.md",
                "src/core/docs/AxoByteArray.md",
                "src/core/docs/AxoStep.md",
                "src/core/docs/TROUBLES.md",
                "src/core/docs/CHANGELOG.md",
            ]
        },
        new()
        {
            Route = "/core/AxoSequencer",
            PageTitle = "AxoSequencer",
            LibraryNamespace = "AXOpen.Core",
            Category = "Core",
            Description = "Sequencer and step coordination. Triggers steps in order with step-by-step and continuous modes, analytics, and AxoSequencerContainer.",
            Icon = "queue-list",
            Tags = ["sequencer", "step", "sequence", "coordination", "state machine"],
            SourceFilePaths = [
                "src/showcase/app/src/core/AXOpen.AxoSequencer/AxoSequencerDocuExample.st",
                "src/showcase/app/src/core/AXOpen.AxoSequencer/AxoSequencerExample.st",
                "src/showcase/app/src/core/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st",
                "src/core/docs/AxoSequencer.md",
                "src/core/docs/AxoSequencerContainer.md",
                "src/core/docs/AxoStep.md",
                "src/core/docs/TROUBLES.md",
                "src/core/docs/CHANGELOG.md",
            ]
        },
        new()
        {
            Route = "/core/AxoComponent",
            PageTitle = "AxoComponent",
            LibraryNamespace = "AXOpen.Core",
            Category = "Core",
            Description = "Base class for all AXOpen components. Provides standardized lifecycle management, automatic UI rendering with header/detail sections, and a consistent restore pattern.",
            Icon = "puzzle-piece",
            Tags = ["component", "base class", "lifecycle", "restore", "header", "detail"],
            SourceFilePaths = [
                "src/showcase/app/src/core/AXOpen.AxoComponent/AxoComponentExample.st",
                "src/showcase/app/src/core/AXOpen.AxoComponent/AxoComponentHeaderOnlyExample.st",
                "src/core/docs/AxoComponent.md",
                "src/core/ctrl/src/AxoComponent/AxoComponent.st",
                "src/core/docs/TROUBLES.md",
                "src/core/docs/CHANGELOG.md",
            ]
        },
        new()
        {
            Route = "/core/AxoMessaging",
            PageTitle = "AxoMessaging",
            LibraryNamespace = "AXOpen.Core",
            Category = "Core",
            Description = "AxoMessenger provides categorized PLC messages with acknowledgement. AxoTextList maps message codes to human-readable text.",
            Icon = "chat-bubble-left-right",
            Tags = ["messaging", "messenger", "text list", "diagnostics", "acknowledgement"],
            SourceFilePaths = [
                "src/showcase/app/src/core/AXOpen.Messaging/AxoStaticMessengerDocuExample.st",
                "src/showcase/app/src/core/AXOpen.TextList/AxoTextListExample.st",
                "src/core/docs/AxoMessenger.md",
                "src/core/docs/AxoTextList.md",
                "src/core/docs/TROUBLES.md",
                "src/core/docs/CHANGELOG.md",
            ]
        },
        new()
        {
            Route = "/core/AxoLogger",
            PageTitle = "AxoLogger",
            LibraryNamespace = "AXOpen.Core",
            Category = "Core",
            Description = "PLC-to-.NET logging bridge. Log entries are queued on the PLC with severity levels, sender identity, and message codes, then dequeued asynchronously to Serilog.",
            Icon = "document-magnifying-glass",
            Tags = ["logger", "logging", "serilog", "dequeue", "diagnostics", "log level"],
            SourceFilePaths = [
                "src/showcase/app/src/core/AXOpen.Logging/AxoLoggerDocuExample.st",
                "src/core/src/AXOpen.Core/AxoLogger/AxoLogger.cs",
                "src/core/ctrl/src/AxoLogger/AxoLogger.st",
                "src/showcase/app/ix-blazor/showcase.blazor/Program.cs",
                "src/core/docs/AxoLogger.md",
                "src/core/docs/TROUBLES.md",
                "src/core/docs/CHANGELOG.md",
            ]
        },
        new()
        {
            Route = "/core/AxoDialogs",
            PageTitle = "AxoDialogs",
            LibraryNamespace = "AXOpen.Core",
            Category = "Core",
            Description = "Interactive user prompts triggered from PLC code with configurable buttons and types. AxoAlert shows timed notification banners. Both integrate via SignalR for real-time browser delivery.",
            Icon = "chat-bubble-bottom-center-text",
            Tags = ["dialog", "alert", "prompt", "notification", "SignalR", "user interaction"],
            SourceFilePaths = [
                "src/showcase/app/src/core/AXOpen.Dialogs/AxoDialogExamples.st",
                "src/showcase/app/src/core/AXOpen.Dialogs/AxoDialogTest.st",
                "src/showcase/app/src/core/AXOpen.Dialogs/AxoAlertDocuExample.st",
                "src/showcase/app/ix-blazor/showcase.blazor/Program.cs",
                "src/core/docs/AxoDialog.md",
                "src/core/docs/AxoAlertDialog.md",
                "src/core/docs/TROUBLES.md",
                "src/core/docs/CHANGELOG.md",
            ]
        },

        // ── Data Management ─────────────────────────────────────────────
        new()
        {
            Route = "/data/DataExchange",
            PageTitle = "Data Exchange",
            LibraryNamespace = "AXOpen.Data",
            Category = "Data",
            Description = "CRUD operations between PLC and .NET repositories. Covers standard exchange, fragment-based exchange, persistent storage, and distributed data patterns.",
            Icon = "arrows-right-left",
            Tags = ["data", "CRUD", "repository", "persistence", "fragment", "distributed", "exchange"],
            SourceFilePaths = [
                "src/showcase/app/src/data/AxoDataExchange/AxoDataExchangeExample.st",
                "src/showcase/app/src/data/AxoDataFragmentExchange/AxoDataFragmentExchangeExample.st",
                "src/showcase/app/src/data/AxoDataPersistentExchange/AxoDataPersistentExchangeExample.st",
                "src/showcase/app/src/data/AxoDataDistributed/AxoDataDistributedExample.st",
                "src/data/docs/AxoDataExchange.md",
                "src/data/docs/AxoDataFragmentExchange.md",
                "src/data/docs/AxoDataPersistentExchange.md",
                "src/data/docs/DistributedDataExchange.md",
            ]
        },

        // ── Generic Components ──────────────────────────────────────────
        new()
        {
            Route = "/components-abstractions/Documentation/ComponentsAbstractionsShowcase",
            PageTitle = "Components Abstractions",
            LibraryNamespace = "AXOpen.Components.Abstractions",
            Category = "Components",
            Description = "Standard interface contracts for all AXOpen components: IAxoDrive, IAxoRobotics, IAxoCodeReader, IAxoVisionSensor, IAxo_Power, and shared data types.",
            Icon = "document-text",
            Tags = ["abstractions", "interface", "contract", "IAxoDrive", "IAxoRobotics", "IAxoCodeReader", "IAxoVisionSensor"],
            SourceFilePaths = [
                "src/showcase/app/src/components.abstractions/ComponentsAbstractionsShowcase.st",
                "src/components.abstractions/docs/README.md",
                "src/components.abstractions/docs/TROUBLES.md",
                "src/components.abstractions/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/components-drives/Documentation/DrivesShowcase",
            PageTitle = "Drives",
            LibraryNamespace = "AXOpen.Components.Drives",
            Category = "Components",
            Description = "Abstract drive component providing a vendor-neutral foundation for motion control in SIMATIC AX.",
            Icon = "document-text",
            Tags = ["drive", "motion", "motor", "servo", "axis", "abstract"],
            SourceFilePaths = [
                "src/showcase/app/src/components.drives/Documentation/Drives.st",
                "src/showcase/app/src/components.drives/Documentation/AxoDriveExample_Showcase.st",
                "src/components.drives/docs/README.md",
                "src/components.drives/docs/AxoDriveExample_Showcase.md",
                "src/components.drives/docs/AxoDriveExample_Showcase2.md",
                "src/components.drives/docs/TROUBLES.md",
                "src/components.drives/ctrl/src/AxoDrives/AxoDrive.st",
                "src/components.drives/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/components-elements/Documentation/ElementsShowcase",
            PageTitle = "Elements",
            LibraryNamespace = "AXOpen.Components.Elements",
            Category = "Components",
            Description = "Basic I/O building blocks — digital inputs/outputs, analog inputs/outputs, signal tower, and rotary indexing table.",
            Icon = "document-text",
            Tags = ["elements", "digital", "analog", "signal tower", "rotary", "indexing table", "backlit button", "I/O"],
            SourceFilePaths = [
                "src/showcase/app/src/components.elements/Documentation/Elements.st",
                "src/components.elements/docs/README.md",
                "src/components.elements/docs/AxoDi.md",
                "src/components.elements/docs/AxoDo.md",
                "src/components.elements/docs/AxoAi.md",
                "src/components.elements/docs/AxoAo.md",
                "src/components.elements/docs/AxoBacklitButton.md",
                "src/components.elements/docs/AxoSignalTower.md",
                "src/components.elements/docs/AxoRotaryIndexingTable.md",
                "src/components.elements/docs/HOWTO.md",
                "src/components.elements/docs/TROUBLES.md",
                "src/components.elements/docs/CHANGELOG.md",
                "src/components.elements/ctrl/src/AxoDi/AxoDi.st",
                "src/components.elements/ctrl/src/AxoDo/AxoDo.st",
                "src/components.elements/ctrl/src/AxoAi/AxoAi.st",
                "src/components.elements/ctrl/src/AxoAo/AxoAo.st",
                "src/components.elements/ctrl/src/AxoBacklitButton/AxoBacklitButton.st",
                "src/components.elements/ctrl/src/AxoSignalTower/AxoSignalTower.st",
                "src/components.elements/ctrl/src/AxoRotaryIndexingTable/AxoRotaryIndexingTable.st",
                "src/components.elements/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/components-pneumatics/Documentation/PneumaticsShowcase",
            PageTitle = "Pneumatics",
            LibraryNamespace = "AXOpen.Components.Pneumatics",
            Category = "Components",
            Description = "AxoCylinder component for controlling pneumatic cylinders with move-in/move-out/stop actions, sensor feedback, and configurable suspend/abort conditions.",
            Icon = "document-text",
            Tags = ["pneumatics", "cylinder", "actuator", "valve", "move-in", "move-out"],
            SourceFilePaths = [
                "src/showcase/app/src/components.pneumatics/Documentation/PneumaticsShowcase.st",
                "src/showcase/app/src/components.pneumatics/Documentation/AxoCylinder.st",
                "src/showcase/app/hwc/plc_line.hwl.yml",
                "src/showcase/app/hwc/library_templates/AventicsPneumatics/AventicsPneumaticsAES.hwl.yml",
                "src/components.pneumatics/docs/README.md",
                "src/components.pneumatics/docs/AXOCYLINDER.md",
                "src/components.pneumatics/docs/HOWTO.md",
                "src/components.pneumatics/docs/TROUBLES.md",
                "src/components.pneumatics/ctrl/src/AxoCylinder.st",
                "src/components.pneumatics/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/components-robotics/Documentation/RoboticsShowcase",
            PageTitle = "Robotics",
            LibraryNamespace = "AXOpen.Components.Robotics",
            Category = "Components",
            Description = "Generic robotics base library providing abstract interfaces and common types for vendor-specific robot integrations.",
            Icon = "document-text",
            Tags = ["robotics", "robot", "base", "abstract", "motion"],
            SourceFilePaths = [
                "src/showcase/app/src/components.robotics/Documentation/Robotics.st",
                "src/components.robotics/docs/README.md",
                "src/components.robotics/docs/RoboticsUtilities.md",
                "src/components.robotics/docs/VendorImplementations.md",
                "src/components.robotics/docs/TROUBLES.md",
                "src/components.robotics/ctrl/src/AxoRobotics/AxoRobot_Status.st",
                "src/components.robotics/ctrl/src/AxoRobotics/CalculateDistance.st",
                "src/components.robotics/ctrl/src/AxoRobotics/CoordinatesAreNearlyEqual.st",
                "src/components.robotics/ctrl/src/AxoRobotics/IsNearlyEqual.st",
                "src/components.robotics/ctrl/apax.yml",
            ]
        },

        // ── Vendor Components: Robotics ─────────────────────────────────
        new()
        {
            Route = "/components-abb-robotics/Documentation/AbbRobotics",
            PageTitle = "ABB Robotics",
            LibraryNamespace = "AXOpen.Components.Abb.Robotics",
            Category = "Vendor Components",
            Vendor = "ABB",
            Description = "Practical reference for integrating ABB robots in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["ABB", "robot", "robotics", "IRB"],
            SourceFilePaths = [
                "src/showcase/app/src/components.abb.robotics/Documentation/AbbRobotics.st",
                "src/showcase/app/src/components.abb.robotics/Documentation/AxoIrc5_v_1_x_x_Showcase.st",
                "src/showcase/app/src/components.abb.robotics/Documentation/AxoOmnicore_v_1_x_x_Showcase.st",
                "src/showcase/app/hwc/library_templates/abb_robotics_irc5/abb_irc5_robot_in64b_out64b.hwl.yml",
                "src/showcase/app/hwc/library_templates/abb_robotics_omnicore/abb_omnicore_robot_in64b_out64b.hwl.yml",
                "src/components.abb.robotics/docs/README.md",
                "src/components.abb.robotics/docs/AxoIrc5_v_1_x_x.md",
                "src/components.abb.robotics/docs/AxoOmnicore_v_1_x_x.md",
                "src/components.abb.robotics/docs/TROUBLES.md",
                "src/components.abb.robotics/ctrl/src/AxoIrc5_v_1_x_x.st",
                "src/components.abb.robotics/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/components-kuka-robotics/Documentation/KukaRobotics",
            PageTitle = "KUKA Robotics",
            LibraryNamespace = "AXOpen.Components.Kuka.Robotics",
            Category = "Vendor Components",
            Vendor = "KUKA",
            Description = "Practical reference for integrating KUKA KRC4 and KRC5 robots in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["KUKA", "robot", "robotics", "KRC4", "KRC5", "manual control"],
            SourceFilePaths = [
                "src/showcase/app/src/components.kuka.robotics/Documentation/KukaRobotics.st",
                "src/showcase/app/src/components.kuka.robotics/Documentation/AxoKrc4_v_5_x_x_Showcase.st",
                "src/showcase/app/src/components.kuka.robotics/Documentation/AxoKrc4_v_5_x_x_ManualControl.st",
                "src/showcase/app/src/components.kuka.robotics/Documentation/AxoKrc5_v_5_x_x_Showcase.st",
                "src/showcase/app/src/components.kuka.robotics/Documentation/AxoKrc5_v_5_x_x_ManualControl.st",
                "src/components.kuka.robotics/docs/README.md",
                "src/components.kuka.robotics/docs/AxoKrc4_v_5_x_x.md",
                "src/components.kuka.robotics/docs/TROUBLES.md",
                "src/components.kuka.robotics/ctrl/src/AxoKrc4/v_5_x_x/AxoKrc4.st",
                "src/components.kuka.robotics/ctrl/src/AxoKrc5/v_5_x_x/AxoKrc5.st",
                "src/components.kuka.robotics/ctrl/assets/kuka_krc4/kuka_krc4_dio512.hwl.yml",
                "src/components.kuka.robotics/ctrl/assets/kuka_krc5/kuka_krc5_dio512.hwl.yml",
                "src/components.kuka.robotics/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/components-mitsubishi-robotics/Documentation/MitsubishiRobotics",
            PageTitle = "Mitsubishi Robotics",
            LibraryNamespace = "AXOpen.Components.Mitsubishi.Robotics",
            Category = "Vendor Components",
            Vendor = "Mitsubishi Electric",
            Description = "Practical reference for integrating Mitsubishi robots in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Mitsubishi", "robot", "robotics", "MELFA"],
            SourceFilePaths = [
                "src/showcase/app/src/components.mitsubishi.robotics/Documentation/MitsubishiRobotics.st",
                "src/showcase/app/src/components.mitsubishi.robotics/Documentation/AxoCr800_v_1_x_x_Showcase.st",
                "src/showcase/app/hwc/library_templates/mitsubishi_tz535/mitsubishi_tz535_64b_inout.hwl.yml",
                "src/components.mitsubishi.robotics/docs/README.md",
                "src/components.mitsubishi.robotics/docs/AxoCr800_v_1_x_x.md",
                "src/components.mitsubishi.robotics/docs/TROUBLES.md",
                "src/components.mitsubishi.robotics/ctrl/src/AxoCr800_v_1_x_x.st",
                "src/components.mitsubishi.robotics/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/components-ur-robotics/Documentation/UrRobotics",
            PageTitle = "UR Robotics",
            LibraryNamespace = "AXOpen.Components.Ur.Robotics",
            Category = "Vendor Components",
            Vendor = "Universal Robots",
            Description = "Practical reference for integrating Universal Robots in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Universal Robots", "UR", "cobot", "collaborative robot", "robotics"],
            SourceFilePaths = [
                "src/showcase/app/src/components.ur.robotics/Documentation/UrRobotics.st",
                "src/showcase/app/src/components.ur.robotics/Documentation/AxoUrCb3_v_3_x_x_Showcase.st",
                "src/showcase/app/hwc/library_templates/ur_robotics/ur_robot.hwl.yml",
                "src/components.ur.robotics/docs/README.md",
                "src/components.ur.robotics/docs/AxoUrCb3_v_3_x_x_Showcase.md",
                "src/components.ur.robotics/docs/TROUBLES.md",
                "src/components.ur.robotics/ctrl/src/AxoUrCb3/AxoUrCb3_v_3_x_x.st",
                "src/components.ur.robotics/ctrl/apax.yml",
            ]
        },

        // ── Vendor Components: Vision ───────────────────────────────────
        new()
        {
            Route = "/components-cognex-vision/Documentation/CognexVision",
            PageTitle = "Cognex Vision",
            LibraryNamespace = "AXOpen.Components.Cognex.Vision",
            Category = "Vendor Components",
            Vendor = "Cognex",
            Description = "Practical reference for integrating Cognex vision systems in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Cognex", "vision", "camera", "inspection", "image"],
            SourceFilePaths = [
                "src/showcase/app/src/components.cognex.vision/Documentation/CognexVision.st",
                "src/showcase/app/src/components.cognex.vision/Documentation/AxoInsight_v_6_0_0.st",
                "src/showcase/app/src/components.cognex.vision/Documentation/AxoInsight_v_24_0_0.st",
                "src/showcase/app/src/components.cognex.vision/Documentation/AxoDataman.st",
                "src/showcase/app/src/components.cognex.vision/Documentation/AxoDataman_Secondary.st",
                "src/showcase/app/src/components.cognex.vision/Documentation/AxoVisionPro.st",
                "src/components.cognex.vision/docs/README.md",
                "src/components.cognex.vision/docs/AxoInsight_v_6_0_0_0.md",
                "src/components.cognex.vision/docs/AxoInsight_v_24_0_0.md",
                "src/components.cognex.vision/docs/AxoDataman.md",
                "src/components.cognex.vision/docs/AxoVisionPro.md",
                "src/components.cognex.vision/docs/TROUBLES.md",
                "src/components.cognex.vision/ctrl/src/AxoInsight/v_6_0_0/AxoInsight.st",
                "src/components.cognex.vision/ctrl/src/AxoInsight/v_24_0_0/AxoInsight.st",
                "src/components.cognex.vision/ctrl/src/AxoDataman/v_6_0_0/AxoDataman.st",
                "src/components.cognex.vision/ctrl/src/AxoVisionPro/AxoVisionPro.st",
                "src/components.cognex.vision/ctrl/apax.yml",
                "src/showcase/app/hwc/library_templates/Cognex_Vision_Insight_V_6_0_0/Cognex_Vision_Insight_V_6_0_0.hwl.yml",
                "src/showcase/app/hwc/library_templates/cognex_vision_dataman280/Cognex_Dataman280.hwl.yml",
                "src/showcase/app/hwc/library_templates/cognex_vision_dataman380/Cognex_Dataman380.hwl.yml",
                "src/showcase/app/hwc/library_templates/cognex_vision_insight_2800/Cognex_Insight2800.hwl.yml",
                "src/showcase/app/hwc/library_templates/cognex_vision_pro/cognex_vision_pro.hwl.yml",
            ]
        },
        new()
        {
            Route = "/components-keyence-vision/Documentation/KeyenceVision",
            PageTitle = "Keyence Vision",
            LibraryNamespace = "AXOpen.Components.Keyence.Vision",
            Category = "Vendor Components",
            Vendor = "Keyence",
            Description = "Practical reference for integrating Keyence vision systems in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Keyence", "vision", "camera", "inspection", "image"],
            SourceFilePaths = [
                "src/showcase/app/src/components.keyence.vision/Documentation/KeyenceVision.st",
                "src/showcase/app/src/components.keyence.vision/Documentation/Axo_SR_750_Showcase.st",
                "src/showcase/app/src/components.keyence.vision/Documentation/Axo_SR_1000_Showcase.st",
                "src/showcase/app/src/components.keyence.vision/Documentation/Axo_IV3_Showcase.st",
                "src/components.keyence.vision/docs/README.md",
                "src/components.keyence.vision/docs/TROUBLES.md",
                "src/components.keyence.vision/docs/CHANGELOG.md",
                "src/components.keyence.vision/docs/Axo_IV3.md",
                "src/components.keyence.vision/docs/Axo_SR_750.md",
                "src/components.keyence.vision/docs/Axo_SR_1000.md",
                "src/components.keyence.vision/ctrl/src/Axo_IV3/Axo_IV3.st",
                "src/components.keyence.vision/ctrl/src/Axo_SR_750.st",
                "src/components.keyence.vision/ctrl/src/Axo_SR_1000.st",
                "src/components.keyence.vision/ctrl/apax.yml",
                "src/showcase/app/hwc/library_templates/Keyence_IV3/Keyence_IV3.hwl.yml",
                "src/showcase/app/hwc/library_templates/Keyence_SR_750/Keyence_SR_750.hwl.yml",
                "src/showcase/app/hwc/library_templates/Keyence_SR_1000/Keyence_SR_1000.hwl.yml",
            ]
        },
        new()
        {
            Route = "/components-zebra-vision/Documentation/ZebraVision",
            PageTitle = "Zebra Vision",
            LibraryNamespace = "AXOpen.Components.Zebra.Vision",
            Category = "Vendor Components",
            Vendor = "Zebra",
            Description = "Practical reference for integrating Zebra vision systems in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Zebra", "vision", "camera", "barcode", "scanner", "EA3600"],
            SourceFilePaths = [
                "src/showcase/app/src/components.zebra.vision/Documentation/ZebraVision.st",
                "src/showcase/app/src/components.zebra.vision/Documentation/AxoEA3600_Showcase.st",
                "src/showcase/app/src/components.zebra.vision/Documentation/AxoEA3600_Showcase2.st",
                "src/components.zebra.vision/docs/README.md",
                "src/components.zebra.vision/docs/TROUBLES.md",
                "src/components.zebra.vision/docs/CHANGELOG.md",
                "src/components.zebra.vision/docs/AxoEA3600.md",
                "src/components.zebra.vision/ctrl/src/AxoEA3600/AxoEA3600.st",
                "src/components.zebra.vision/ctrl/apax.yml",
                "src/showcase/app/hwc/plc_line.hwl.yml",
                "src/showcase/app/hwc/library_templates/zebra_ea3600/zebra_ea3600_88in6out.hwl.yml",
            ]
        },

        // ── Vendor Components: Identification ───────────────────────────
        new()
        {
            Route = "/components-balluff-identification/Documentation/BalluffIdentification",
            PageTitle = "Balluff Identification",
            LibraryNamespace = "AXOpen.Components.Balluff.Identification",
            Category = "Vendor Components",
            Vendor = "Balluff",
            Description = "Practical reference for integrating Balluff identification readers in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Balluff", "identification", "RFID", "reader", "code reader"],
            SourceFilePaths = [
                "src/showcase/app/src/components.balluff.identification/Documentation/BalluffIdentification.st",
                "src/showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045.st",
                "src/showcase/app/src/components.balluff.identification/Documentation/Axo_BIS_M_4XX_045_ManualControl.st",
                "src/components.balluff.identification/docs/README.md",
                "src/components.balluff.identification/docs/Axo_BIS_M_4XX_045.md",
                "src/components.balluff.identification/docs/TROUBLES.md",
                "src/showcase/app/hwc/library_templates/balluff_identification_BIS_M_4XX_045/BNIPNT507005Z040.hwl.yml",
            ]
        },
        new()
        {
            Route = "/components-siem-identification/Documentation/SiemIdentification",
            PageTitle = "Siemens Identification",
            LibraryNamespace = "AXOpen.Components.Siem.Identification",
            Category = "Vendor Components",
            Vendor = "Siemens",
            Description = "RFID readers via Ident profile, IO-Link, and cyclic communication using Siemens RF186C / RF260R / RF340R hardware.",
            Icon = "document-text",
            Tags = ["Siemens", "identification", "RFID", "IO-Link", "RF186C", "RF260R", "RF340R"],
            SourceFilePaths = [
                "src/showcase/app/src/components.siem.identification/Documentation/SiemIdentification.st",
                "src/showcase/app/src/components.siem.identification/Documentation/Axo_IdentDevice_Showcase.st",
                "src/showcase/app/src/components.siem.identification/Documentation/AxoIOLink_RF200Device_Showcase.st",
                "src/showcase/app/src/components.siem.identification/Documentation/AxoSimaticIdentCyclic_Showcase.st",
                "src/showcase/app/src/components.siem.identification/Documentation/AxoSimaticIdentCyclic_Showcase2.st",
                "src/components.siem.identification/docs/README.md",
                "src/components.siem.identification/docs/Axo_IdentDevice.md",
                "src/components.siem.identification/docs/AxoIOLink_RF200Device.md",
                "src/components.siem.identification/docs/AxoSimaticIdentCyclic.md",
                "src/components.siem.identification/docs/TROUBLES.md",
                "src/components.siem.identification/ctrl/src/IdentProfile/Axo_IdentDevice.st",
                "src/components.siem.identification/ctrl/src/IOLink/AxoIOLink_RF200Device.st",
                "src/components.siem.identification/ctrl/src/AxoSimaticIdentCyclic/AxoSimaticIdentCyclic.st",
                "src/components.siem.identification/ctrl/apax.yml",
                "src/showcase/app/hwc/library_templates/siemens_identification/rf186c.hwl.yml",
                "src/showcase/app/hwc/library_templates/siemens_identification/rf186c_cyc.hwl.yml",
                "src/showcase/app/hwc/library_templates/siemens_identification/et200sp_CM_4xIO_Link_RF200.hwl.yml",
            ]
        },

        // ── Vendor Components: Drives ───────────────────────────────────
        new()
        {
            Route = "/components-festo-drives/Documentation/FestoDrives",
            PageTitle = "Festo Drives",
            LibraryNamespace = "AXOpen.Components.Festo.Drives",
            Category = "Vendor Components",
            Vendor = "Festo",
            Description = "Practical reference for integrating Festo drives in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Festo", "drive", "servo", "motor", "motion"],
            SourceFilePaths = [
                "src/showcase/app/src/components.festo.drives/Documentation/FestoDrives.st",
                "src/showcase/app/src/components.festo.drives/Documentation/AxoCmmtAs_Showcase.st",
                "src/showcase/app/src/components.festo.drives/Documentation/AxoCmmtAs_Showcase2.st",
                "src/components.festo.drives/docs/README.md",
                "src/components.festo.drives/docs/AxoCmmtAs_Showcase.md",
                "src/components.festo.drives/docs/AxoCmmtAs_Showcase2.md",
                "src/components.festo.drives/docs/TROUBLES.md",
                "src/components.festo.drives/ctrl/src/AxoCmmtAs/AxoCmmtAs.st",
                "src/components.festo.drives/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/components-rexroth-drives/Documentation/RexrothDrives",
            PageTitle = "Rexroth Drives",
            LibraryNamespace = "AXOpen.Components.Rexroth.Drives",
            Category = "Vendor Components",
            Vendor = "Bosch Rexroth",
            Description = "Practical reference for integrating Bosch Rexroth drives (IndraDrive, ctrlX DRIVE) in SIMATIC AX applications.",
            Icon = "document-text",
            Tags = ["Rexroth", "Bosch", "drive", "IndraDrive", "ctrlX", "servo", "motion"],
            SourceFilePaths = [
                "src/showcase/app/src/components.rexroth.drives/Documentation/RexrothDrives.st",
                "src/showcase/app/src/components.rexroth.drives/Documentation/AxoIndraDrive_Showcase.st",
                "src/showcase/app/src/components.rexroth.drives/Documentation/AxoCtrlxDriveXsc_Showcase.st",
                "src/components.rexroth.drives/docs/README.md",
                "src/components.rexroth.drives/docs/AxoIndraDrive.md",
                "src/components.rexroth.drives/docs/AxoCtrlxDriveXsc.md",
                "src/components.rexroth.drives/docs/TROUBLES.md",
                "src/components.rexroth.drives/ctrl/src/AxoIndraDrive/AxoIndraDrive.st",
                "src/components.rexroth.drives/ctrl/src/AxoCtrlxDriveXsc/AxoCtrlxDriveXsc.st",
                "src/components.rexroth.drives/ctrl/apax.yml",
                "src/showcase/app/hwc/plc_line.hwl.yml",
                "src/showcase/app/hwc/library_templates/rexroth_indradrive/rexroth_indradrive.hwl.yml",
                "src/showcase/app/hwc/library_templates/rexroth_ctrlx_drive/rexroth_ctrlx_drive_xcs.hwl.yml",
            ]
        },

        // ── Vendor Components: Tightening ───────────────────────────────
        new()
        {
            Route = "/components-desoutter-tightening/Documentation/DesoutterTightening",
            PageTitle = "Desoutter Tightening",
            LibraryNamespace = "AXOpen.Components.Desoutter.Tightening",
            Category = "Vendor Components",
            Vendor = "Desoutter",
            Description = "Practical reference for integrating Desoutter tightening controllers in SIMATIC AX applications.",
            Icon = "document-text",
            Tags = ["Desoutter", "tightening", "torque", "screw", "fastening"],
            SourceFilePaths = [
                "src/showcase/app/src/components.desoutter.tightening/Documentation/DesoutterTightening.st",
                "src/showcase/app/src/components.desoutter.tightening/Documentation/AxoCVIC_II.st",
                "src/components.desoutter.tightening/docs/README.md",
                "src/components.desoutter.tightening/docs/AxoCVIC_II.md",
                "src/components.desoutter.tightening/docs/TROUBLES.md",
                "src/components.desoutter.tightening/ctrl/src/CVIC_II/AxoCVIC_II.st",
                "src/components.desoutter.tightening/ctrl/apax.yml",
                "src/showcase/app/hwc/plc_line.hwl.yml",
                "src/showcase/app/hwc/library_templates/desoutter_tightenning_CVIC_II/Desoutter_CVIC_II.hwl.yml",
            ]
        },
        new()
        {
            Route = "/components-rexroth-tightening/Documentation/RexrothTightening",
            PageTitle = "Rexroth Tightening",
            LibraryNamespace = "AXOpen.Components.Rexroth.Tightening",
            Category = "Vendor Components",
            Vendor = "Bosch Rexroth",
            Description = "Practical reference for integrating Bosch Rexroth tightening controllers in SIMATIC AX applications.",
            Icon = "document-text",
            Tags = ["Rexroth", "Bosch", "tightening", "torque", "screw", "fastening"],
            SourceFilePaths = [
                "src/showcase/app/src/components.rexroth.tightening/Documentation/RexrothTightening.st",
                "src/showcase/app/src/components.rexroth.tightening/Documentation/Axo_CS351_compact_Showcase.st",
                "src/showcase/app/src/components.rexroth.tightening/Documentation/Axo_CS351_compact_Showcase2.st",
                "src/components.rexroth.tightening/docs/README.md",
                "src/components.rexroth.tightening/docs/Axo_CS351_compact.md",
                "src/components.rexroth.tightening/docs/TROUBLES.md",
                "src/components.rexroth.tightening/ctrl/src/Axo_CS351_compact/Axo_CS351_compact.st",
                "src/components.rexroth.tightening/ctrl/apax.yml",
                "src/showcase/app/hwc/library_templates/rexroth_tightening_cs351/rexroth_tightening_cs351.hwl.yml",
            ]
        },

        // ── Vendor Components: Other ────────────────────────────────────
        new()
        {
            Route = "/components-dukane-welders/Documentation/DukaneWelders",
            PageTitle = "Dukane Welders",
            LibraryNamespace = "AXOpen.Components.Dukane.Welders",
            Category = "Vendor Components",
            Vendor = "Dukane",
            Description = "Practical reference for integrating Dukane welders in SIMATIC AX applications.",
            Icon = "document-text",
            Tags = ["Dukane", "welder", "welding", "ultrasonic"],
            SourceFilePaths = [
                "src/showcase/app/src/components.dukane.welders/Documentation/DukaneWelders.st",
                "src/showcase/app/src/components.dukane.welders/Documentation/Axo_IQ_SeriesWelder_Showcase.st",
                "src/showcase/app/src/components.dukane.welders/Documentation/Axo_IQ_SeriesWelder_Showcase2.st",
                "src/components.dukane.welders/docs/README.md",
                "src/components.dukane.welders/docs/Axo_IQ_SeriesWelder.md",
                "src/components.dukane.welders/docs/TROUBLES.md",
                "src/components.dukane.welders/ctrl/src/AxoIQSeriesWelder/Axo_IQ_SeriesWelder.st",
                "src/components.dukane.welders/ctrl/apax.yml",
                "src/showcase/app/hwc/library_templates/dukane_welders_iq_series/DukaneIqSeriesWelder.hwl.yml",
            ]
        },
        new()
        {
            Route = "/components-rexroth-press/Documentation/RexrothPress",
            PageTitle = "Rexroth Press",
            LibraryNamespace = "AXOpen.Components.Rexroth.Press",
            Category = "Vendor Components",
            Vendor = "Bosch Rexroth",
            Description = "Practical reference for integrating Bosch Rexroth Smart Function Kit press systems in SIMATIC AX applications.",
            Icon = "document-text",
            Tags = ["Rexroth", "Bosch", "press", "Smart Function Kit", "force"],
            SourceFilePaths = [
                "src/showcase/app/src/components.rexroth.press/Documentation/RexrothPress.st",
                "src/showcase/app/src/components.rexroth.press/Documentation/AxoSmartFunctionKit_v_4_x_x_Showcase.st",
                "src/components.rexroth.press/docs/README.md",
                "src/components.rexroth.press/docs/AxoSmartFunctionKit_v_4_x_x.md",
                "src/components.rexroth.press/docs/TROUBLES.md",
                "src/components.rexroth.press/ctrl/src/AxoSmartFunctionKit_v_4_x_x.st",
                "src/components.rexroth.press/ctrl/apax.yml",
                "src/showcase/app/hwc/library_templates/rexroth_sfk_press/rexroth_sfk_press.hwl.yml",
            ]
        },
        new()
        {
            Route = "/components-siem-communication/Documentation/SiemCommunication",
            PageTitle = "Siemens Communication",
            LibraryNamespace = "AXOpen.Components.Siem.Communication",
            Category = "Vendor Components",
            Vendor = "Siemens",
            Description = "Point-to-point serial communication via Siemens ET200SP CM PtP module.",
            Icon = "document-text",
            Tags = ["Siemens", "communication", "serial", "PtP", "ET200SP", "point-to-point"],
            SourceFilePaths = [
                "src/showcase/app/src/components.siem.communication/Documentation/SiemCommunication.st",
                "src/showcase/app/src/components.siem.communication/Documentation/AxoCmPtp_Showcase.st",
                "src/components.siem.communication/docs/README.md",
                "src/components.siem.communication/docs/AxoCmPtp_Showcase.md",
                "src/components.siem.communication/docs/TROUBLES.md",
                "src/components.siem.communication/ctrl/src/AxoCmPtp/AxoCmPtp.st",
                "src/components.siem.communication/ctrl/apax.yml",
                "src/showcase/app/hwc/library_templates/siemens_communication/et200sp.hwl.yml",
            ]
        },

        // ── Foundation / Tooling ────────────────────────────────────────
        new()
        {
            Route = "/abstractions/Documentation/AbstractionsShowcase",
            PageTitle = "Abstractions",
            LibraryNamespace = "AXOpen.Abstractions",
            Category = "Foundation",
            Description = "Core interfaces and enums: IAxoContext, IAxoObject, IAxoMessenger, IAxoLogger, IAxoRtc, IAxoRtm, eAxoMessageCategory, and eLogLevel.",
            Icon = "document-text",
            Tags = ["abstractions", "interface", "IAxoContext", "IAxoObject", "IAxoMessenger", "IAxoLogger"],
            SourceFilePaths = [
                "src/showcase/app/src/abstractions/AbstractionsShowcase.st",
                "src/abstractions/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/inspectors/Documentation/InspectorsShowcase",
            PageTitle = "Inspectors",
            LibraryNamespace = "AXOpen.Inspectors",
            Category = "Foundation",
            Description = "Digital, analogue, and data inspectors with configurable pass/fail times, result aggregation, and failure-handling strategies (carry on, retry, dialog).",
            Icon = "document-text",
            Tags = ["inspector", "inspection", "digital", "analogue", "pass", "fail", "quality"],
            SourceFilePaths = [
                "src/showcase/app/src/inspectors/InspectorsShowcase.st",
                "src/inspectors/docs/README.md",
                "src/inspectors/docs/AXODIGITALINSPECTOR.md",
                "src/inspectors/docs/AXOANALOGUEINSPECTOR.md",
                "src/inspectors/docs/AXODATAINSPECTOR.md",
            ]
        },
        new()
        {
            Route = "/io/Documentation/IoShowcase",
            PageTitle = "I/O",
            LibraryNamespace = "AXOpen.Io",
            Category = "Foundation",
            Description = "Hardware diagnostics, IO component monitoring, PROFINET record access, and IO-Link module configuration for SIMATIC AX applications.",
            Icon = "document-text",
            Tags = ["I/O", "IO", "input", "output", "hardware", "diagnostics", "AxoIoComponent", "AxoHwDiag", "AxoRecordAccessTool", "AxoIOLinkET200SP", "PROFINET", "IO-Link", "Balluff"],
            SourceFilePaths = [
                "src/showcase/app/src/IO/IoShowcase.st",
                "src/showcase/app/src/IO/AxoIoComponent_Showcase.st",
                "src/showcase/app/src/IO/AxoHwDiag_Showcase.st",
                "src/showcase/app/src/IO/AxoRecordAccessTool_Showcase.st",
                "src/showcase/app/src/IO/AxoIOLinkET200SP_Balluff_IO_Showcase.st",
                "src/io/ctrl/src/AxoIoComponent/AxoIoComponent.st",
                "src/io/ctrl/src/AxoHwDiag/AxoHwDiag.st",
                "src/io/ctrl/src/AxoRecordAccessTool/AxoRecordAccessTool.st",
                "src/io/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/probers/Documentation/ProbersShowcase",
            PageTitle = "Probers",
            LibraryNamespace = "AXOpen.Probers",
            Category = "Foundation",
            Description = "Test probing utilities for cyclic and conditional test execution. AxoProberWithCounterBase runs for N cycles; AxoProberWithCompletedCondition runs until a condition is met.",
            Icon = "document-text",
            Tags = ["prober", "test", "cyclic", "probe", "condition"],
            SourceFilePaths = [
                "src/showcase/app/src/probers/ProbersShowcase.st",
                "src/probers/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/simatic1500/Documentation/Simatic1500Showcase",
            PageTitle = "SIMATIC S7-1500",
            LibraryNamespace = "AXOpen.S71500",
            Category = "Foundation",
            Description = "Platform-specific implementations of IAxoRtc (real-time clock) and IAxoRtm (runtime measurement) for the SIMATIC S7-1500 PLC family.",
            Icon = "document-text",
            Tags = ["S7-1500", "SIMATIC", "RTC", "real-time clock", "runtime", "platform"],
            SourceFilePaths = [
                "src/showcase/app/src/simatic1500/Simatic1500Showcase.st",
                "src/simatic1500/ctrl/src/Rtc.st",
                "src/simatic1500/ctrl/src/Rtm.st",
                "src/simatic1500/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/timers/Documentation/TimersShowcase",
            PageTitle = "Timers",
            LibraryNamespace = "AXOpen.Timers",
            Category = "Foundation",
            Description = "OnDelayTimer, OffDelayTimer, PulseTimer, and AxoBlinker for time-based control logic.",
            Icon = "document-text",
            Tags = ["timer", "delay", "pulse", "blinker", "TON", "TOF", "TP"],
            SourceFilePaths = [
                "src/showcase/app/src/timers/TimersShowcase.st",
                "src/timers/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/utils/Documentation/UtilsShowcase",
            PageTitle = "Utils",
            LibraryNamespace = "AXOpen.Utils",
            Category = "Foundation",
            Description = "String building with AxoStringBuilder and CRC checksum functions (CRC-8, CRC-16, CRC-32) for data integrity verification.",
            Icon = "document-text",
            Tags = ["utils", "string", "CRC", "checksum", "builder"],
            SourceFilePaths = [
                "src/showcase/app/src/utils/UtilsShowcase.st",
                "src/utils/ctrl/apax.yml",
            ]
        },

        // ── Security ────────────────────────────────────────────────────
        new()
        {
            Route = "/Security",
            PageTitle = "Security",
            LibraryNamespace = "AXOpen.Security",
            Category = "Security",
            Description = "User and role management with role-based access control for the showcase application.",
            Icon = "lock-closed",
            Tags = ["security", "authentication", "authorization", "user", "role", "RBAC"]
        },
    ];
}
