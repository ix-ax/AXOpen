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

        {#ix-attr:[Container(Layout.Stack)]}
        {#ix-set:AttributeName = "<#AxoCmmtAs#>"}
        AxoCmmtAs  : AXOpen.Components.Festo.Drives.AxoCmmtAs;
    END_VAR
    

    METHOD PROTECTED OVERRIDE Main  
            RETURN;

            IF(_manualControl) THEN            
                AxoCmmtAs.ActivateManualControl();
            END_IF;   

            AxoCmmtAs.Run(parent            :=  THIS,
                                hwID                  :=  HwIdentifiers#cmmtas_PN_IO_Interface,
                                hwIdTelegram111       :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_111_PZD_12_12,
                                hwIdTelegram750       :=  HwIdentifiers#cmmtas_DO_SERVO_1_Siemens_telegram_750_PZD_4_1,
                                MAP_HW_ID             :=  HwIdentifiers#cmmtas_DO_SERVO_1_Module_Access_Point,
                                Enable                := Enable,
                                EnablePositive        := EnablePositive,
                                EnableNegative        := EnableNegative);
    END_METHOD
END_CLASS
          

  