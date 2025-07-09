USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE Tests_L1  

    {S7.extern=ReadWrite}
    CLASS PUBLIC SharedEntityHeaderManager EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            Set : Tests_L1.SharedEntityHeader;
        END_VAR
    END_CLASS

END_NAMESPACE
