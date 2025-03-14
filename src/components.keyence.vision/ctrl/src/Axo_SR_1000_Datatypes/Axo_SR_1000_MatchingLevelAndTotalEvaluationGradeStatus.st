NAMESPACE AXOpen.Components.Keyence.Vision
    TYPE
        {S7.extern=ReadWrite}
        Axo_SR_1000_MatchingLevelAndTotalEvaluationGradeStatus : 
        STRUCT
            {#ix-set:AttributeName = "<#Matching Level#>"}
            MatchingLevel : UINT;
            {#ix-set:AttributeName = "<#ISO/IEC 15415 Grade#>"}
            ISO_IEC_15415_Grade : UINT;
            {#ix-set:AttributeName = "<#ISO/IEC TR 29158(AIM DPM-1-2006) Grade#>"}
            ISO_IEC_TR_29158_Grade : UINT;
            {#ix-set:AttributeName = "<#_Reserved#>"}
            _Reserved : UINT;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE
