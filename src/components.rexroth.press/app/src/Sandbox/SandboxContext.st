NAMESPACE AXOpen.Components.Rexroth.Press
        
    {S7.extern=ReadWrite}
    CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            ActivateManualControl : BOOL;
            AxoSmartFunctionKit : AXOpen.Components.Rexroth.Press.AxoSmartFunctionKit_v_4_x_x;
            _rootObject :   AxoObject;
        END_VAR

        METHOD PROTECTED OVERRIDE Main
            _rootObject.InitializeWithContext(THIS);
            AxoSmartFunctionKit.Run(parent              :=  _rootObject,                             
                                    hwID                :=  HwIdentifiers#SFK_HwID,
                                    hwIdParamCh_IDN     :=  HwIdentifiers#SFK_ParamCh_5Words_ID_PaCh_5Words_HwID,
                                    hwIdInput_24_Words  :=  HwIdentifiers#SFK_Input_24_Words_ID_InMod_24Words_HwID,
                                    hwIdOutput_21_Words :=  HwIdentifiers#SFK_Output_21_Words_ID_OutMod_21Words_HwID);

            IF(ActivateManualControl) THEN
                AxoSmartFunctionKit.ActivateManualControl();
            END_IF;    
        END_METHOD
    END_CLASS
END_NAMESPACE