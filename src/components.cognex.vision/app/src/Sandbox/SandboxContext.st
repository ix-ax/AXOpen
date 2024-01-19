{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl : BOOL;
        testInsight : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight;            
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;       
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        RETURN;
        testInsight.Run(parent              :=  THIS,  
                    hwID                    :=  TO_UINT(HwIdentifiers#_7600),
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

        IF(_manualControl) THEN
            testInsight.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS
