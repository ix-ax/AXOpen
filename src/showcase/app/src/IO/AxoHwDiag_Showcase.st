USING AXOpen.Core;
NAMESPACE AXOpen.Showcase.Io
    {S7.extern=ReadWrite}
    CLASS AxoHwDiag_Showcase EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Hardware Diagnostics#>"}
            AxoHwDiag_ : AXOpen.Io.AxoHwDiag;
        END_VAR
        //</ComponentDeclaration>

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC
            manualControl : BOOL;
            hwIdList : AXOpen.Showcase.HwIdentifierList;  // List of hardware IDs to diagnose
        END_VAR
        //</InitializationArgumentsDeclaration>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR
            SUPER.Run(inParent);

            IF(manualControl) THEN
                AxoHwDiag_.ActivateManualControl();
            END_IF;

            //<HwDiagConfig>
            AxoHwDiag_.Config.InfoTime     := LTIME#1000ms;
            AxoHwDiag_.Config.ErrorTime    := LTIME#5000ms;
            AxoHwDiag_.Config.TaskTimeout  := LTIME#10000ms;
            //</HwDiagConfig>

            //<Initialization>
            AxoHwDiag_.Run(inParent    := inParent,
                           hwIDsList   := hwIdList);
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

            // Step 0: Restore diagnostics to initial state
            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                manualControl := FALSE;
                AxoHwDiag_.Restore();
                Sequencer.MoveNext();
            END_IF;

            // Step 1: Trigger diagnostic update and wait for completion
            IF(Steps[1].Execute(Sequencer, 'Update diagnostics')) THEN
                IF(AxoHwDiag_.UpdateDiagnosticTask.IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Step 2: Review diagnostic details
            IF(Steps[2].Execute(Sequencer, 'Review diagnostic details')) THEN
                // AxoHwDiag_.AxoHwDiagDetails contains full diagnostic tree:
                // PLC details, IO System details, Station details, Module details, SubModule details
                IF(AxoHwDiag_.Progress >= INT#100) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Step 3: Complete
            IF(Steps[3].Execute(Sequencer, 'Complete')) THEN
                AxoHwDiag_.Restore();
                Sequencer.CompleteSequence();
            END_IF;
        END_METHOD
        //</Usage>
    END_CLASS
END_NAMESPACE
