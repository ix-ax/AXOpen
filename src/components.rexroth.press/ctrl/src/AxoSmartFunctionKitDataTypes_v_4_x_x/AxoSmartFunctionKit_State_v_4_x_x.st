NAMESPACE AXOpen.Components.Rexroth.Press
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoSmartFunctionKit_State_v_4_x_x 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Handle#>"}
            Handle                  : WORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            Status                  : WORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            Value1                  : DWORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            Value2                  : DWORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            Value3                  : DWORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            NotificationId          : WORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            NotificationValue       : DWORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            NotificationStatus      : WORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            NotificationPosition    : DWORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            NotificationVelocity    : DWORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            NotificationForce       : DWORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            DigitalIoMapping        : WORD;
            {#ix-set:AttributeName = "<#Handle#>"}
            VirtualIo               : WORD;
            {#ix-set:AttributeName = "<#Fast variable state#>"}
            FastVarState	        : DWORD;
            {#ix-set:AttributeName = "<#Fast variable data#>"}
            FastVarData	            : DWORD;
        END_VAR
    END_CLASS
END_NAMESPACE
        