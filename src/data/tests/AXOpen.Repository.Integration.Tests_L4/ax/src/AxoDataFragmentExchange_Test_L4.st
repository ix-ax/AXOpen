USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE AxoDataFragmentExchange_Test_L4  

    //<ContextDeclaration>
    {S7.extern=ReadWrite}
    CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
           
            DataManager  : AxoProcessDataManager_Test_L4;

        END_VAR
        
        METHOD OVERRIDE Main
                        
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoProcessDataManager_Test_L4
        EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Header : SharedDataHeaderManager_Test_L4;  

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            St1 : StationProcessDataManager_Test_L4;

        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC SharedDataHeaderManager_Test_L4
        EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            {#ix-attr:[Container(Layout.Stack)]} 
            {#ix-set:AttributeName = "Shared Header"}
            Set : SharedDataHeaderData_Test_L4;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC SharedDataHeaderData_Test_L4
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            SomeString : STRING;
            SomeInt : INT;
            SomeBool : BOOL;
        END_VAR      
    END_CLASS
        
    {S7.extern=ReadWrite}
    CLASS PUBLIC StationProcessDataManager_Test_L4
        EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}        
            {#ix-attr:[Container(Layout.Stack)]}    
            {#ix-set:AttributeName = "Station"}    
            Set : StationData_Test_L4;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC StationData_Test_L4 EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            vString : STRING;
            vInt : INT;
            vBool : BOOL;
            NestObj : NestingData;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC NestingData 
        VAR PUBLIC
            vString : STRING;
            vInt : INT;
            vBool : BOOL;
        END_VAR
    END_CLASS


END_NAMESPACE
