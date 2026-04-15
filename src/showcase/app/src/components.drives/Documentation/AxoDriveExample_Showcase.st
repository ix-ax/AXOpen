USING AXOpen.Core;

NAMESPACE AXOpen.Components.Drives
    
    {S7.extern=ReadWrite}
    CLASS AxoDriveExample_Showcase EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            AxoDrive_ : AXOpen.Components.Drives.AxoDriveExample;      
        END_VAR
        //</ComponentDeclaration>                          

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC                
            AxisRef         :   AxoDriveAxisReferenceExample;
            Enable          :   BOOL;                       //  As long as ‘Enable’ is true, power is being enabled.
            EnablePositive  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in positive direction
            EnableNegative  :   BOOL;                       //  As long as ‘Enable’ is true, this permits motion in negative direction
        END_VAR
        //</InitializationArgumentsDeclaration>            

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR    

            SUPER.Run(inParent);

            //<Initialization>        
            AxoDrive_.Run(THIS, AxisRef, Enable, EnablePositive, EnableNegative);        
            //</Initialization>

        THIS.UseInSequencer();
        END_METHOD

        //<Usage>
        VAR PUBLIC
            Sequencer : AxoSequencer;
            Steps : ARRAY[0..12] OF AXOpen.Core.AxoStep;
        END_VAR

        METHOD PRIVATE UseInSequencer

            Sequencer.Run(THIS);
            Sequencer.Open();
            Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;

            IF(Steps[0].Execute(Sequencer, 'Restore and configure')) THEN
                AxoDrive_.DriveConfig.InfoTime    := LTIME#2S;
                AxoDrive_.DriveConfig.ErrorTime   := LTIME#5S;
                AxoDrive_.DriveConfig.TaskTimeout := LTIME#50S;
                AxoDrive_.Restore();
                Sequencer.MoveNext();
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Reset drive')) THEN
                IF(AxoDrive_.AxoReset().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'Drive homing')) THEN
                IF(AxoDrive_.AxoHome(Position     := LREAL#0.0,
                                     HommingMode  := INT#10,
                                     Velocity     := LREAL#10.0,
                                     Acceleration := LREAL#50.0,
                                     Deceleration := LREAL#50.0
                                     ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[3].Execute(Sequencer, 'Move absolute to position 100')) THEN
                IF(AxoDrive_.AxoMoveAbsolute(ContinuousUpdate := FALSE,
                                             Position         := LREAL#100.0,
                                             Velocity         := LREAL#50.0,
                                             Acceleration     := LREAL#100.0,
                                             Deceleration     := LREAL#100.0,
                                             Jerk             := LREAL#0.0,
                                             Direction        := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection
                                             ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[4].Execute(Sequencer, 'Move relative distance 50')) THEN
                IF(AxoDrive_.AxoMoveRelative(ContinuousUpdate := FALSE,
                                             Distance         := LREAL#50.0,
                                             Velocity         := LREAL#25.0,
                                             Acceleration     := LREAL#100.0,
                                             Deceleration     := LREAL#100.0,
                                             Jerk             := LREAL#0.0
                                             ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[5].Execute(Sequencer, 'Move additive distance 10')) THEN
                IF(AxoDrive_.AxoMoveAdditive(ContinuousUpdate := FALSE,
                                             Distance         := LREAL#10.0,
                                             Velocity         := LREAL#25.0,
                                             Acceleration     := LREAL#100.0,
                                             Deceleration     := LREAL#100.0,
                                             Jerk             := LREAL#0.0
                                             ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[6].Execute(Sequencer, 'Move velocity continuous')) THEN
                IF(AxoDrive_.AxoMoveVelocity(ContinuousUpdate := FALSE,
                                             Velocity         := LREAL#30.0,
                                             Acceleration     := LREAL#100.0,
                                             Deceleration     := LREAL#100.0,
                                             Jerk             := LREAL#0.0,
                                             Direction        := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection
                                             ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[7].Execute(Sequencer, 'Halt movement')) THEN
                IF(AxoDrive_.AxoHalt(Deceleration := LREAL#200.0,
                                     Jerk         := LREAL#0.0
                                     ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[8].Execute(Sequencer, 'Torque control')) THEN
                IF(AxoDrive_.AxoTorqueControl(ContinuousUpdate := FALSE,
                                              Torque           := LREAL#5.0,
                                              TorqueRamp       := LREAL#10.0,
                                              PositionLimit    := LREAL#200.0,
                                              Velocity         := LREAL#10.0,
                                              Acceleration     := LREAL#50.0,
                                              Deceleration     := LREAL#50.0,
                                              Jerk             := LREAL#0.0,
                                              Direction        := AXOpen.Components.Abstractions.Drives.eAxoDriveDirection#PositiveDirection
                                              ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[9].Execute(Sequencer, 'Stop movement')) THEN
                IF(AxoDrive_.AxoStop(Deceleration := LREAL#200.0,
                                     Jerk         := LREAL#0.0
                                     ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[10].Execute(Sequencer, 'Set position')) THEN
                IF(AxoDrive_.AxoSetPosition(Position      := LREAL#0.0,
                                            Relative      := FALSE,
                                            ExecutionMode := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately
                                            ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[11].Execute(Sequencer, 'Reset drive')) THEN
                IF(AxoDrive_.AxoReset().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[12].Execute(Sequencer, 'Restore')) THEN
                AxoDrive_.Restore();
                Sequencer.CompleteSequence();
            END_IF;
        END_METHOD

        //</Usage>
    END_CLASS
END_NAMESPACE