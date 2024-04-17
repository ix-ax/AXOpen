{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        ActivateManualControl : BOOL;
        AxoSmartFunctionKit : AXOpen.Components.Rexroth.Press.AxoSmartFunctionKit_v_4_x_x;
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        AxoSmartFunctionKit.Run(parent              :=  THIS,                             
                                hwID                :=  HwIdentifiers#SFK4P_1,
                                hwIdParamCh_IDN     :=  HwIdentifiers#SFK4P_1_ParamCh_IDN,
                                hwIdInput_24_Words  :=  HwIdentifiers#SFK4P_1_Input_24_Words,
                                hwIdOutput_21_Words :=  HwIdentifiers#SFK4P_1_Output_21_Words);

        IF(ActivateManualControl) THEN
            AxoSmartFunctionKit.ActivateManualControl();
        END_IF;    
    END_METHOD
END_CLASS
