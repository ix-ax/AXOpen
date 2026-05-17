USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE axopen_data_distributed_tests_l4
    {S7.extern=ReadWrite}
    CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            {#ix-attr:[AXOpen.Data.DistributedDataAttribute("DefaultGroup")]}
            DataManager  : FragmentProcessDataManager;
        END_VAR
        
        METHOD OVERRIDE Main
            ;         
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC FragmentProcessDataManager
        EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Header : HeaderManager;  

            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            St1 : StationManager;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC HeaderManager
        EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            {#ix-attr:[Container(Layout.Stack)]} 
            {#ix-set:AttributeName = "Shared Header"}
            Set : HeaderData;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC HeaderData
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            vString : STRING;
            vInt : INT;
            vBool : BOOL;
        END_VAR      
    END_CLASS
        
    {S7.extern=ReadWrite}
    CLASS PUBLIC StationManager
        EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}        
            {#ix-attr:[Container(Layout.Stack)]}    
            {#ix-set:AttributeName = "Station"}    
            Set : StationData;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC StationData EXTENDS AXOpen.Data.AxoDataEntity
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