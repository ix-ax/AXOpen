NAMESPACE AXOpen.Components.Siem.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoSimaticIdentCyclic_Status
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#New data ready#>"}
            NDR 			    :	BOOL;
            {#ix-set:AttributeName = "<#Reset command received#>"}
            RESETCONF 			:	BOOL;
            {#ix-set:AttributeName = "<#Automatic command execution paused#>"}
            STOPCONF 			:	BOOL;
            {#ix-set:AttributeName = "<#Antene status#>"}
            ANTSTATUS 			:	BOOL;
            {#ix-set:AttributeName = "<#Block#>"}
            BLOCK 			    :	BOOL;
            {#ix-set:AttributeName = "<#Presence of a transponder#>"}
            PRESENCE 			:	BOOL;
            {#ix-set:AttributeName = "<#Error or startup#>"}
            ERROR_STARTUP 	    :	BOOL;
            {#ix-set:AttributeName = "<#Actice command#>"}
            ACTIVECMD 			:	BYTE;
            {#ix-set:AttributeName = "<#Length of user data in#>"}
            BLOCKLENGTH 		:	BYTE;
        END_VAR 
    END_CLASS    
END_NAMESPACE