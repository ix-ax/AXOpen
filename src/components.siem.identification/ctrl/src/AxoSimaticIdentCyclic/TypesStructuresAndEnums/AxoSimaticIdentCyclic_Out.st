NAMESPACE AXOpen.Components.Siem.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoSimaticIdentCyclic_Out
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Control#>"}
            Control           :   AxoSimaticIdentCyclic_Control;
            Data    :   ARRAY[0..123] OF BYTE;
        END_VAR 
    END_CLASS    
END_NAMESPACE