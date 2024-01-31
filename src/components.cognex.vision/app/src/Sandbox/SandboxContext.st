USING AXOpen.Components.Cognex.Vision;
USING System.Timer;

{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC              
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        ActivateManualControl : BOOL;         
        Insight_7600 : AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight;            
    END_VAR
 
    VAR PRIVATE
        _InspectionResults  :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight_ResultData;
    END_VAR


    METHOD PROTECTED OVERRIDE Main
        RETURN;

        Insight_7600.Initialize(THIS);

        IF(ActivateManualControl) THEN
            Insight_7600.ActivateManualControl();
        END_IF;    

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

    END_METHOD
END_CLASS
      


