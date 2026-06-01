USING AXOpen.Core;
NAMESPACE AXOpen.Showcase.Io
    {S7.extern=ReadWrite}
    CLASS AxoIoComponent_Showcase EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#IO Module 1#>"}
            AxoIoComponent_ : AXOpen.Io.AxoIoComponent;
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
                AxoIoComponent_.ActivateManualControl();
            END_IF;

            //<Initialization>
            AxoIoComponent_.Run(inParent := inParent,
                                hwID     := AXOpen.Showcase.HwIdentifiers#plc_line_HwID);
            //</Initialization>

            THIS.UseInSequencer();
        END_METHOD

        //<Usage>
        VAR PUBLIC
            Sequencer : AxoSequencer;
            Steps : ARRAY[0..3] OF AXOpen.Core.AxoStep;
        END_VAR

        METHOD PRIVATE UseInSequencer

            Sequencer.Run(THIS);
            Sequencer.Open();

            // Step 0: Restore component to initial state
            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                manualControl := FALSE;
                AxoIoComponent_.Restore();
                Sequencer.MoveNext();
            END_IF;

            // Step 1: Trigger hardware diagnostics
            IF(Steps[1].Execute(Sequencer, 'Read hardware diagnostics')) THEN
                IF(AxoIoComponent_.HardwareDiagnosticsTask.IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Step 2: Check sub-diagnostics
            IF(Steps[2].Execute(Sequencer, 'Read hardware sub-diagnostics')) THEN
                IF(AxoIoComponent_.HardwareSubDiagnosticsTask.IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Step 3: Complete
            IF(Steps[3].Execute(Sequencer, 'Complete')) THEN
                AxoIoComponent_.Restore();
                Sequencer.CompleteSequence();
            END_IF;
        END_METHOD
        //</Usage>
    END_CLASS
END_NAMESPACE
