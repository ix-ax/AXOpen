USING AXOpen.Core;
USING AXOpen;
using AXOpen.Data;

NAMESPACE DataFramentsExchange_Test_L4  
    
    //<ContextDeclaration>
    {S7.extern=ReadWrite}
    CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            
            DataManager  : AxoProcessDataManager_Test_L4;

        END_VAR
        
        METHOD OVERRIDE Main
            
        END_METHOD
    END_CLASS
    //</ContextDeclaration>

    //<AxoProcessDataManagerDeclaration>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoProcessDataManager_Test_L4 EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            Set : AxoProcessData_Test_L4; // <- Manager will operate on this member.
        END_VAR
    END_CLASS
    //</AxoProcessDataManagerDeclaration>
    
    //<AxoProcessDataDeclaration>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoProcessData_Test_L4 EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            vString : STRING;
            vInt : INT;
            vBool : BOOL;
            NestObj : NestingData;
        END_VAR
    END_CLASS
    //</AxoProcessDataDeclaration>


    {S7.extern=ReadWrite}
    CLASS PUBLIC NestingData 
        VAR PUBLIC
            vString : STRING;
            vInt : INT;
            vBool : BOOL;
        END_VAR
    END_CLASS

END_NAMESPACE
