NAMESPACE AXOpen.Components.Siem.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoSimaticIdentCyclic_Control
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Start#>"}
            START 			:	BOOL;
            {#ix-set:AttributeName = "<#Reset#>"}
            RESET 			:	BOOL;
            {#ix-set:AttributeName = "<#Stop#>"}
            STOP 			:	BOOL;
            {#ix-set:AttributeName = "<#Switch off antenna#>"}
            ANTOFF 			:	BOOL;
            {#ix-set:AttributeName = "<#Block#>"}
            BLOCK 			    :	BOOL;
            {#ix-set:AttributeName = "<#Command#>"}
            CMD 			    :	BYTE;
            {#ix-set:AttributeName = "<#Index of the tag field#>"}
            TAGFIELD            :   WORD;
            {#ix-set:AttributeName = "<#Start address on the transponder#>"}
            ADDRESS             :   DWORD;
            {#ix-set:AttributeName = "<#Length of the data#>"}
            LENGTH              :   WORD;
        END_VAR 
    END_CLASS    
END_NAMESPACE