USING AXOpen.Core;
NAMESPACE AXOpen.Showcase.Io
    {S7.extern=ReadWrite}
    CLASS AxoIOLinkET200SP_Balluff_IO_Showcase EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#ET200SP Balluff IO-Link Module#>"}
            AxoIOLinkET200SP_ : AXOpen.Io.AxoIOLinkET200SP_Balluff_IO;
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
                AxoIOLinkET200SP_.ActivateManualControl();
            END_IF;

            //<Initialization>
            AxoIOLinkET200SP_.Run(inParent := inParent,
                                  hwID     := AXOpen.Showcase.HwIdentifiers#plc_line_HwID,
                                  Port_1   := AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099,
                                  Port_2   := AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI0099,
                                  Port_3   := AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#BNI00AY,
                                  Port_4   := AXOpen.Io.eAxoIOLinkET200SP_Balluff_PortConfig#NONE);
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

            // Step 0: Restore
            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                manualControl := FALSE;
                AxoIOLinkET200SP_.Restore();
                Sequencer.MoveNext();
            END_IF;

            // Step 1: Wait for port configuration to complete
            IF(Steps[1].Execute(Sequencer, 'Configure IO-Link ports')) THEN
                IF(AxoIOLinkET200SP_.ConfigTask.IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Step 2: Read hardware diagnostics
            IF(Steps[2].Execute(Sequencer, 'Read hardware diagnostics')) THEN
                IF(AxoIOLinkET200SP_.HardwareDiagnosticsTask.IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            // Step 3: Complete
            IF(Steps[3].Execute(Sequencer, 'Complete')) THEN
                AxoIOLinkET200SP_.Restore();
                Sequencer.CompleteSequence();
            END_IF;
        END_METHOD
        //</Usage>
    END_CLASS
END_NAMESPACE
