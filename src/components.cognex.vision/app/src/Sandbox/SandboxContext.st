USING AXOpen.Components.Cognex.Vision;
USING System.Timer;

NAMESPACE AXOpen.Components.Cognex.Vision

    // {S7.extern=ReadWrite}
    // CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    //     VAR PUBLIC              
    //         {#ix-set:AttributeName = "<#Activate manual control#>"}
    //         ActivateManualControl   :   BOOL;         
    //         _rootObject             :   AxoObject;
    //         Insight_7600            :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight;            
    //     END_VAR
    
    //     VAR PRIVATE
    //         _InspectionResults  :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight_ResultData;
    //     END_VAR


    //     METHOD PROTECTED OVERRIDE Main
    //         RETURN;
    //         THIS.InitializeRootObject(_rootObject);

    //         IF(ActivateManualControl) THEN
    //             Insight_7600.ActivateManualControl();
    //         END_IF;    

    //         Insight_7600.Run(parent:= _rootObject, hwID :=  HwIdentifiers#is7600_1_HwID);

    //     END_METHOD
    // END_CLASS

    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC              
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl   :   BOOL;         
            _rootObject             :   AxoObject;
            VisionPro : AXOpen.Components.Cognex.Vision.AxoVisionPro;
        END_VAR
    
        VAR PRIVATE
            _InspectionResults  :   AXOpen.Components.Cognex.Vision.v_6_0_0_0.AxoInsight_ResultData;
        END_VAR


        METHOD PROTECTED OVERRIDE Main

            THIS.InitializeRootObject(_rootObject);

            IF(ActivateManualControl) THEN
                VisionPro.ActivateManualControl();
            END_IF;    

            VisionPro.Run(parent := _rootObject, hwID := HwIdentifiers#CommunicationCard_HwID, CameraNo := UINT#1);

        END_METHOD
    END_CLASS

END_NAMESPACE        


