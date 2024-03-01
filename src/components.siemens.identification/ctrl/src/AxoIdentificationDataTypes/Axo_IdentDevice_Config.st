NAMESPACE AXOpen.Components.SIEM.Identification
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC Axo_IdentDevice_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Start address#>"}
            StartAddress: WORD := WORD#0;
            {#ix-set:AttributeName = "<#Rfid code size#>"}
            RfidCodeSize: WORD := WORD#50;
//            {#ix-set:AttributeName = "<#Hardware config data#>"}
            {#ix-attr:[CompilerOmits()]}
            HardwareConfig: ARRAY[0..15] OF BYTE := [BYTE#16#04,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#0A,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#25,BYTE#16#00,BYTE#16#00,BYTE#16#00,BYTE#16#01,BYTE#16#00,BYTE#16#01]; //default data for RF260R 
        END_VAR 
    END_CLASS    
END_NAMESPACE