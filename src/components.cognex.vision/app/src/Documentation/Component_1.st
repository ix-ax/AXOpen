USING AXOpen.Core;

NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0

    {S7.extern=ReadWrite}
    CLASS Component_1 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            Insight_7600 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight;            
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
                parent : IAxoObject;
            END_VAR    
            
            SUPER.Run(parent);

            IF ActivateManualControl THEN
                //<InsightManualControl>
                Insight_7600.ActivateManualControl();
                //</InsightManualControl>
            END_IF;

            //<Initialization>        
            Insight_7600.Run(parent := THIS, hwID :=  HwIdentifiers#is7600_HwID);
            //</Initialization>
        THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..10] OF AXOpen.Core.AxoStep;
        END_VAR

        VAR PRIVATE
            _InspectionResults  :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight_ResultData;
        END_VAR

        METHOD PRIVATE UseInSequencer   
            IF Sequencer.GetContext().OpenCycleCount() <= ULINT#10 THEN
                Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
            END_IF;

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'Restore')) THEN
                Insight_7600.Restore();
                Sequencer.MoveNext();                
            END_IF;       

            IF(Steps[1].Execute(Sequencer, 'Change job: 1_test01.job')) THEN
                IF(Insight_7600.ChangeJob('1_test01.job').IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'Trigger')) THEN
                IF(Insight_7600.Trigger().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[3].Execute(Sequencer, 'Evaluate inspection results')) THEN
                _InspectionResults := Insight_7600.InspectionResults;
                Sequencer.MoveNext();                
            END_IF;       

            IF(Steps[4].Execute(Sequencer, 'Clear inspaction results')) THEN
                IF(Insight_7600.ClearInspectionResults().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;     

            IF(Steps[5].Execute(Sequencer, 'Soft event')) THEN
                IF(Insight_7600.SoftEvent(UINT#5).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;     

            IF(Steps[6].Execute(Sequencer, 'Restore')) THEN
                Insight_7600.Restore();
                Sequencer.CompleteSequence();                
            END_IF;       

        END_METHOD
        
        //</Usage>


    END_CLASS
END_NAMESPACE