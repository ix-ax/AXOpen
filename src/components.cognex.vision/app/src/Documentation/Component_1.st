USING AXOpen.Core;


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

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    
        
        THIS.Initialize(parent);

        IF ActivateManualControl THEN
            //<InsightManualControl>
            Insight_7600.ActivateManualControl();
            //</InsightManualControl>
        END_IF;

        //<Initialization>        
        Insight_7600.Run(   parent                  :=  THIS,  
                            ResultDataSize          :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoInsight_ResultDataSize#RESULT_DATA_64B,
                            UserDataSize            :=  AXOpen.Components.Cognex.Vision.v_6_0_0_0.eAxoInsight_UserDataSize#USER_DATA_64B,
                            hwID                    :=  HwIdentifiers#_7600,
                            hwIdAcquisitionControl  :=  HwIdentifiers#_7600_Acquisition_Control_1,
                            hwIdAcquisitionStatus   :=  HwIdentifiers#_7600_Acquisition_Status_1,
                            hwIdInspectionControl   :=  HwIdentifiers#_7600_Inspection_Control_1,
                            hwIdInspectionStatus    :=  HwIdentifiers#_7600_Inspection_Status_1,
                            hwIdCommandControl      :=  HwIdentifiers#_7600_Command_Control_1,
                            hwIdSoftEventControl    :=  HwIdentifiers#_7600_SoftEvent_Control_1,
                            hwIdResultData          :=  HwIdentifiers#_7600_Results_64_bytes_1,
                            hwIdUserData            :=  HwIdentifiers#_7600_User_Data_64_bytes_1);
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

        Sequencer.Initialize(THIS);
        Sequencer.Open();

        IF(Steps[0].Execute(Sequencer, 'Change job')) THEN
            IF(Insight_7600.ChangeJob('1_test01.job').IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;

        IF(Steps[1].Execute(Sequencer, 'Trigger')) THEN
            IF(Insight_7600.Trigger().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;       

        IF(Steps[2].Execute(Sequencer, 'Evaluate inspection results')) THEN
            _InspectionResults := Insight_7600.InspectionResults;
            Sequencer.MoveNext();                
        END_IF;       

        IF(Steps[3].Execute(Sequencer, 'Clear inspaction results')) THEN
            IF(Insight_7600.ClearInspectionResults().IsDone()) THEN                
                Sequencer.MoveNext();                
            END_IF;    
        END_IF;     

        IF(Steps[4].Execute(Sequencer, 'Soft event')) THEN
            IF(Insight_7600.SoftEvent(UINT#5).IsDone()) THEN                
                Sequencer.CompleteSequence();                
            END_IF;    
        END_IF;     

    END_METHOD
    
    //</Usage>


END_CLASS
