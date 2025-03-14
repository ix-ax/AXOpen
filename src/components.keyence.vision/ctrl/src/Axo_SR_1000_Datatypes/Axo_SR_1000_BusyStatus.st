NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        Axo_SR_1000_BusyStatus : 
        STRUCT
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
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
