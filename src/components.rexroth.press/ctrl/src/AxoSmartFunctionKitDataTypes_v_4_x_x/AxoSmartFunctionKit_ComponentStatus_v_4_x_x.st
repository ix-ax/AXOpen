NAMESPACE AXOpen.Components.Rexroth.Press
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoSmartFunctionKit_ComponentStatus_v_4_x_x  EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC 
            Status : AxoSmartFunctionKitStatus_v_4_x_x;
            {#ix-set:AttributeName = "<#Current command parameters#>"}
            CurrentCommandParameters : AxoSmartFunctionKitRequest_v_4_x_x;
        END_VAR 
    END_CLASS    
END_NAMESPACE





