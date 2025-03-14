USING AXOpen.Core;

NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0

    {S7.extern=ReadWrite}
    CLASS Component_4 EXTENDS AXOpen.Core.AxoObject
        //<ComponentDeclaration>
        VAR PUBLIC                
            Insight_2800 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight;     
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
                Insight_2800.ActivateManualControl();
                //</InsightManualControl>
            END_IF;

            //<Initialization>        
            Insight_2800.Run(   parent                  :=  THIS,  
                                ResultDataSize          :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoInsight_ResultDataSize#RESULT_DATA_64B,
                                UserDataSize            :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoInsight_UserDataSize#USER_DATA_64B,
                                hwID                    :=  HwIdentifiers#is2800_HwID,
                                hwIdAcquisitionControl  :=  HwIdentifiers#is2800_Acquisition_Control_Acquisition_Control_HwID,
                                hwIdAcquisitionStatus   :=  HwIdentifiers#is2800_Acquisition_Status_Acquisition_Status_HwID,
                                hwIdInspectionControl   :=  HwIdentifiers#is2800_Inspection_Control_Inspection_Control_HwID,
                                hwIdInspectionStatus    :=  HwIdentifiers#is2800_Inspection_Status_Inspection_Status_HwID,
                                hwIdCommandControl      :=  HwIdentifiers#is2800_Command_Control_Command_Control_HwID,
                                hwIdSoftEventControl    :=  HwIdentifiers#is2800_SoftEvent_Control_ExternalEvent_Control_HwID,
                                hwIdResultData          :=  HwIdentifiers#is2800_Result_Data_64_bytes_Results___64_bytes_HwID,
                                hwIdUserData            :=  HwIdentifiers#is2800_User_Data_64_bytes_User_Data___64_bytes_HwID);
            //</Initialization>
            THIS.UseInSequencer();
        END_METHOD

        //<Usage>    
        VAR PUBLIC                       
            Sequencer : AxoSequencer;       
            Steps : ARRAY[0..4] OF AXOpen.Core.AxoStep;
        END_VAR

        VAR PRIVATE
            _InspectionResults  :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight_ResultData;
        END_VAR

        METHOD PRIVATE UseInSequencer   
            IF Sequencer.GetContext().OpenCycleCount() = ULINT#0 THEN
                Sequencer.SequenceMode := eAxoSequenceMode#RunOnce;
            END_IF;

            Sequencer.Run(THIS);
            Sequencer.Open();

            IF(Steps[0].Execute(Sequencer, 'Change job')) THEN
                IF(Insight_2800.ChangeJob('01_Brightness').IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;

            IF(Steps[1].Execute(Sequencer, 'Trigger')) THEN
                IF(Insight_2800.Trigger().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;       

            IF(Steps[2].Execute(Sequencer, 'Evaluate inspection results')) THEN
                _InspectionResults := Insight_2800.InspectionResults;
                Sequencer.MoveNext();                
            END_IF;       

            IF(Steps[3].Execute(Sequencer, 'Clear inspaction results')) THEN
                IF(Insight_2800.ClearInspectionResults().IsDone()) THEN                
                    Sequencer.MoveNext();                
                END_IF;    
            END_IF;     

            IF(Steps[4].Execute(Sequencer, 'Soft event')) THEN
                IF(Insight_2800.SoftEvent(UINT#5).IsDone()) THEN                
                    Sequencer.CompleteSequence();                
                END_IF;    
            END_IF;     

        END_METHOD
        
        //</Usage>


    END_CLASS
END_NAMESPACE