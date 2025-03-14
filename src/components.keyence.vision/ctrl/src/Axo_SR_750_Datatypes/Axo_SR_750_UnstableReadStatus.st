NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        Axo_SR_750_UnstableReadStatus : 
        STRUCT
            {#ix-set:AttributeName = "<#Unstable#>"}
            Unstable : BOOL;
            {#ix-set:AttributeName = "<#Matching Level Unstable#>"}
            MatchingLevelUnstable : BOOL;
            {#ix-set:AttributeName = "<#ISO/IEC 15415 Unstable#>"}
            ISO_IEC_15415_Unstable  : BOOL;
            {#ix-set:AttributeName = "<#ISO/IEC TR 29158(AIM DPM-1-2006) Unstable#>"}
            ISO_IEC_TR_29158_Unstable  : BOOL;
            {#ix-set:AttributeName = "<#SAE AS9132 Unstable#>"}
            SAE_AS9132_Unstable  : BOOL;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
