USING AXOpen.Core;

NAMESPACE AXOpen.Components.Drives

    {S7.extern=ReadWrite}
    CLASS AxoDriveExample_Showcase2 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC
            AxoDrive_ : AXOpen.Components.Drives.AxoDriveExample;
        END_VAR
        //</ComponentDeclaration>

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC
            AxisRef         :   AxoDriveAxisReferenceExample;
            Enable          :   BOOL;                       //  As long as 'Enable' is true, power is being enabled.
            EnablePositive  :   BOOL;                       //  As long as 'Enable' is true, this permits motion in positive direction
            EnableNegative  :   BOOL;                       //  As long as 'Enable' is true, this permits motion in negative direction
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
            Steps : ARRAY[0..7] OF AXOpen.Core.AxoStep;
        END_VAR

        METHOD PRIVATE UseInSequencer

            Sequencer.Run(THIS);
            Sequencer.Open();
            Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;

            IF(Steps[0].Execute(Sequencer, 'Restore and configure')) THEN
                AxoDrive_.DriveConfig.InfoTime              := LTIME#2S;
                AxoDrive_.DriveConfig.ErrorTime              := LTIME#5S;
                AxoDrive_.DriveConfig.TaskTimeout            := LTIME#50S;
                AxoDrive_.DriveConfig.InTorqueWindowPerCent  := LREAL#5.0;
                AxoDrive_.DriveConfig.InTorqueWindowTime     := LTIME#100MS;
                AxoDrive_.Restore();
                Sequencer.MoveNext();
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Reset drive')) THEN
                IF(AxoDrive_.AxoReset().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'Write parameter')) THEN
                IF(AxoDrive_.AxoWriteParameter(ParameterNumber := DINT#100,
                                               Value           := LINT#500,
                                               ExecutionMode   := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately
                                               ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[3].Execute(Sequencer, 'Write real parameter')) THEN
                IF(AxoDrive_.AxoWriteRealParameter(ParameterNumber := DINT#101,
                                                   Value           := REAL#3.14,
                                                   ExecutionMode   := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately
                                                   ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[4].Execute(Sequencer, 'Write bool parameter')) THEN
                IF(AxoDrive_.AxoWriteBoolParameter(ParameterNumber := DINT#200,
                                                   Value           := TRUE,
                                                   ExecutionMode   := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately
                                                   ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[5].Execute(Sequencer, 'Write digital output')) THEN
                IF(AxoDrive_.AxoWriteDigitalOutput(OutputNumber  := INT#1,
                                                   Value         := TRUE,
                                                   ExecutionMode := AXOpen.Components.Abstractions.Drives.eAxoExecutionMode#Immediately
                                                   ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[6].Execute(Sequencer, 'Reset drive')) THEN
                IF(AxoDrive_.AxoReset().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[7].Execute(Sequencer, 'Restore')) THEN
                AxoDrive_.Restore();
                Sequencer.CompleteSequence();
            END_IF;
        END_METHOD

        //</Usage>
    END_CLASS
END_NAMESPACE
