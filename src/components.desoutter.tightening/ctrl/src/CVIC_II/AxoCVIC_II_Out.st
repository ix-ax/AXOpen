NAMESPACE AXOpen.Components.Desoutter.Tightening
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Wrap)]}
    CLASS PUBLIC AxoCVIC_II_Out
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Control#>"}
            {#ix-attr:[ReadOnly()]}
            Control           :   AxoCVIC_II_Control;
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-set:AttributeName = "<#Screwing program#>"}
            {#ix-attr:[ReadOnly()]}
            ScrewingProgram	:   BYTE;
        END_VAR 
    END_CLASS    
END_NAMESPACE