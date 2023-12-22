USING AXOpen.Components.Festo.Drives;

{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        {#ix-attr:[Container(Layout.Wrap)]}
        _manualControl  : BOOL := TRUE;          
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;          

        {#ix-attr:[Container(Layout.Stack)]}
        _testDrive  : AXOpen.Components.Festo.Drives.AxoCmmtAs;
    END_VAR
    

    METHOD PROTECTED OVERRIDE Main  
        RETURN;

        IF(_manualControl) THEN            
            _testDrive.ActivateManualControl();
        END_IF;   
        _testDrive.Run(parent               :=  THIS,
                        refTelegram111_In   :=  REF(PlcInputs^.cmmtas_test_DO_SERVO_1_Siemens_telegram_111_PZD_12_12),
                        refTelegram750_In   :=  REF(PlcInputs^.cmmtas_test_DO_SERVO_1_Siemens_telegram_750_PZD_4_1),
                        refTelegram111_Out  :=  REF(PlcOutputs^.cmmtas_test_DO_SERVO_1_Siemens_telegram_111_PZD_12_12),
                        refTelegram750_Out  :=  REF(PlcOutputs^.cmmtas_test_DO_SERVO_1_Siemens_telegram_750_PZD_4_1),
                        MAP_HW_ID           :=  HwIdentifiers#cmmtas_test_Module_Access_Point);
        
    END_METHOD
END_CLASS
          

  