USING AXOpen.Core;
NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS AxoDataman_Status EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC
            SignalStatus : AxoDataman_SignalStates;
            ResultDataSize : eAxoDataman_ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_SIZE_INVALID;
            {#ix-attr:[CompilerOmits()]} 
            UserDataSize : eAxoDataman_UserDataSize := eAxoDataman_UserDataSize#USER_DATA_SIZE_INVALID;
        END_VAR
    END_CLASS
END_NAMESPACE