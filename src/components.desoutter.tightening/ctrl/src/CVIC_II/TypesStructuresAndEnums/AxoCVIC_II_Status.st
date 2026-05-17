NAMESPACE AXOpen.Components.Desoutter.Tightening
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoCVIC_II_Status
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Cycle bit 1#>"}
            {#ix-attr:[ReadOnly()]}
            CycleBit1           :   BOOL;
            {#ix-set:AttributeName = "<#Cycle bit 2#>"}
            {#ix-attr:[ReadOnly()]}
            CycleBit2           :   BOOL;
            {#ix-set:AttributeName = "<#Cycle bit 4#>"}
            {#ix-attr:[ReadOnly()]}
            CycleBit4           :   BOOL;
            {#ix-set:AttributeName = "<#Ready#>"}
            {#ix-attr:[ReadOnly()]}
            Ready   :   BOOL;
            {#ix-set:AttributeName = "<#In cycle#>"}
            {#ix-attr:[ReadOnly()]}
            InCycle            :   BOOL;
            {#ix-set:AttributeName = "<#Passed#>"}
            {#ix-attr:[ReadOnly()]}
            Passed          :   BOOL;
            {#ix-set:AttributeName = "<#Failed#>"}
            {#ix-attr:[ReadOnly()]}
            Failed           :   BOOL;
            {#ix-set:AttributeName = "<#NumberOfCyclesOk#>"}
            {#ix-attr:[ReadOnly()]}
            NumberOfCyclesOk               :   BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE