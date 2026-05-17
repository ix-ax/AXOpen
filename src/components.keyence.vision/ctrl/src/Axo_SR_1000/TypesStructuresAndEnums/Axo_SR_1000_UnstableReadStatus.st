NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_1000_UnstableReadStatus 
        VAR PUBLIC
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
        END_VAR 
    END_CLASS    
END_NAMESPACE