NAMESPACE AXOpen.Io
    {S7.extern=ReadWrite}
    {#ix-attr:[Container(Layout.Tabs)]}
        CLASS PUBLIC AxoIOLinkET200SP_Balluff_IO_Port
        VAR PUBLIC 
            {#ix-set:AttributeName = "<#Box1#>"}
            {#ix-attr:[ReadOnly()]}
            Box1  :   AxoIOLinkET200SP_Balluff_IO_Box;            
            {#ix-set:AttributeName = "<#Box2#>"}
            {#ix-attr:[ReadOnly()]}
            Box2  :   AxoIOLinkET200SP_Balluff_IO_Box;            
            {#ix-set:AttributeName = "<#Port status#>"}
            {#ix-attr:[ReadOnly()]}
            PortStatus  :   BYTE;            
        END_VAR 
    END_CLASS    
END_NAMESPACE