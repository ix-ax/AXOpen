NAMESPACE AXOpen.Components.Elements
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoRotaryIndexingTable_State
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Safety condition#>"}
            SafetyCondition : BOOL;
            {#ix-set:AttributeName = "<#In position#>"}
            InPosition : BOOL;
            {#ix-set:AttributeName = "<#In precise position#>"}
            InPrecisePosition : BOOL;
            {#ix-set:AttributeName = "<#Coding position#>"}
            CodingPosition : UINT;
        END_VAR 
    END_CLASS    
END_NAMESPACE