USING AXOpen.Core;
NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS AxoInsight_Status EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Current job name#>"}
            CurrentJobName : STRING;
            {#ix-set:AttributeName = "<#Result data size#>"}
            ResultDataSize : eAxoInsight_ResultDataSize := eAxoInsight_ResultDataSize#RESULT_DATA_SIZE_INVALID;
            {#ix-set:AttributeName = "<#User data size#>"}
            UserDataSize : eAxoInsight_UserDataSize := eAxoInsight_UserDataSize#USER_DATA_SIZE_INVALID;
        END_VAR
    END_CLASS
END_NAMESPACE