USING AXOpen.Components.Cognex.Vision;
USING System.Timer;

NAMESPACE AXOpen.Components.Cognex.Vision

    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC              
            {#ix-set:AttributeName = "<#Activate manual control#>"}
            ActivateManualControl   :   BOOL;         
            _rootObject             :   AxoObject;
            VisionPro : AXOpen.Components.Cognex.Vision.AxoVisionPro;
        END_VAR
    
         METHOD PROTECTED OVERRIDE Main
            RETURN;
            THIS.InitializeRootObject(_rootObject);

            IF(ActivateManualControl) THEN
                VisionPro.ActivateManualControl();
            END_IF;    

            // VisionPro.Run(parent := _rootObject, hwID := HwIdentifiers#vision_pro_HwID, CameraNo := BYTE#1);

        END_METHOD
    END_CLASS

END_NAMESPACE        


