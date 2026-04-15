USING AXOpen.Core;

NAMESPACE AXOpen.Components.Balluff.Identification
    {S7.extern=ReadWrite}
    CLASS Axo_BIS_M_4XX_045_Example EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC
            ExampleReader : AXOpen.Components.Balluff.Identification.Axo_BIS_M_4XX_045;
        END_VAR
        //</ComponentDeclaration>

        //<InitializationArgumentsDeclaration>
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl : BOOL;
        END_VAR
        //</InitializationArgumentsDeclaration>

        METHOD PUBLIC OVERRIDE Run
            VAR_INPUT
                inParent : IAxoObject;
            END_VAR

            SUPER.Run(inParent);

            IF ActivateManualControl THEN
                ExampleReader.ActivateManualControl();
            END_IF;

            //<Initialization>
            ExampleReader.Run(  inParent := THIS,
                                hwID     := AXOpen.Showcase.HwIdentifiers#BNIPNT507005Z040_HwID);
            //</Initialization>

            THIS.UseInSequencer();
        END_METHOD

        //<Usage>
        VAR PUBLIC
            Sequencer : AxoSequencer;
            Steps     : ARRAY[0..7] OF AXOpen.Core.AxoStep;
        END_VAR

        METHOD PRIVATE UseInSequencer

            Sequencer.Run(THIS);
            Sequencer.Open();
            Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;

            IF(Steps[0].Execute(Sequencer, 'Configure and restore reader')) THEN
                ExampleReader.Config.InfoTime      := LTIME#2S;
                ExampleReader.Config.ErrorTime     := LTIME#5S;
                ExampleReader.Config.TaskTimeout   := LTIME#50S;
                ExampleReader.Config.StartAddress  := WORD#0;
                ExampleReader.Config.RfidCodeSize  := WORD#50;
                ExampleReader.Restore();
                Sequencer.MoveNext();
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Reset reader')) THEN
                IF(ExampleReader.ResetReader().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'Read tag data')) THEN
                IF(ExampleReader.Read().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[3].Execute(Sequencer, 'Write tag data')) THEN
                IF(ExampleReader.Write().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[4].Execute(Sequencer, 'Write single char to memory')) THEN
                IF(ExampleReader.WriteCharToMemory(character     := BYTE#16#41,  // 'A'
                                                   Address       := WORD#0,
                                                   NumberOfBytes := WORD#1
                                                   ).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[5].Execute(Sequencer, 'Reset communication')) THEN
                IF(ExampleReader.ResetCommunication().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[6].Execute(Sequencer, 'Error recovery')) THEN
                ExampleReader.Restore();
                Sequencer.MoveNext();
            END_IF;

            IF(Steps[7].Execute(Sequencer, 'Complete')) THEN
                Sequencer.CompleteSequence();
            END_IF;
        END_METHOD
        //</Usage>
    END_CLASS
END_NAMESPACE
