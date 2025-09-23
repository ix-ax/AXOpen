NAMESPACE AXOpen.Components.Elements
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoCarousel_Config
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Info time#>"}
            InfoTime : LTIME := LT#5S;
            {#ix-set:AttributeName = "<#Error time#>"}
            ErrorTime : LTIME := LT#10S;
            {#ix-set:AttributeName = "<#Task timeout#>"}
            TaskTimeout : LTIME := LT#10S;
            {#ix-set:AttributeName = "<#Direction#>"}
            Direction   : eAxoCarouselDirection;
            {#ix-set:AttributeName = "<#Number of positions#>"}
            NumberOfPositions:UINT;
            {#ix-set:AttributeName = "<#Offset#>"}
            Offset : UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE