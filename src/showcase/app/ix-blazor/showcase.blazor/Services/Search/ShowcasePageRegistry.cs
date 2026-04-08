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
            Route = "/Core/AxoTask",
            PageTitle = "AxoTask",
            LibraryNamespace = "AXOpen.Core",
            Category = "Core",
            Description = "Task execution for PLC programs. Covers AxoTask, AxoMomentaryTask, AxoToggleTask, and AxoRemoteTask.",
            Icon = "play",
            Tags = ["task", "fire and forget", "momentary", "toggle", "remote task", "control flow"],
            SourceFilePaths = [
                "src/showcase/app/src/CoreExamples/AXOpen.AxoTask/AxoTaskDocuExample.st",
                "src/showcase/app/src/CoreExamples/AXOpen.AxoTask/AxoTaskExample.st",
                "src/showcase/app/src/CoreExamples/AXOpen.AxoMomentaryTask/AxoMomentaryTaskDocuExample.st",
                "src/showcase/app/src/CoreExamples/AXOpen.AxoToggleTask/AxoToggleTaskDocuExample.st",
                "src/showcase/app/src/CoreExamples/AXOpen.AxoRemoteTask/AxoRemoteTaskDocuExample.st",
                "src/core/ctrl/src/AxoTask/AxoTask.st",
                "src/core/ctrl/src/AxoMomentaryTask/AxoMomentaryTask.st",
                "src/core/ctrl/src/AxoToggleTask/AxoToggleTask.st",
                "src/core/ctrl/src/AxoRemoteTask/AxoRemoteTask.st",
                "src/core/docs/AXOTASK.md",
                "src/core/docs/AXOMOMENETARY TASK.md",
                "src/core/docs/AXOTOGGLETASK.md",
                "src/core/docs/AXOREMOTETASK.md",
            ]
        },
        new()
        {
            Route = "/Core/AxoSequencer",
            PageTitle = "AxoSequencer",
            LibraryNamespace = "AXOpen.Core",
            Category = "Core",
            Description = "Sequencer and step coordination. Triggers steps in order with step-by-step and continuous modes, analytics, and AxoSequencerContainer.",
            Icon = "queue-list",
            Tags = ["sequencer", "step", "sequence", "coordination", "state machine"],
            SourceFilePaths = [
                "src/showcase/app/src/CoreExamples/AXOpen.AxoSequencer/AxoSequencerDocuExample.st",
                "src/showcase/app/src/CoreExamples/AXOpen.AxoSequencer/AxoSequencerExample.st",
                "src/showcase/app/src/CoreExamples/AXOpen.AxoSequencerContainer/AxoSequencerContainerDocuExample.st",
                "src/core/docs/AXOSEQUENCER.md",
                "src/core/docs/AXOSEQUENCERCONTAINER.md",
                "src/core/docs/AXOSTEP.md",
            ]
        },
        new()
        {
            Route = "/Core/AxoComponent",
            PageTitle = "AxoComponent",
            LibraryNamespace = "AXOpen.Core",
            Category = "Core",
            Description = "Base class for all AXOpen components. Provides standardized lifecycle management, automatic UI rendering with header/detail sections, and a consistent restore pattern.",
            Icon = "puzzle-piece",
            Tags = ["component", "base class", "lifecycle", "restore", "header", "detail"],
            SourceFilePaths = [
                "src/showcase/app/src/CoreExamples/AXOpen.AxoComponent/AxoComponentExample.st",
                "src/showcase/app/src/CoreExamples/AXOpen.AxoComponent/AxoComponentHeaderOnlyExample.st",
                "src/core/docs/AXOCOMPONENT.md",
                "src/core/ctrl/src/AxoComponent/AxoComponent.st",
            ]
        },
        new()
        {
            Route = "/Core/AxoMessaging",
            PageTitle = "AxoMessaging",
            LibraryNamespace = "AXOpen.Core",
            Category = "Core",
            Description = "Messaging, TextLists and Logging. AxoMessenger provides categorized PLC messages with acknowledgement. AxoTextList maps codes to text. AxoLogger bridges PLC logging to .NET.",
            Icon = "chat-bubble-left-right",
            Tags = ["messaging", "messenger", "text list", "logging", "diagnostics", "acknowledgement"],
            SourceFilePaths = [
                "src/showcase/app/src/CoreExamples/AXOpen.Messaging/AxoStaticMessengerDocuExample.st",
                "src/showcase/app/src/CoreExamples/AXOpen.TextList/AxoTextListExample.st",
                "src/showcase/app/src/CoreExamples/AXOpen.Logging/AxoLoggerDocuExample.st",
                "src/core/docs/AXOMESSENGER.md",
                "src/core/docs/AXOTEXTLIST.md",
                "src/core/docs/AXOLOGGER.md",
            ]
        },
        new()
        {
            Route = "/Core/AxoDialogs",
            PageTitle = "AxoDialogs",
            LibraryNamespace = "AXOpen.Core",
            Category = "Core",
            Description = "Interactive user prompts triggered from PLC code with configurable buttons and types. AxoAlert shows timed notification banners. Both integrate via SignalR for real-time browser delivery.",
            Icon = "chat-bubble-bottom-center-text",
            Tags = ["dialog", "alert", "prompt", "notification", "SignalR", "user interaction"],
            SourceFilePaths = [
                "src/showcase/app/src/CoreExamples/AXOpen.Dialogs/AxoDialogExamples.st",
                "src/showcase/app/src/CoreExamples/AXOpen.Dialogs/AxoDialogTest.st",
                "src/core/docs/AXODIALOG.md",
                "src/core/docs/AXOALERTDIALOG.md",
            ]
        },

        // ── Data Management ─────────────────────────────────────────────
        new()
        {
            Route = "/Data/DataExchange",
            PageTitle = "Data Exchange",
            LibraryNamespace = "AXOpen.Data",
            Category = "Data",
            Description = "CRUD operations between PLC and .NET repositories. Covers standard exchange, fragment-based exchange, persistent storage, and distributed data patterns.",
            Icon = "arrows-right-left",
            Tags = ["data", "CRUD", "repository", "persistence", "fragment", "distributed", "exchange"],
            SourceFilePaths = [
                "src/showcase/app/src/DataExamples/AxoDataExchangeExample.st",
                "src/showcase/app/src/DataExamples/AxoDataFragmentExchangeExample.st",
                "src/showcase/app/src/DataExamples/AxoDataPersistentExchangeExample.st",
                "src/showcase/app/src/DataExamples/AxoDataDistributedExample.st",
                "src/data/docs/AxoDataExchange.md",
                "src/data/docs/AxoDataFragmentExchange.md",
                "src/data/docs/AxoDataPersistentExchange.md",
                "src/data/docs/DistributedDataExchange.md",
            ]
        },

        // ── Generic Components ──────────────────────────────────────────
        new()
        {
            Route = "/ComponentsAbstractions/Documentation",
            PageTitle = "Components Abstractions",
            LibraryNamespace = "AXOpen.Components.Abstractions",
            Category = "Components",
            Description = "Standard interface contracts for all AXOpen components: IAxoDrive, IAxoRobotics, IAxoCodeReader, IAxoVisionSensor, IAxo_Power, and shared data types.",
            Icon = "document-text",
            Tags = ["abstractions", "interface", "contract", "IAxoDrive", "IAxoRobotics", "IAxoCodeReader", "IAxoVisionSensor"],
            SourceFilePaths = [
                "src/showcase/app/src/Foundation/ComponentsAbstractionsShowcase.st",
                "src/components.abstractions/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/Drives/Documentation",
            PageTitle = "Drives",
            LibraryNamespace = "AXOpen.Components.Drives",
            Category = "Components",
            Description = "Abstract drive component providing a vendor-neutral foundation for motion control in SIMATIC AX.",
            Icon = "document-text",
            Tags = ["drive", "motion", "motor", "servo", "axis", "abstract"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsDrives/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsDrives/Documentation/Component_1.st",
                "src/components.drives/docs/README.md",
                "src/components.drives/docs/Component_1.md",
                "src/components.drives/docs/Component_2.md",
                "src/components.drives/docs/TROUBLES.md",
                "src/components.drives/ctrl/src/AxoDrives/AxoDrive.st",
                "src/components.drives/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/Elements/Documentation",
            PageTitle = "Elements",
            LibraryNamespace = "AXOpen.Components.Elements",
            Category = "Components",
            Description = "Basic I/O building blocks — digital inputs/outputs, analog inputs/outputs, signal tower, and rotary indexing table.",
            Icon = "document-text",
            Tags = ["elements", "digital", "analog", "signal tower", "rotary", "indexing table", "I/O"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsElements/Documentation/DocumentationContext.st",
                "src/components.elements/docs/README.md",
                "src/components.elements/docs/AXODI.md",
                "src/components.elements/docs/AXODO.md",
                "src/components.elements/docs/AXOAI.md",
                "src/components.elements/docs/AXOAO.md",
                "src/components.elements/docs/HOWTO.md",
                "src/components.elements/docs/TROUBLES.md",
            ]
        },
        new()
        {
            Route = "/Pneumatics/Documentation",
            PageTitle = "Pneumatics",
            LibraryNamespace = "AXOpen.Components.Pneumatics",
            Category = "Components",
            Description = "AxoCylinder component for controlling pneumatic cylinders with move-in/move-out/stop actions, sensor feedback, and configurable suspend/abort conditions.",
            Icon = "document-text",
            Tags = ["pneumatics", "cylinder", "actuator", "valve", "move-in", "move-out"],
            SourceFilePaths = [
                "src/showcase/app/src/Foundation/PneumaticsShowcase.st",
                "src/showcase/app/hwc/plc_line.hwl.yml",
                "src/showcase/app/hwc/library_templates/AventicsPneumatics/AventicsPneumaticsAES.hwl.yml",
                "src/components.pneumatics/docs/README.md",
                "src/components.pneumatics/docs/AXOCYLINDER.md",
                "src/components.pneumatics/docs/HOWTO.md",
                "src/components.pneumatics/docs/TROUBLES.md",
            ]
        },
        new()
        {
            Route = "/Robotics/Documentation",
            PageTitle = "Robotics",
            LibraryNamespace = "AXOpen.Components.Robotics",
            Category = "Components",
            Description = "Generic robotics base library providing abstract interfaces and common types for vendor-specific robot integrations.",
            Icon = "document-text",
            Tags = ["robotics", "robot", "base", "abstract", "motion"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsRobotics/Documentation/DocumentationContext.st",
                "src/components.robotics/docs/README.md",
                "src/components.robotics/docs/Component_1.md",
                "src/components.robotics/docs/Component_2.md",
                "src/components.robotics/docs/TROUBLES.md",
            ]
        },

        // ── Vendor Components: Robotics ─────────────────────────────────
        new()
        {
            Route = "/AbbRobotics/Documentation",
            PageTitle = "ABB Robotics",
            LibraryNamespace = "AXOpen.Components.Abb.Robotics",
            Category = "Vendor Components",
            Vendor = "ABB",
            Description = "Practical reference for integrating ABB robots in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["ABB", "robot", "robotics", "IRB"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsAbbRobotics/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsAbbRobotics/Documentation/Component_1.st",
                "src/showcase/app/src/ComponentsAbbRobotics/Documentation/Component_2.st",
                "src/showcase/app/hwc/library_templates/abb_robotics_irc5/abb_irc5_robot_in64b_out64b.hwl.yml",
                "src/showcase/app/hwc/library_templates/abb_robotics_omnicore/abb_omnicore_robot_in64b_out64b.hwl.yml",
                "src/components.abb.robotics/docs/README.md",
                "src/components.abb.robotics/docs/Component_1.md",
                "src/components.abb.robotics/docs/Component_2.md",
                "src/components.abb.robotics/docs/TROUBLES.md",
                "src/components.abb.robotics/ctrl/src/AxoIrc5_v_1_x_x.st",
                "src/components.abb.robotics/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/KukaRobotics/Documentation",
            PageTitle = "KUKA Robotics",
            LibraryNamespace = "AXOpen.Components.Kuka.Robotics",
            Category = "Vendor Components",
            Vendor = "KUKA",
            Description = "Practical reference for integrating KUKA robots in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["KUKA", "robot", "robotics"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsKukaRobotics/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsKukaRobotics/Documentation/Component_1.st",
                "src/showcase/app/src/ComponentsKukaRobotics/Documentation/Component_2.st",
                "src/showcase/app/hwc/library_templates/kuka_krc4/kuka_krc4_dio512.hwl.yml",
                "src/components.kuka.robotics/docs/README.md",
                "src/components.kuka.robotics/docs/Component_1.md",
                "src/components.kuka.robotics/docs/Component_2.md",
                "src/components.kuka.robotics/docs/TROUBLES.md",
                "src/components.kuka.robotics/ctrl/src/AxoKrc4_v_5_x_x.st",
                "src/components.kuka.robotics/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/MitsubishiRobotics/Documentation",
            PageTitle = "Mitsubishi Robotics",
            LibraryNamespace = "AXOpen.Components.Mitsubishi.Robotics",
            Category = "Vendor Components",
            Vendor = "Mitsubishi Electric",
            Description = "Practical reference for integrating Mitsubishi robots in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Mitsubishi", "robot", "robotics", "MELFA"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsMitsubishiRobotics/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsMitsubishiRobotics/Documentation/Component_1.st",
                "src/components.mitsubishi.robotics/docs/README.md",
                "src/components.mitsubishi.robotics/docs/Component_1.md",
                "src/components.mitsubishi.robotics/docs/TROUBLES.md",
                "src/components.mitsubishi.robotics/ctrl/src/AxoCr800_v_1_x_x.st",
                "src/components.mitsubishi.robotics/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/UrRobotics/Documentation",
            PageTitle = "UR Robotics",
            LibraryNamespace = "AXOpen.Components.Ur.Robotics",
            Category = "Vendor Components",
            Vendor = "Universal Robots",
            Description = "Practical reference for integrating Universal Robots in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Universal Robots", "UR", "cobot", "collaborative robot", "robotics"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsUrRobotics/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsUrRobotics/Documentation/Component_1.st",
                "src/showcase/app/hwc/library_templates/ur_robotics/ur_robot.hwl.yml",
                "src/components.ur.robotics/docs/README.md",
                "src/components.ur.robotics/docs/Component_1.md",
                "src/components.ur.robotics/docs/TROUBLES.md",
                "src/components.ur.robotics/ctrl/src/AxoUrCb3/AxoUrCb3_v_3_x_x.st",
                "src/components.ur.robotics/ctrl/apax.yml",
            ]
        },

        // ── Vendor Components: Vision ───────────────────────────────────
        new()
        {
            Route = "/CognexVision/Documentation",
            PageTitle = "Cognex Vision",
            LibraryNamespace = "AXOpen.Components.Cognex.Vision",
            Category = "Vendor Components",
            Vendor = "Cognex",
            Description = "Practical reference for integrating Cognex vision systems in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Cognex", "vision", "camera", "inspection", "image"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsCognexVision/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsCognexVision/Documentation/Component_1.st",
                "src/showcase/app/src/ComponentsCognexVision/Documentation/Component_2.st",
                "src/showcase/app/src/ComponentsCognexVision/Documentation/Component_3.st",
                "src/showcase/app/src/ComponentsCognexVision/Documentation/Component_4.st",
                "src/showcase/app/src/ComponentsCognexVision/Documentation/Component_5.st",
                "src/components.cognex.vision/docs/README.md",
                "src/components.cognex.vision/docs/Component_1.md",
                "src/components.cognex.vision/docs/Component_2.md",
                "src/components.cognex.vision/docs/Component_3.md",
                "src/components.cognex.vision/docs/Component_4.md",
                "src/components.cognex.vision/docs/Component_5.md",
                "src/components.cognex.vision/docs/TROUBLES.md",
                "src/components.cognex.vision/ctrl/src/v_6_0_0_0/AxoInsight/AxoInsight.st",
                "src/components.cognex.vision/ctrl/src/v_6_0_0_0/AxoDataman/AxoDataman.st",
                "src/components.cognex.vision/ctrl/src/AxoVisionPro/AxoVisionPro.st",
                "src/components.cognex.vision/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/KeyenceVision/Documentation",
            PageTitle = "Keyence Vision",
            LibraryNamespace = "AXOpen.Components.Keyence.Vision",
            Category = "Vendor Components",
            Vendor = "Keyence",
            Description = "Practical reference for integrating Keyence vision systems in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Keyence", "vision", "camera", "inspection", "image"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsKeyenceVision/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsKeyenceVision/Documentation/Component_1.st",
                "src/showcase/app/src/ComponentsKeyenceVision/Documentation/Component_2.st",
                "src/showcase/app/src/ComponentsKeyenceVision/Documentation/Component_3.st",
                "src/components.keyence.vision/docs/README.md",
                "src/components.keyence.vision/docs/TROUBLES.md",
            ]
        },
        new()
        {
            Route = "/ZebraVision/Documentation",
            PageTitle = "Zebra Vision",
            LibraryNamespace = "AXOpen.Components.Zebra.Vision",
            Category = "Vendor Components",
            Vendor = "Zebra Technologies",
            Description = "Practical reference for integrating Zebra vision systems in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Zebra", "vision", "camera", "barcode", "scanner"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsZebraVision/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsZebraVision/Documentation/Component_1.st",
                "src/showcase/app/src/ComponentsZebraVision/Documentation/Component_2.st",
                "src/components.zebra.vision/docs/README.md",
                "src/components.zebra.vision/docs/TROUBLES.md",
            ]
        },

        // ── Vendor Components: Identification ───────────────────────────
        new()
        {
            Route = "/BalluffIdentification/Documentation",
            PageTitle = "Balluff Identification",
            LibraryNamespace = "AXOpen.Components.Balluff.Identification",
            Category = "Vendor Components",
            Vendor = "Balluff",
            Description = "Practical reference for integrating Balluff identification readers in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Balluff", "identification", "RFID", "reader", "code reader"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsBalluffIdentification/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsBalluffIdentification/Documentation/Component_1.st",
                "src/showcase/app/src/ComponentsBalluffIdentification/Documentation/Component_2.st",
                "src/components.balluff.identification/docs/README.md",
                "src/components.balluff.identification/docs/Component_1.md",
                "src/components.balluff.identification/docs/Component_2.md",
                "src/components.balluff.identification/docs/TROUBLES.md",
            ]
        },
        new()
        {
            Route = "/SiemIdentification/Documentation",
            PageTitle = "Siemens Identification",
            LibraryNamespace = "AXOpen.Components.Siem.Identification",
            Category = "Vendor Components",
            Vendor = "Siemens",
            Description = "RFID readers via Ident profile, IO-Link, and cyclic communication using Siemens RF186C / RF260R / RF340R hardware.",
            Icon = "document-text",
            Tags = ["Siemens", "identification", "RFID", "IO-Link", "RF186C", "RF260R", "RF340R"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsSiemIdentification/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsSiemIdentification/Documentation/Component_1.st",
                "src/showcase/app/src/ComponentsSiemIdentification/Documentation/Component_2.st",
                "src/showcase/app/src/ComponentsSiemIdentification/Documentation/Component_3.st",
                "src/showcase/app/src/ComponentsSiemIdentification/Documentation/Component_4.st",
                "src/components.siem.identification/docs/README.md",
                "src/components.siem.identification/docs/Component_1.md",
                "src/components.siem.identification/docs/Component_2.md",
                "src/components.siem.identification/docs/TROUBLES.md",
            ]
        },

        // ── Vendor Components: Drives ───────────────────────────────────
        new()
        {
            Route = "/FestoDrives/Documentation",
            PageTitle = "Festo Drives",
            LibraryNamespace = "AXOpen.Components.Festo.Drives",
            Category = "Vendor Components",
            Vendor = "Festo",
            Description = "Practical reference for integrating Festo drives in SIMATIC AX applications with runnable command widgets and live component status.",
            Icon = "document-text",
            Tags = ["Festo", "drive", "servo", "motor", "motion"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsFestoDrives/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsFestoDrives/Documentation/Component_1.st",
                "src/showcase/app/src/ComponentsFestoDrives/Documentation/Component_2.st",
                "src/components.festo.drives/docs/README.md",
                "src/components.festo.drives/docs/Component_1.md",
                "src/components.festo.drives/docs/Component_2.md",
                "src/components.festo.drives/docs/TROUBLES.md",
                "src/components.festo.drives/ctrl/src/AxoCmmtAs/AxoCmmtAs.st",
                "src/components.festo.drives/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/RexrothDrives/Documentation",
            PageTitle = "Rexroth Drives",
            LibraryNamespace = "AXOpen.Components.Rexroth.Drives",
            Category = "Vendor Components",
            Vendor = "Bosch Rexroth",
            Description = "Practical reference for integrating Bosch Rexroth drives (IndraDrive, ctrlX DRIVE) in SIMATIC AX applications.",
            Icon = "document-text",
            Tags = ["Rexroth", "Bosch", "drive", "IndraDrive", "ctrlX", "servo", "motion"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsRexrothDrives/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsRexrothDrives/Documentation/Component_1.st",
                "src/showcase/app/src/ComponentsRexrothDrives/Documentation/Component_2.st",
                "src/components.rexroth.drives/docs/README.md",
                "src/components.rexroth.drives/docs/Component_1.md",
                "src/components.rexroth.drives/docs/Component_2.md",
                "src/components.rexroth.drives/docs/TROUBLES.md",
                "src/components.rexroth.drives/ctrl/src/AxoIndraDrive/AxoIndraDrive.st",
                "src/components.rexroth.drives/ctrl/src/AxoCtrlxDriveXsc/AxoCtrlxDriveXsc.st",
                "src/components.rexroth.drives/ctrl/apax.yml",
            ]
        },

        // ── Vendor Components: Tightening ───────────────────────────────
        new()
        {
            Route = "/DesoutterTightening/Documentation",
            PageTitle = "Desoutter Tightening",
            LibraryNamespace = "AXOpen.Components.Desoutter.Tightening",
            Category = "Vendor Components",
            Vendor = "Desoutter",
            Description = "Practical reference for integrating Desoutter tightening controllers in SIMATIC AX applications.",
            Icon = "document-text",
            Tags = ["Desoutter", "tightening", "torque", "screw", "fastening"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsDesoutterTightening/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsDesoutterTightening/Documentation/Component_1.st",
                "src/components.desoutter.tightening/docs/README.md",
                "src/components.desoutter.tightening/docs/Component_1.md",
                "src/components.desoutter.tightening/docs/Component_2.md",
                "src/components.desoutter.tightening/docs/TROUBLES.md",
                "src/components.desoutter.tightening/ctrl/src/CVIC_II/AxoCVIC_II.st",
                "src/components.desoutter.tightening/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/RexrothTightening/Documentation",
            PageTitle = "Rexroth Tightening",
            LibraryNamespace = "AXOpen.Components.Rexroth.Tightening",
            Category = "Vendor Components",
            Vendor = "Bosch Rexroth",
            Description = "Practical reference for integrating Bosch Rexroth tightening controllers in SIMATIC AX applications.",
            Icon = "document-text",
            Tags = ["Rexroth", "Bosch", "tightening", "torque", "screw", "fastening"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsRexrothTightening/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsRexrothTightening/Documentation/Component_1.st",
                "src/showcase/app/src/ComponentsRexrothTightening/Documentation/Component_2.st",
                "src/components.rexroth.tightening/docs/README.md",
                "src/components.rexroth.tightening/docs/Component_1.md",
                "src/components.rexroth.tightening/docs/Component_2.md",
                "src/components.rexroth.tightening/docs/TROUBLES.md",
                "src/components.rexroth.tightening/ctrl/src/Axo_CS351_compact/Axo_CS351_compact.st",
                "src/components.rexroth.tightening/ctrl/apax.yml",
            ]
        },

        // ── Vendor Components: Other ────────────────────────────────────
        new()
        {
            Route = "/DukaneWelders/Documentation",
            PageTitle = "Dukane Welders",
            LibraryNamespace = "AXOpen.Components.Dukane.Welders",
            Category = "Vendor Components",
            Vendor = "Dukane",
            Description = "Practical reference for integrating Dukane welders in SIMATIC AX applications.",
            Icon = "document-text",
            Tags = ["Dukane", "welder", "welding", "ultrasonic"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsDukaneWelders/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsDukaneWelders/Documentation/Component_1.st",
                "src/showcase/app/src/ComponentsDukaneWelders/Documentation/Component_2.st",
                "src/components.dukane.welders/docs/README.md",
                "src/components.dukane.welders/docs/Component_1.md",
                "src/components.dukane.welders/docs/Component_2.md",
                "src/components.dukane.welders/docs/TROUBLES.md",
                "src/components.dukane.welders/ctrl/src/AxoIQSeriesWelder/Axo_IQ_SeriesWelder.st",
                "src/components.dukane.welders/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/RexrothPress/Documentation",
            PageTitle = "Rexroth Press",
            LibraryNamespace = "AXOpen.Components.Rexroth.Press",
            Category = "Vendor Components",
            Vendor = "Bosch Rexroth",
            Description = "Practical reference for integrating Bosch Rexroth Smart Function Kit press systems in SIMATIC AX applications.",
            Icon = "document-text",
            Tags = ["Rexroth", "Bosch", "press", "Smart Function Kit", "force"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsRexrothPress/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsRexrothPress/Documentation/Component_1.st",
                "src/components.rexroth.press/docs/README.md",
                "src/components.rexroth.press/docs/Component_1.md",
                "src/components.rexroth.press/docs/TROUBLES.md",
                "src/components.rexroth.press/ctrl/src/AxoSmartFunctionKit_v_4_x_x.st",
                "src/components.rexroth.press/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/SiemCommunication/Documentation",
            PageTitle = "Siemens Communication",
            LibraryNamespace = "AXOpen.Components.Siem.Communication",
            Category = "Vendor Components",
            Vendor = "Siemens",
            Description = "Point-to-point serial communication via Siemens ET200SP CM PtP module.",
            Icon = "document-text",
            Tags = ["Siemens", "communication", "serial", "PtP", "ET200SP", "point-to-point"],
            SourceFilePaths = [
                "src/showcase/app/src/ComponentsSiemCommunication/Documentation/DocumentationContext.st",
                "src/showcase/app/src/ComponentsSiemCommunication/Documentation/Component_1.st",
                "src/components.siem.communication/docs/README.md",
                "src/components.siem.communication/docs/Component_1.md",
                "src/components.siem.communication/docs/TROUBLES.md",
            ]
        },

        // ── Foundation / Tooling ────────────────────────────────────────
        new()
        {
            Route = "/Abstractions/Documentation",
            PageTitle = "Abstractions",
            LibraryNamespace = "AXOpen.Abstractions",
            Category = "Foundation",
            Description = "Core interfaces and enums: IAxoContext, IAxoObject, IAxoMessenger, IAxoLogger, IAxoRtc, IAxoRtm, eAxoMessageCategory, and eLogLevel.",
            Icon = "document-text",
            Tags = ["abstractions", "interface", "IAxoContext", "IAxoObject", "IAxoMessenger", "IAxoLogger"],
            SourceFilePaths = [
                "src/showcase/app/src/Foundation/AbstractionsShowcase.st",
                "src/abstractions/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/Inspectors/Documentation",
            PageTitle = "Inspectors",
            LibraryNamespace = "AXOpen.Inspectors",
            Category = "Foundation",
            Description = "Digital, analogue, and data inspectors with configurable pass/fail times, result aggregation, and failure-handling strategies (carry on, retry, dialog).",
            Icon = "document-text",
            Tags = ["inspector", "inspection", "digital", "analogue", "pass", "fail", "quality"],
            SourceFilePaths = [
                "src/showcase/app/src/Foundation/InspectorsShowcase.st",
                "src/inspectors/docs/README.md",
                "src/inspectors/docs/AXODIGITALINSPECTOR.md",
                "src/inspectors/docs/AXOANALOGUEINSPECTOR.md",
                "src/inspectors/docs/AXODATAINSPECTOR.md",
            ]
        },
        new()
        {
            Route = "/Io/Documentation",
            PageTitle = "I/O",
            LibraryNamespace = "AXOpen.Showcase.Io",
            Category = "Foundation",
            Description = "Documentation snippets for showcasing I/O patterns with inline code examples and live PLC context views.",
            Icon = "document-text",
            Tags = ["I/O", "IO", "input", "output", "hardware"],
            SourceFilePaths = [
                "src/showcase/app/src/Foundation/IoShowcase.st",
            ]
        },
        new()
        {
            Route = "/Probers/Documentation",
            PageTitle = "Probers",
            LibraryNamespace = "AXOpen.Probers",
            Category = "Foundation",
            Description = "Test probing utilities for cyclic and conditional test execution. AxoProberWithCounterBase runs for N cycles; AxoProberWithCompletedCondition runs until a condition is met.",
            Icon = "document-text",
            Tags = ["prober", "test", "cyclic", "probe", "condition"],
            SourceFilePaths = [
                "src/showcase/app/src/Foundation/ProbersShowcase.st",
                "src/probers/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/Simatic1500/Documentation",
            PageTitle = "SIMATIC S7-1500",
            LibraryNamespace = "AXOpen.S71500",
            Category = "Foundation",
            Description = "Platform-specific implementations of IAxoRtc (real-time clock) and IAxoRtm (runtime measurement) for the SIMATIC S7-1500 PLC family.",
            Icon = "document-text",
            Tags = ["S7-1500", "SIMATIC", "RTC", "real-time clock", "runtime", "platform"],
            SourceFilePaths = [
                "src/showcase/app/src/Foundation/Simatic1500Showcase.st",
                "src/simatic1500/ctrl/src/Rtc.st",
                "src/simatic1500/ctrl/src/Rtm.st",
                "src/simatic1500/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/Timers/Documentation",
            PageTitle = "Timers",
            LibraryNamespace = "AXOpen.Timers",
            Category = "Foundation",
            Description = "OnDelayTimer, OffDelayTimer, PulseTimer, and AxoBlinker for time-based control logic.",
            Icon = "document-text",
            Tags = ["timer", "delay", "pulse", "blinker", "TON", "TOF", "TP"],
            SourceFilePaths = [
                "src/showcase/app/src/Foundation/TimersShowcase.st",
                "src/timers/ctrl/apax.yml",
            ]
        },
        new()
        {
            Route = "/Utils/Documentation",
            PageTitle = "Utils",
            LibraryNamespace = "AXOpen.Utils",
            Category = "Foundation",
            Description = "String building with AxoStringBuilder and CRC checksum functions (CRC-8, CRC-16, CRC-32) for data integrity verification.",
            Icon = "document-text",
            Tags = ["utils", "string", "CRC", "checksum", "builder"],
            SourceFilePaths = [
                "src/showcase/app/src/Foundation/UtilsShowcase.st",
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
