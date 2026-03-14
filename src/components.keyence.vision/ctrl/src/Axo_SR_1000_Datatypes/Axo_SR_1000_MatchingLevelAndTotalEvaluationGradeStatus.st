NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_SR_1000_MatchingLevelAndTotalEvaluationGradeStatus 
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Matching Level#>"}
            MatchingLevel : UINT;
            {#ix-set:AttributeName = "<#ISO/IEC 15415 Grade#>"}
            ISO_IEC_15415_Grade : UINT;
            {#ix-set:AttributeName = "<#ISO/IEC TR 29158(AIM DPM-1-2006) Grade#>"}
            ISO_IEC_TR_29158_Grade : UINT;
            {#ix-set:AttributeName = "<#_Reserved#>"}
            _Reserved : UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE