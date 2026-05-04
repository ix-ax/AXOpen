NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_1000_BusyStatus 
        VAR PUBLIC
            {#ix-set:AttributeName = "<#BUSY#>"}
            BUSY : BOOL;
            {#ix-set:AttributeName = "<#TRG BUSY#>"}
            TRG_BUSY : BOOL;
            {#ix-set:AttributeName = "<#LOCK BUSY#>"}
            LOCK_BUSY : BOOL;
            {#ix-set:AttributeName = "<#MODE BUSY#>"}
            MODE_BUSY : BOOL;
            {#ix-set:AttributeName = "<#ERR BUSY#>"}
            ERR_BUSY : BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE