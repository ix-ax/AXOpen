NAMESPACE axosimple
    {S7.extern=ReadWrite}
    CLASS EntityHeaderDataManager EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            {#ix-attr:[Container(Layout.Stack)]}    
            Entity : EntityData;
        END_VAR        
    END_CLASS
        
END_NAMESPACE
