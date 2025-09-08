NAMESPACE AXOpen.Components.Keyence.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC Axo_IV3_ToolResult
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Matching rate#>"}
            MatchingRate: UINT;
            {#ix-set:AttributeName = "<#Matching rate MAX#>"}
            MatchingRateMAX: UINT;
            {#ix-set:AttributeName = "<#Matching rate MIN#>"}
            MatchingRateMIN: UINT;
            {#ix-set:AttributeName = "<#Lower threshold#>"}
            LowerThreshold: UINT;
            {#ix-set:AttributeName = "<#Upper threshold#>"}
            UpperThreshold: UINT;
            {#ix-set:AttributeName = "<#Decimal point position#>"}
            DecimalPointPosition: UINT;
            {#ix-set:AttributeName = "<#Pitch present value MAX/color average H (hue)#>"}
            Data_1: UINT;
            {#ix-set:AttributeName = "<#Pitch present value MIN/color average S (saturation)#>"}
            Data_2: UINT;
            {#ix-set:AttributeName = "<#Number of pitches/color average V (brightness)/brightness average#>"}
            Data_3: UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE

