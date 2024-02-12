NAMESPACE AXOpen.Components.Rexroth.Press
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoSmartFunctionKit_State_v_4_x_x 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Handle#>"}
            Handle                  : WORD;
            {#ix-set:AttributeName = "<#Status#>"}
            Status                  : WORD;
            {#ix-set:AttributeName = "<#Value1#>"}
            Value1                  : DWORD;
            {#ix-set:AttributeName = "<#Value2#>"}
            Value2                  : DWORD;
            {#ix-set:AttributeName = "<#Value3#>"}
            Value3                  : DWORD;
            {#ix-set:AttributeName = "<#NotificationId#>"}
            NotificationId          : WORD;
            {#ix-set:AttributeName = "<#NotificationValue#>"}
            NotificationValue       : DWORD;
            {#ix-set:AttributeName = "<#NotificationStatus#>"}
            NotificationStatus      : WORD;
            {#ix-set:AttributeName = "<#NotificationPosition#>"}
            NotificationPosition    : DWORD;
            {#ix-set:AttributeName = "<#NotificationVelocity#>"}
            NotificationVelocity    : DWORD;
            {#ix-set:AttributeName = "<#NotificationForce#>"}
            NotificationForce       : DWORD;
            {#ix-set:AttributeName = "<#DigitalIoMapping#>"}
            DigitalIoMapping        : WORD;
            {#ix-set:AttributeName = "<#VirtualIo#>"}
            VirtualIo               : WORD;
            {#ix-set:AttributeName = "<#Fast variable state#>"}
            FastVarState	        : DWORD;
            {#ix-set:AttributeName = "<#Fast variable data#>"}
            FastVarData	            : DWORD;
        END_VAR
    END_CLASS
END_NAMESPACE
        