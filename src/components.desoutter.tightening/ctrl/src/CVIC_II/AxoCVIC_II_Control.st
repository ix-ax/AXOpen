NAMESPACE AXOpen.Components.Desoutter.Tightening
    {#ix-attr:[Container(Layout.Stack)]}
    CLASS PUBLIC AxoCVIC_II_Control
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
            {#ix-set:AttributeName = "<#Spindle validation#>"}
            {#ix-attr:[ReadOnly()]}
            SpindleValidation   :   BOOL;
            {#ix-set:AttributeName = "<#Error acknowledge#>"}
            {#ix-attr:[ReadOnly()]}
            ErrorAck            :   BOOL;
            {#ix-set:AttributeName = "<#Start cycle#>"}
            {#ix-attr:[ReadOnly()]}
            StartCycle          :   BOOL;
            {#ix-set:AttributeName = "<#Direction#>"}
            {#ix-attr:[ReadOnly()]}
            Direction           :   BOOL;
            {#ix-set:AttributeName = "<#Reset#>"}
            {#ix-attr:[ReadOnly()]}
            Reset               :   BOOL;
        END_VAR 
    END_CLASS    
END_NAMESPACE