NAMESPACE AXOpen.Components.SIEM.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS Axo_IdentDevice_Control 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#BitHeader1 Job#>"}
            BitHeader1_Job : BOOL;
            {#ix-set:AttributeName = "<#BitHeader1 Reserve0#>"}
            BitHeader1_Reserve0 : BOOL;
            {#ix-set:AttributeName = "<#qBitHeader1 GroundState#>"}
            BitHeader1_GroundState : BOOL;
            {#ix-set:AttributeName = "<#BitHeader1 Reserve1#>"}
            BitHeader1_Reserve1 : BOOL;
            {#ix-set:AttributeName = "<#BitHeader1 Reserve2#>"}
            BitHeader1_Reserve2 : BOOL;
            {#ix-set:AttributeName = "<#qBitHeader1 HeadOnOff#>"}
            BitHeader1_HeadOnOff : BOOL;
            {#ix-set:AttributeName = "<#qBitHeader1 ToggleBit#>"}
            BitHeader1_ToggleBit : BOOL;
            {#ix-set:AttributeName = "<#BitHeader1 Reserve3#>"}
            BitHeader1_Reserve3 : BOOL;
                   
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Command designator#>"}
            CommandDesignator : BYTE;
            {#ix-set:AttributeName = "<#Start address#>"}
            StartAddress : WORD;	
            {#ix-set:AttributeName = "<#Number  of bytes#>"}
            NumberOfBytes: WORD;
        
            // {#ix-set:AttributeName = "<#Data#>"}
            Data : ARRAY [0..7] OF BYTE;
        
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#BitHeader2 Job#>"}
            BitHeader2_Job : BOOL;
            {#ix-set:AttributeName = "<#BitHeader2 Reserve0#>"}
            BitHeader2_Reserve0 : BOOL;
            {#ix-set:AttributeName = "<#qBitHeader2 GroundState#>"}
            BitHeader2_GroundState : BOOL;
            {#ix-set:AttributeName = "<#BitHeader2 Reserve1#>"}
            BitHeader2_Reserve1 : BOOL;
            {#ix-set:AttributeName = "<#BitHeader2 Reserve2#>"}
            BitHeader2_Reserve2 : BOOL;
            {#ix-set:AttributeName = "<#qBitHeader2 HeadOnOff#>"}
            BitHeader2_HeadOnOff : BOOL;
            {#ix-set:AttributeName = "<#qBitHeader2 ToggleBit#>"}
            BitHeader2_ToggleBit : BOOL;
            {#ix-set:AttributeName = "<#BitHeader2 Reserve3#>"}
            BitHeader2_Reserve3 : BOOL;                
        END_VAR
    END_CLASS
END_NAMESPACE
        