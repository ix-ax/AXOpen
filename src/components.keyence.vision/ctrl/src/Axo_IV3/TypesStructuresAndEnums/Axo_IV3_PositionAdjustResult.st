NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_IV3_PositionAdjustResult
        VAR PUBLIC
            {#ix-set:AttributeName = "<#Position correction score#>"}
            PositionCorrectionScore : UINT;                                                     // IW52
            {#ix-set:AttributeName = "<#Position correction score MAX#>"}
            PositionCorrectionScoreMAX : UINT;                                                  // IW54
            {#ix-set:AttributeName = "<#Position correction score MIN#>"}
            PositionCorrectionScoreMIN : UINT;                                                  // IW56
            {#ix-set:AttributeName = "<#Position correction score Lower threshold#>"}
            PositionCorrectionScoreLowerThreshold : UINT;                                       // IW58
                                                                                                // IB60-IB71
        END_VAR 
    END_CLASS    
END_NAMESPACE