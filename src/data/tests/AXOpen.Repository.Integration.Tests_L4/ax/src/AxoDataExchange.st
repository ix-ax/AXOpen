USING AXOpen.Core;
USING AXOpen;
using AXOpen.Data;

NAMESPACE Exchange_Test_L4  
    
    {S7.extern=ReadWrite}
    CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            
            DataManager  : ProcessManager;

        END_VAR
        
        METHOD OVERRIDE Main
            
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC ProcessManager EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            Set : ProcessData; 
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC ProcessData EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            vString : STRING;
            vInt : INT;
            vBool : BOOL;
            NestObj : NestedObject;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC NestedObject 
        VAR PUBLIC
            vString : STRING;
            vInt : INT;
            vBool : BOOL;
        END_VAR
    END_CLASS

END_NAMESPACE
