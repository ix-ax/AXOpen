USING AXOpen.Core;

NAMESPACE AXOpen.Components.Cognex.Vision

    {S7.extern=ReadWrite}
    CLASS Component_2 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            Dataman_280 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman;     
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
                //<DatamanManualControl>
                Dataman_280.ActivateManualControl();
                //</DatamanManualControl>
            END_IF;

            //<Initialization>    
            Dataman_280.Run(inParent  :=  THIS, hwID :=  HwIdentifiers#cognex_dataman_280_HwID);    
            //</Initialization>

            THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..10] OF AXOpen.Core.AxoStep;
        END_VAR

        VAR PRIVATE
            _ResultData  :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoDataman_ResultData;
        END_VAR

        METHOD PRIVATE UseInSequencer   
            IF Sequencer.GetContext().OpenCycleCount() <= ULINT#10 THEN
                Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
            END_IF;

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                Dataman_280.Restore();
                Sequencer.MoveNext();                
            END_IF;
            
            IF(Steps[1].Execute(Sequencer, 'Clear result data')) THEN
                IF(Dataman_280.ClearResultData().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;  

            IF(Steps[2].Execute(Sequencer, 'Read data')) THEN
                IF(Dataman_280.Read().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[3].Execute(Sequencer, 'Evaluate data')) THEN
                _ResultData := Dataman_280.ResultData;
                Sequencer.MoveNext();                
            END_IF;       
    
            IF(Steps[4].Execute(Sequencer, 'Restore')) THEN
                Dataman_280.Restore();
                Sequencer.CompleteSequence();                               
            END_IF;

        END_METHOD
        
        //</Usage>
    END_CLASS
END_NAMESPACE