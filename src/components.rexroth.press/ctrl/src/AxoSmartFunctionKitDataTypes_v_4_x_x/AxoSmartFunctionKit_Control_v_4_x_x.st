NAMESPACE AXOpen.Components.Rexroth.Press
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS AxoSmartFunctionKit_Control_v_4_x_x 
        VAR PUBLIC
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "<#Handle#>"}
            Handle                  : WORD;
            {#ix-set:AttributeName = "<#Command#>"}
            Command                  : WORD;
            {#ix-set:AttributeName = "<#Value 1#>"}
            Value1                  : DWORD;
            {#ix-set:AttributeName = "<#Value 2#>"}
            Value2                  : DWORD;
            {#ix-set:AttributeName = "<#Value 3#>"}
            Value3                  : DWORD;
            {#ix-set:AttributeName = "<#Value 4#>"}
            Value4                  : DWORD;
            {#ix-set:AttributeName = "<#Value 5#>"}
            Value5                  : DWORD;
            {#ix-set:AttributeName = "<#Value 6#>"}
            Value6                  : DWORD;
            {#ix-set:AttributeName = "<#Value 7#>"}
            Value7                  : DWORD;
            {#ix-set:AttributeName = "<#Virtual Io#>"}
            VirtualIo               : WORD;
            {#ix-set:AttributeName = "<#Fast variable control#>"}
            FastVarControl	        : DWORD;
            {#ix-set:AttributeName = "<#Fast variable data#>"}
            FastVarData	            : DWORD;
        END_VAR
    END_CLASS
END_NAMESPACE
        