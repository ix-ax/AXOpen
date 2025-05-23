USING AXOpen.Core;
NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            _manualControl : BOOL;
            _sr_750 : AXOpen.Components.Keyence.Vision.Axo_SR_750;
            _sr_1000 : AXOpen.Components.Keyence.Vision.Axo_SR_1000;
            _rootObject : AxoObject;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);

            RETURN;
            
            _sr_750.Run(        parent                                          :=   _rootObject,
                                hwID                                            :=   HwIdentifiers#sr_750_1_HwID);

            _sr_1000.Run(       parent                                          :=   _rootObject,
                                hwID                                            :=   HwIdentifiers#sr_1000_1_HwID);


            IF(_manualControl) THEN
                _sr_750.ActivateManualControl();
                _sr_1000.ActivateManualControl();
            END_IF;    
        END_METHOD
    END_CLASS
END_NAMESPACE