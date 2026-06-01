USING AXOpen.Core;
NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    CLASS Axo_SR_1000_Showcase EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            Component : AXOpen.Components.Keyence.Vision.Axo_SR_1000;             
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
                Component.ActivateManualControl();
            END_IF;

            //<Initialization>     
            Component.Run(      inParent                                          :=   THIS,
                                hwID                                            :=   AXOpen.Showcase.HwIdentifiers#keyence_sr_1000_HwID);
            //</Initialization>

            THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..4] OF AXOpen.Core.AxoStep;
        END_VAR

        VAR PRIVATE
            _ResultData  :   AXOpen.Components.Keyence.Vision.Axo_SR_1000_ResultData;
        END_VAR

        METHOD PRIVATE UseInSequencer   

            Sequencer.Run(THIS);
            Sequencer.Open();
            Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;

            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                Component.Config.InfoTime    := LTIME#2S;
                Component.Config.ErrorTime   := LTIME#5S;
                Component.Config.TaskTimeout := LTIME#50S;
                Component.Restore();
                Sequencer.MoveNext();
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Clear result data')) THEN
                IF(Component.ClearResultData().IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'Tune')) THEN
                IF(Component.Tune(UINT#0).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[3].Execute(Sequencer, 'Read data')) THEN
                IF(Component.Read(UINT#0).IsDone()) THEN
                    Sequencer.MoveNext();
                END_IF;
            END_IF;

            IF(Steps[4].Execute(Sequencer, 'Evaluate data')) THEN
                _ResultData := Component.ResultData;
                Sequencer.CompleteSequence();
            END_IF;   

        END_METHOD
        //</Usage>
    END_CLASS
END_NAMESPACE