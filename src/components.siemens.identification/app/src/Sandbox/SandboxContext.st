USING  AXOpen.Components.SIEM.Identification;
USING System.Serialization;
USING System.Strings;


{S7.extern=ReadWrite}
CLASS SandboxContext EXTENDS AXOpen.Core.AxoContext
    VAR PUBLIC
        _manualControl             :   BOOL := TRUE;
        {#ix-attr:[CompilerOmits()]}
        _rf186_1_hardwareConfig: ARRAY[0..15] OF BYTE := [BYTE#16#04,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#0A,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#25,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#01,BYTE#16#00,BYTE#16#01]; //default data for RF260R 
        rf186_1 : AXOpen.Components.SIEM.Identification.Axo_IdentDevice;          
    END_VAR

    METHOD PROTECTED OVERRIDE Main
        rf186_1.Config.HardwareConfig.Data := _rf186_1_hardwareConfig;

        rf186_1.Run(parent      :=  THIS,
                    HW_ID       :=  HwIdentifiers#rf186c_Reader_1,
                    API         :=  DWORD#16#5B00,	
                    SLOT 		:=  WORD#2,
                    SUB_SLOT 	:=  WORD#1,
                    CM_CHANNEL  :=  UINT#1);

        IF(_manualControl) THEN
            rf186_1.ActivateManualControl();
        END_IF;   
    END_METHOD
END_CLASS



