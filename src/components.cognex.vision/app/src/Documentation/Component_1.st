USING AXOpen.Core;

NAMESPACE AXOpen.Components.Cognex.Vision

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
                inParent : IAxoObject;
            END_VAR    
            
            SUPER.Run(inParent);

            IF ActivateManualControl THEN
                //<InsightManualControl>
                Insight_7600.ActivateManualControl();
                //</InsightManualControl>
            END_IF;

            //<Initialization>        
            Insight_7600.Run(inParent := THIS, hwID :=  HwIdentifiers#cognex_insight_7600_HwID;
            //</Initialization>
            THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..14] OF AXOpen.Core.AxoStep;
        END_VAR

        VAR PRIVATE
            _InspectionResults  :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight_ResultData;
            _UserData           :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight_UserData;
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

            IF(Steps[1].Execute(Sequencer, 'Change job by number:2')) THEN
                IF(Insight_7600.ChangeJob(UINT#2).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[2].Execute(Sequencer, 'Change job: 1_test01.job')) THEN
                IF(Insight_7600.ChangeJob('1_test01.job').IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[3].Execute(Sequencer, 'Trigger')) THEN
                IF(Insight_7600.Trigger().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[4].Execute(Sequencer, 'Evaluate inspection results')) THEN
                _InspectionResults := Insight_7600.InspectionResults;
                Sequencer.MoveNext();                
            END_IF;       

            IF(Steps[5].Execute(Sequencer, 'Clear inspaction results')) THEN
                IF(Insight_7600.ClearInspectionResults().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;     

            IF(Steps[6].Execute(Sequencer, 'Soft event:5')) THEN
                IF(Insight_7600.SoftEvent(UINT#5).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;     

            IF(Steps[7].Execute(Sequencer, 'Clear user data')) THEN
                IF(Insight_7600.ClearUserData().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;   

            IF(Steps[8].Execute(Sequencer, 'Set user data as byte')) THEN
                IF(Insight_7600.SetUserDataAsByte(BYTE#12,UINT#0)) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;   
            
            IF(Steps[9].Execute(Sequencer, 'Set user data as string')) THEN
                IF(Insight_7600.SetUserDataAsString('Set user data string l24',UINT#1)) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;  

            IF(Steps[10].Execute(Sequencer, 'Set user data as dint')) THEN
                IF(Insight_7600.SetUserDataAsDint(DINT#123456,UINT#25)) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;   

            IF(Steps[11].Execute(Sequencer, 'Set user data as real')) THEN
                IF(Insight_7600.SetUserDataAsReal(REAL#789.123,UINT#29)) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;   
 
            IF(Steps[12].Execute(Sequencer, 'Send already prepared user data')) THEN
                IF(Insight_7600.SendUserData().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;   

            IF(Steps[13].Execute(Sequencer, 'Send user data passed as input variable')) THEN
                _UserData.Data[0] := BYTE#65;
                // ..
                // ..
                _UserData.Data[27] := BYTE#32;

                IF(Insight_7600.SendUserData(_UserData, UINT#32).IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;   

            IF(Steps[14].Execute(Sequencer, 'Restore')) THEN
                Insight_7600.Restore();
                Sequencer.CompleteSequence();                
            END_IF;       
        END_METHOD
        
        //</Usage>


    END_CLASS
END_NAMESPACE