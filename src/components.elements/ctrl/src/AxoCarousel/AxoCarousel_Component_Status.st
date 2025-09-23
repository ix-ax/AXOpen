NAMESPACE AXOpen.Components.Elements
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoCarousel_Component_Status EXTENDS AXOpen.Components.Abstractions.AxoComponent_Status
        VAR PUBLIC 
            StartPosition     :   UINT;
            EndPosition       :   UINT;
            // {#ix-set:AttributeName = "<#Positions#>"}
            Positions : ARRAY[0..32] OF UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE