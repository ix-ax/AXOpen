NAMESPACE AXOpen.Components.Rexroth.Press.v_4_x_x
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoSmartFunctionKit_ComponentStatus  EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC 
            Status : AxoSmartFunctionKitStatus;
            {#ix-set:AttributeName = "<#Current command parameters#>"}
            CurrentCommandParameters : AxoSmartFunctionKitRequest;
        END_VAR 
    END_CLASS    
END_NAMESPACE





