NAMESPACE AXOpen.Components.Cognex.Vision
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoVisionProNet_Component_Status EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC 
             Accepted : BOOL;
             TriggerId : INT;
             ErrorCode : INT;
             RejectReason : STRING;
        END_VAR 
    END_CLASS    
END_NAMESPACE