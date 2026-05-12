USING AXOpen.Core;
USING AXOpen.Components.Abstractions.Robotics;

NAMESPACE AXOpen.Components.Kuka.Robotics.v_5_x_x
    {S7.extern=ReadWrite}
    CLASS AxoKrc4_v_5_x_x_ManualControl EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC
            ManualRobot : AXOpen.Components.Kuka.Robotics.v_5_x_x.AxoKrc4;
        END_VAR
        //</ComponentDeclaration>

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC
            manualMovementParams : AXOpen.Components.Abstractions.Robotics.AxoRoboticsMovementsParams;
            {#ix-set:AttributeName = "<#Engage manual control#>"}
            EngageManualControl : BOOL;
            {#ix-set:AttributeName = "<#Trigger manual move (one shot)#>"}
            TriggerManualMove : BOOL;
        END_VAR
        //</InitializationArgumentsDeclaration>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR

            SUPER.Run(inParent);

            ManualRobot.Config.InfoTime    := LTIME#2S;
            ManualRobot.Config.ErrorTime   := LTIME#0S;
            ManualRobot.Config.TaskTimeout := LTIME#0S;

            //<Initialization>
            ManualRobot.Run(inParent := THIS,
                            hwID     := AXOpen.Showcase.HwIdentifiers#kuka_rb1_HwID);
            //</Initialization>

            //<ManualControlActivation>
            // ActivateManualControl() must be called every cycle while the
            // operator drives the component from the HMI. The component
            // bypasses the automatic task pipeline and exposes raw command
            // signals through its dedicated views.
            IF EngageManualControl THEN
                ManualRobot.ActivateManualControl();
            END_IF;
            //</ManualControlActivation>

            //<ManualMoveTrigger>
            // The HMI can pre-load movement parameters and fire a single
            // StartMovements() invocation. When the task completes the
            // operator restores it from its terminal state to be ready
            // for the next manual command.
            IF TriggerManualMove THEN
                manualMovementParams.ActionNo       :=  BYTE#1;
                manualMovementParams.GlobalSpeed    :=  BYTE#10;
                manualMovementParams.ToolNo         :=  BYTE#1;
                manualMovementParams.WorkobjectNo   :=  BYTE#1;
                manualMovementParams.PointNo        :=  BYTE#1;
                IF ManualRobot.StartMovements(manualMovementParams).IsDone() THEN
                    ManualRobot.StartMovementsTask.Restore();
                    TriggerManualMove := FALSE;
                END_IF;
            END_IF;
            //</ManualMoveTrigger>
        END_METHOD
    END_CLASS
END_NAMESPACE
