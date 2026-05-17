USING AXOpen.Core;
USING AXOpen.Data;
USING AXOpen.Logging;
USING AXOpen.Messaging;
USING AXOpen.Messaging.Static;

// ============================================================
// ShowcaseContext — Documentation AxoContext for the showcase app.
// Contains documentation examples and core objects.
// Sandbox/testing objects have been moved to src/sandbox/app.
// ============================================================

{S7.extern=ReadWrite}
CLASS ShowcaseContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        // ---- Core: AxoTask ----
        AxoTasks : AxoTaskExamples.Tasks;
        AxoTaskDocu : AxoTaskExamples.AxoTaskDocuExample;

        // ---- Core: AxoToggleTask ----
        AxoToggleTasks : AxoToggleTaskExamples.Tasks;
        AxoToggleTaskDocu : AxoToggleTaskExamples.AxoToggleTaskDocuExample;

        // ---- Core: AxoMomentaryTask ----
        AxoMomentaryTasks : AxoMomentaryTaskExamples.Tasks;
        AxoMomentaryTaskDocu : AxoMomentaryTaskExamples.AxoMomentaryTaskDocuExample;

        // ---- Core: AxoSequencer ----
        AxoSequencers : AxoSequencerExamples.SequencerExample;

        // ---- Core: AxoSequencerContainer ----
        AxoSequencerContainer : AxoSequencerContainerExamples.SequencerContainerExample;

        // ---- Core: AxoComponent ----
        myComponentExample : AxoComponentExamples.ComponentExampleContext;
        myComponentHeaderOnlyExample : AxoComponentExamples.ComponentHeaderOnlyExampleContext;

        // ---- Core: AxoRemoteTask ----
        AxoRemoteTasks : AxoRemoteTaskExamples.RemoteTasks;

        // ---- Core: AxoMessaging ----
        AxoMessengers : AxoStaticMessengerExample.Messengers;
        AxoMessengersDocu : AxoStaticMessengerDocuExample.Messengers;

        // ---- Core: AxoTextList ----
        AxoTextListExampleContext : AxoTextListExample.AxoTextListExampleContext;

        // ---- Core: AxoByteArray ----
        AxoByteArrayExampleContext : AxoByteArrayExample.AxoByteArrayExampleContext;

        // ---- Core: AxoBoolArray ----
        AxoBoolArrayExampleContext : AxoBoolArrayExample.AxoBoolArrayExampleContext;

        // ---- Core: AxoLogger ----
        AxoLoggers : AxoLoggerExamples.Loggers;

        // ---- Core: AxoDialogs ----
        AxoDialogs : AxoDialogExamples.Dialogs;

        // ---- Core: AxoAlert ----
        AxoAlertDocu : AxoAlertExamples.AxoAlertDocuExample;

        // ---- Data ----
        AxoDataExchangeContext : AxoDataExchangeExample.Context;
        AxoDataFragmentsExchangeContext : AxoDataFramentsExchangeExample.Context;
        AxoDataPersistentContext : AxoDataPersistentExchangeExample.Context;
        AxoDataDistributedContext : AxoDataDistributedExample.Context;

        // ---- Components.Drives ----
        drives_documentation : AXOpen.Components.Drives.DrivesShowcase;

        // ---- Components.Elements ----
        elements_documentation : AXOpen.Components.Elements.ElementsShowcase;

        // ---- Components.Pneumatics ----
        pneumatics_documentation : AXOpen.Showcase.Pneumatics.PneumaticsShowcase;

        // ---- Components.Robotics ----
        robotics_documentation : AXOpen.Components.Robotics.RoboticsShowcase;

        // ---- Foundation ----
        abstractions_documentation : AXOpen.Showcase.Abstractions.AbstractionsShowcase;
        components_abstractions_documentation : AXOpen.Showcase.ComponentsAbstractions.ComponentsAbstractionsShowcase;
        inspectors_documentation : AXOpen.Showcase.Inspectors.InspectorsShowcase;
        io_documentation : AXOpen.Showcase.Io.IoShowcase;
        probers_documentation : AXOpen.Showcase.Probers.ProbersShowcase;
        simatic1500_documentation : AXOpen.Showcase.Simatic1500.Simatic1500Showcase;
        timers_documentation : AXOpen.Showcase.Timers.TimersShowcase;
        utils_documentation : AXOpen.Showcase.Utils.UtilsShowcase;

        // ---- Components.Abb.Robotics ----
        abb_robotics_documentation : AXOpen.Components.Abb.Robotics.AbbRobotics;

        // ---- Components.Balluff.Identification ----
        balluff_identification_documentation : AXOpen.Components.Balluff.Identification.BalluffIdentification;

        // ---- Components.Cognex.Vision ----
        cognex_vision_documentation : AXOpen.Components.Cognex.Vision.CognexVision;

        // ---- Components.Desoutter.Tightening ----
        desoutter_tightening_documentation : AXOpen.Components.Desoutter.Tightening.DesoutterTightening;

        // ---- Components.Dukane.Welders ----
        dukane_welders_documentation : AXOpen.Components.Dukane.Welders.DukaneWelders;

        // ---- Components.Festo.Drives ----
        festo_drives_documentation : AXOpen.Components.Festo.Drives.FestoDrives;

        // ---- Components.Keyence.Vision ----
        keyence_vision_documentation : AXOpen.Components.Keyence.Vision.KeyenceVision;

        // ---- Components.Kuka.Robotics ----
        kuka_robotics_documentation : AXOpen.Components.Kuka.Robotics.KukaRobotics;

        // ---- Components.Mitsubishi.Robotics ----
        mitsubishi_robotics_documentation : AXOpen.Components.Mitsubishi.Robotics.MitsubishiRobotics;

        // ---- Components.Rexroth.Drives ----
        rexroth_drives_documentation : AXOpen.Components.Rexroth.Drives.RexrothDrives;

        // ---- Components.Rexroth.Press ----
        rexroth_press_documentation : AXOpen.Components.Rexroth.Press.RexrothPress;

        // ---- Components.Rexroth.Tightening ----
        rexroth_tightening_documentation : AXOpen.Components.Rexroth.Tightening.RexrothTightening;

        // ---- Components.Siem.Communication ----
        siem_communication_documentation : AXOpen.Components.Siem.Communication.SiemCommunication;

        // ---- Components.Siem.Identification ----
        siem_identification_documentation : AXOpen.Components.Siem.Identification.SiemIdentification;

        // ---- Components.Ur.Robotics ----
        ur_robotics_documentation : AXOpen.Components.Ur.Robotics.UrRobotics;

        // ---- Components.Zebra.Vision ----
        zebra_vision_documentation : AXOpen.Components.Zebra.Vision.ZebraVision;
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        // --- Core ---
        THIS.InitializeRootObject(AxoTasks);
        AxoTasks.Execute();

        THIS.InitializeRootObject(AxoTaskDocu);
        AxoTaskDocu.Execute();

        THIS.InitializeRootObject(AxoToggleTasks);
        AxoToggleTasks.Execute();

        THIS.InitializeRootObject(AxoToggleTaskDocu);
        AxoToggleTaskDocu.Execute();

        THIS.InitializeRootObject(AxoMomentaryTasks);
        AxoMomentaryTasks.Execute();

        THIS.InitializeRootObject(AxoMomentaryTaskDocu);
        AxoMomentaryTaskDocu.Execute();

        THIS.InitializeRootObject(AxoSequencers);
        AxoSequencers.Execute();

        AxoSequencerContainer.Run(AxoSequencers);

        THIS.InitializeRootObject(myComponentExample);
        myComponentExample.Execute();

        THIS.InitializeRootObject(myComponentHeaderOnlyExample);
        myComponentHeaderOnlyExample.Execute();

        THIS.InitializeRootObject(AxoRemoteTasks);
        AxoRemoteTasks.Execute();

        THIS.InitializeRootObject(AxoMessengers);
        AxoMessengers.Execute();

        THIS.InitializeRootObject(AxoMessengersDocu);
        AxoMessengersDocu.Execute();

        THIS.InitializeRootObject(AxoTextListExampleContext);
        AxoTextListExampleContext.Execute();

        THIS.InitializeRootObject(AxoByteArrayExampleContext);
        AxoByteArrayExampleContext.Execute();

        THIS.InitializeRootObject(AxoBoolArrayExampleContext);
        AxoBoolArrayExampleContext.Execute();

        THIS.InitializeRootObject(AxoLoggers);
        AxoLoggers.Execute();

        THIS.InitializeRootObject(AxoDialogs);
        AxoDialogs.Execute();

        THIS.InitializeRootObject(AxoAlertDocu);
        AxoAlertDocu.Execute();

        // --- Data ---
        THIS.InitializeRootObject(AxoDataExchangeContext);
        AxoDataExchangeContext.Execute();

        THIS.InitializeRootObject(AxoDataFragmentsExchangeContext);
        AxoDataFragmentsExchangeContext.Execute();

        THIS.InitializeRootObject(AxoDataPersistentContext);
        AxoDataPersistentContext.Execute();

        THIS.InitializeRootObject(AxoDataDistributedContext);
        AxoDataDistributedContext.Execute();

        // --- Components ---
        THIS.InitializeRootObject(drives_documentation);
        drives_documentation.Execute();

        THIS.InitializeRootObject(elements_documentation);
        elements_documentation.Execute();

        THIS.InitializeRootObject(pneumatics_documentation);
        pneumatics_documentation.Execute();

        THIS.InitializeRootObject(robotics_documentation);
        robotics_documentation.Execute();

        // --- Foundation ---
        THIS.InitializeRootObject(abstractions_documentation);
        abstractions_documentation.Execute();

        THIS.InitializeRootObject(components_abstractions_documentation);
        components_abstractions_documentation.Execute();

        THIS.InitializeRootObject(inspectors_documentation);
        inspectors_documentation.Execute();

        THIS.InitializeRootObject(io_documentation);
        io_documentation.Execute();

        THIS.InitializeRootObject(probers_documentation);
        probers_documentation.Execute();

        THIS.InitializeRootObject(simatic1500_documentation);
        simatic1500_documentation.Execute();

        THIS.InitializeRootObject(timers_documentation);
        timers_documentation.Execute();

        THIS.InitializeRootObject(utils_documentation);
        utils_documentation.Execute();

        // --- Vendor Components ---
        THIS.InitializeRootObject(abb_robotics_documentation);
        abb_robotics_documentation.Execute();

        THIS.InitializeRootObject(balluff_identification_documentation);
        balluff_identification_documentation.Execute();

        THIS.InitializeRootObject(cognex_vision_documentation);
        cognex_vision_documentation.Execute();

        THIS.InitializeRootObject(desoutter_tightening_documentation);
        desoutter_tightening_documentation.Execute();

        THIS.InitializeRootObject(dukane_welders_documentation);
        dukane_welders_documentation.Execute();

        THIS.InitializeRootObject(festo_drives_documentation);
        festo_drives_documentation.Execute();

        THIS.InitializeRootObject(keyence_vision_documentation);
        keyence_vision_documentation.Execute();

        THIS.InitializeRootObject(kuka_robotics_documentation);
        kuka_robotics_documentation.Execute();

        THIS.InitializeRootObject(mitsubishi_robotics_documentation);
        mitsubishi_robotics_documentation.Execute();

        THIS.InitializeRootObject(rexroth_drives_documentation);
        rexroth_drives_documentation.Execute();

        THIS.InitializeRootObject(rexroth_press_documentation);
        rexroth_press_documentation.Execute();

        THIS.InitializeRootObject(rexroth_tightening_documentation);
        rexroth_tightening_documentation.Execute();

        THIS.InitializeRootObject(siem_communication_documentation);
        siem_communication_documentation.Execute();

        THIS.InitializeRootObject(siem_identification_documentation);
        siem_identification_documentation.Execute();

        THIS.InitializeRootObject(ur_robotics_documentation);
        ur_robotics_documentation.Execute();

        THIS.InitializeRootObject(zebra_vision_documentation);
        zebra_vision_documentation.Execute();
    END_METHOD
END_CLASS
