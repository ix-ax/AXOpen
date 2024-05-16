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
                            hwID                    :=  HwIdentifiers#is7600_HwID,
                            hwIdAcquisitionControl  :=  HwIdentifiers#is7600_Acquisition_Control_Acquisition_Control_HwID,
                            hwIdAcquisitionStatus   :=  HwIdentifiers#is7600_Acquisition_Status_Acquisition_Status_HwID,
                            hwIdInspectionControl   :=  HwIdentifiers#is7600_Inspection_Control_Inspection_Control_HwID,
                            hwIdInspectionStatus    :=  HwIdentifiers#is7600_Inspection_Status_Inspection_Status_HwID,
                            hwIdCommandControl      :=  HwIdentifiers#is7600_Command_Control_Command_Control_HwID,
                            hwIdSoftEventControl    :=  HwIdentifiers#is7600_SoftEvent_Control_SoftEvent_Control_HwID,
                            hwIdResultData          :=  HwIdentifiers#is7600_Result_Data_64_bytes_Results___64_bytes_HwID,
                            hwIdUserData            :=  HwIdentifiers#is7600_User_Data_64_bytes_User_Data___64_bytes_HwID);

    END_METHOD
END_CLASS
      


