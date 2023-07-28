NAMESPACE AXOpen.Cognex.Vision.v_6_0_0_0
    TYPE
        {#ix-attr:[Container(Layout.Stack)]}
        AxoDataman_Status : 
        STRUCT
            ActionDescription : STRING[100];	
            SignalStatus : AxoDataman_SignalStates;
            ResultDataSize : eAxoDataman_ResultDataSize := eAxoDataman_ResultDataSize#RESULT_DATA_64B;
            {#ix-attr:[RenderIgnore()]}
            UserDataSize : eAxoDataman_UserDataSize := eAxoDataman_UserDataSize#USER_DATA_64B;
        END_STRUCT;
    END_TYPE 
END_NAMESPACE