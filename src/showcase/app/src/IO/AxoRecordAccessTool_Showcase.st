USING AXOpen.Core;
NAMESPACE AXOpen.Showcase.Io
    {S7.extern=ReadWrite}
    CLASS AxoRecordAccessTool_Showcase EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Record Access Tool#>"}
            AxoRecordAccessTool_ : AXOpen.Io.AxoRecordAccessTool;
        END_VAR
        //</ComponentDeclaration>

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC
            manualControl : BOOL;
        END_VAR
        //</InitializationArgumentsDeclaration>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);

            IF(manualControl) THEN
                AxoRecordAccessTool_.ActivateManualControl();
            END_IF;

            //<Initialization>
            AxoRecordAccessTool_.Run(inParent := inParent);
            //</Initialization>

            THIS.UseInSequencer();
        END_METHOD

        //<Usage>
        VAR PUBLIC
            Sequencer : AxoSequencer;
            Steps : ARRAY[0..4] OF AXOpen.Core.AxoStep;
        END_VAR

        METHOD PRIVATE UseInSequencer

            Sequencer.Run(THIS);
            Sequencer.Open();

            // Step 0: Restore
            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                manualControl := FALSE;
                AxoRecordAccessTool_.Restore();
                Sequencer.MoveNext();
            END_IF;

            // Step 1: Configure record access parameters
            IF(Steps[1].Execute(Sequencer, 'Configure record parameters')) THEN
                AxoRecordAccessTool_.hardwareID := AXOpen.Showcase.HwIdentifiers#plc_line_HwID;
                AxoRecordAccessTool_.index      := DINT#1;    // Record index to access
                AxoRecordAccessTool_.length     := UINT#255;  // Max record length
                Sequencer.MoveNext();
            END_IF;

            // Step 2: Read record from device
            IF(Steps[2].Execute(Sequencer, 'Read device record')) THEN
                IF(AxoRecordAccessTool_.ReadRecordTask.IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Step 3: Write record back to device
            IF(Steps[3].Execute(Sequencer, 'Write device record')) THEN
                IF(AxoRecordAccessTool_.WriteRecordTask.IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Step 4: Complete
            IF(Steps[4].Execute(Sequencer, 'Complete')) THEN
                AxoRecordAccessTool_.Restore();
                Sequencer.CompleteSequence();
            END_IF;
        END_METHOD
        //</Usage>
    END_CLASS
END_NAMESPACE
