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
        {#ix-set:AttributeName = "<#Call#>"}
        Call : BOOL;         
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;              
    END_VAR
    //</InitializationArgumentsDeclaration>            

    METHOD PUBLIC Run
        VAR_INPUT
            parent : IAxoContext;
        END_VAR    
        IF NOT Call THEN
            RETURN;
        END_IF;
        
        THIS.Initialize(parent);

        IF ActivateManualControl THEN
            //<InsightManualControl>
            Insight_7600.ActivateManualControl();
            //</InsightManualControl>
        END_IF;

        // RETURN;
        //<Initialization>        
        Insight_7600.Run(parent              :=  THIS,  
                    hwID                    :=  HwIdentifiers#_7600,
                    refAcquisitionControl   :=  REF(PlcOutputs^._7600_Acquisition_Control_1),
                    refAcquisitionStatus    :=  REF(PlcInputs^._7600_Acquisition_Status_1),
                    refInspectionControl    :=  REF(PlcOutputs^._7600_Inspection_Control_1),
                    refInspectionStatus     :=  REF(PlcInputs^._7600_Inspection_Status_1),
                    refCommandControl       :=  REF(PlcOutputs^._7600_Command_Control_1),
                    refCommandStatus        :=  REF(PlcInputs^._7600_Command_Control_1),
                    refSoftEventControl     :=  REF(PlcOutputs^._7600_SoftEvent_Control_1),
                    refSoftEventStatus      :=  REF(PlcInputs^._7600_SoftEvent_Control_1),
                    refResultData           :=  REF(PlcInputs^._7600_Results_64_bytes_1),
                    refUserData             :=  REF(PlcOutputs^._7600_User_Data_64_bytes_1));
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
            IF(Insight_7600.ChangeJob('jobname.job').IsDone()) THEN                
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
