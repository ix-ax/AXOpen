NAMESPACE AXOpen.Components.Balluff.Identification
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS PUBLIC Axo_BIS_M_4XX_045_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#2S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#50S;
            {#ix-set:AttributeName = "<#Hardware IDs#>"}
            HWIDs : Axo_BIS_M_4XX_045_HWIDs;
            {#ix-set:AttributeName = "<#Start address#>"}
            StartAddress: WORD := WORD#0;
            {#ix-set:AttributeName = "<#Rfid code size#>"}
            RfidCodeSize: WORD := WORD#50;
        END_VAR 
    END_CLASS    
END_NAMESPACE

