NAMESPACE AXOpen.Components.Siem.Identification
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoSimaticIdentCyclic_Out
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Control#>"}
            {#ix-attr:[ReadOnly()]}
            Control           :   AxoSimaticIdentCyclic_Control;
            {#ix-set:AttributeName = "<#User data#>"}
            USER_DATA           :   ARRAY[0..123] OF BYTE;
        END_VAR 
    END_CLASS    
END_NAMESPACE