USING AXOpen.Components.Festo.Drives;

{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        {#ix-attr:[Container(Layout.Wrap)]}
        {#ix-set:AttributeName = "<#Activate manual control#>"}
        _manualControl  : BOOL := TRUE;          
        {#ix-set:AttributeName = "<#Enable drive signal#>"}
        Enable     : BOOL := TRUE;      
        {#ix-set:AttributeName = "<#Enable in positive direction signal#>"}
        EnablePositive : BOOL := TRUE;  
        {#ix-set:AttributeName = "<#Enable in positive negative signal#>"}
        EnableNegative   : BOOL := TRUE;        
        PlcInputs : REF_TO PlcInputs;
        PlcOutputs : REF_TO PlcOutputs;          

        {#ix-attr:[Container(Layout.Stack)]}
        {#ix-set:AttributeName = "<#Enable AxoCmmtAs using IO addresses#>"}
        EnableAxoCmmtAs_IO  : BOOL;
        {#ix-set:AttributeName = "<#AxoCmmtAs using IO addresses#>"}
        AxoCmmtAs_IO  : AXOpen.Components.Festo.Drives.AxoCmmtAs;
        {#ix-set:AttributeName = "<#Enable AxoCmmtAs using hardware identifiers#>"}
        EnableAxoCmmtAs_HwID  : BOOL;
        {#ix-set:AttributeName = "<#AxoCmmtAs using hardware identifiers#>"}
        AxoCmmtAs_HwID  : AXOpen.Components.Festo.Drives.AxoCmmtAsHwId;
    END_VAR
    

    METHOD PROTECTED OVERRIDE Main  

        IF EnableAxoCmmtAs_IO AND NOT EnableAxoCmmtAs_HwID THEN
            IF(_manualControl) THEN            
                AxoCmmtAs_IO.ActivateManualControl();
            END_IF;   

            AxoCmmtAs_IO.Run(parent             :=  THIS,
                                hwID                  :=  TO_UINT(HwIdentifiers#cmmtas_PN_IO_Interface),
                                refTelegram111_In     :=  REF(PlcInputs^.cmmtas_DO_SERVO_1_Siemens_telegram_111_PZD_12_12),
                                refTelegram750_In     :=  REF(PlcInputs^.cmmtas_DO_SERVO_1_Siemens_telegram_750_PZD_4_1),
                                refTelegram111_Out    :=  REF(PlcOutputs^.cmmtas_DO_SERVO_1_Siemens_telegram_111_PZD_12_12),
                                refTelegram750_Out    :=  REF(PlcOutputs^.cmmtas_DO_SERVO_1_Siemens_telegram_750_PZD_4_1),
                                MAP_HW_ID             :=  HwIdentifiers#cmmtas_DO_SERVO_1_Module_Access_Point,
                                Enable                := Enable,
                                EnablePositive        := EnablePositive,
                                EnableNegative        := EnableNegative);
        END_IF;

        IF NOT EnableAxoCmmtAs_IO AND  EnableAxoCmmtAs_HwID THEN
            IF(_manualControl) THEN            
                AxoCmmtAs_HwID.ActivateManualControl();
            END_IF;   

            AxoCmmtAs_HwID.Run(parent            :=  THIS,
                                hwID                  :=  HwIdentifiers#cmmtas_PN_IO_Interface,
                                hwIdTelegram111_In    :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_111_PZD_12_12,
                                hwIdTelegram750_In    :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_750_PZD_4_1,
                                hwIdTelegram111_Out   :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_111_PZD_12_12,
                                hwIdTelegram750_Out   :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_750_PZD_4_1,
                                MAP_HW_ID             :=  HwIdentifiers#cmmtas_DO_SERVO_1_Module_Access_Point,
                                Enable                := Enable,
                                EnablePositive        := EnablePositive,
                                EnableNegative        := EnableNegative);
        END_IF;
    END_METHOD
END_CLASS
          

  