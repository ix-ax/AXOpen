USING AXOpen.Components.Core;
NAMESPACE AXOpen.Components.Cognex.Vision.v_6_0_0_0
    {#ix-attr:[Container(Layout.Stack)]}
    {S7.extern=ReadWrite}
    CLASS AxoDataman_Status EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Wrap)]}
            ResultDataSize : eAxoDataman_ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID;
            {#ix-attr:[CompilerOmits()]} 
            UserDataSize : eAxoDataman_UserDataSize := eAxoDataman_UserDataSize#USER_DATA_SIZE_INVALID;
        END_VAR
    END_CLASS
END_NAMESPACE
