USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE AxoDataFramentsExchangeExample  
    
    //<ContextDeclaration>
    CLASS Context EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            DataManager : AxoProcessDataManager;           
        END_VAR
        
        METHOD PROTECTED OVERRIDE Main
            DataManager.Run(THIS);
        END_METHOD
    END_CLASS
    //</ContextDeclaration>

    //<AxoProcessDataManagerDeclaration>
    CLASS AxoProcessDataManager
        EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            SharedHeader : SharedDataHeaderManger;            
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Station_1 : Station_1_ProcessDataManger;
        END_VAR
    END_CLASS
    //</AxoProcessDataManagerDeclaration>

    CLASS SharedDataHeaderManger
        EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            {#ix-attr:[Container(Layout.Stack)]} 
            {#ix-set:AttributeName = "Shared Header"}
            Set : SharedDataHeaderData;
        END_VAR
    END_CLASS

    CLASS SharedDataHeaderData
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            {#ix-set:AttributeName = "Some string"}
            SomeString : STRING;
            {#ix-set:AttributeName = "Some int"}
            SomeInt : INT;
        END_VAR      
    END_CLASS
        
    CLASS Station_1_ProcessDataManger
        EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}        
            {#ix-attr:[Container(Layout.Stack)]}    
            {#ix-set:AttributeName = "Station 1"}    
            Set : Station_1_Data;
        END_VAR
    END_CLASS

    CLASS Station_1_Data EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            {#ix-set:AttributeName = "Some string"}
            SomeString : STRING;
            {#ix-set:AttributeName = "Some int"}
            SomeInt : INT;
        END_VAR
    END_CLASS

END_NAMESPACE