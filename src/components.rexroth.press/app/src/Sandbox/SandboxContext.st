NAMESPACE AXOpen.Components.Rexroth.Press
        
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            ActivateManualControl : BOOL;
            AxoSmartFunctionKit : AXOpen.Components.Rexroth.Press.AxoSmartFunctionKit_v_4_x_x;
            _rootObject :   AxoObject;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            THIS.InitializeRootObject(_rootObject);
            AxoSmartFunctionKit.Run(inParent              :=  _rootObject,                             
                                    hwID                :=  HwIdentifiers#rexroth_press_HwID);

            IF(ActivateManualControl) THEN
                AxoSmartFunctionKit.ActivateManualControl();
            END_IF;    
        END_METHOD
    END_CLASS
END_NAMESPACE