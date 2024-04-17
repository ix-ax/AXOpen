USING AXOpen.Core;
NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS AxoInsight_Status EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            {#ix-set:AttributeName = "<#Current job name#>"}
            CurrentJobName : STRING;
            {#ix-set:AttributeName = "<#Current job number#>"}
            CurrentJobNumber : UINT;
        END_VAR
    END_CLASS
END_NAMESPACE
