USING AXOpen.Core;
NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS AxoInsight_Status EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC
            // SignalStatus : AxoInsight_SignalStates;
            ResultDataSize : eAxoInsight_ResultDataSize := eAxoInsight_ResultDataSize#RESULT_DATA_SIZE_INVALID;
            UserDataSize : eAxoInsight_UserDataSize := eAxoInsight_UserDataSize#USER_DATA_SIZE_INVALID;
        END_VAR
    END_CLASS
END_NAMESPACE