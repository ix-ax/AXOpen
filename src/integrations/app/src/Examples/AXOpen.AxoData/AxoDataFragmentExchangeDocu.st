USING AXOpen.Core;
USING AXOpen.Data;
USING AXOpen.Probers;

NAMESPACE AxoDataFramentsExchangeDocuExample  
    
    //<ContextDeclaration>
    CLASS AxoDataFragmentExchangeContext EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            ProcessData : ProcessDataManager;           
        END_VAR
                
        METHOD PROTECTED OVERRIDE Main
            // This is required to run cyclically. Method provides handling of data exchange tasks.
            ProcessData.Run(THIS);                                     
        END_METHOD
    END_CLASS
    //</ContextDeclaration>

    //<ProcessDataMangerDeclaration>
    CLASS ProcessDataManager EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            SharedHeader : SharedDataHeaderManger;            
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Station_1 : Station_1_ProcessDataManger;
        END_VAR
    END_CLASS
    //</ProcessDataMangerDeclaration>

     //<UseManager>
     CLASS UseManager
        VAR
            _create : BOOL;
            _read : BOOL;
            _update : BOOL;
            _delete : BOOL;
            _id : STRING;
        END_VAR   

        METHOD Use
            VAR_IN_OUT
                DataFragmentManager : ProcessDataManager;
            END_VAR    
            IF(_create) THEN
                IF(DataFragmentManager.Create(_id).IsDone()) THEN
                    _create := FALSE;
                END_IF;
            END_IF;
            
            IF(_read) THEN
                IF(DataFragmentManager.Read(_id).IsDone()) THEN
                    _read := FALSE;
                END_IF;
            END_IF;
            
            IF(_update) THEN
                IF(DataFragmentManager.Update(_id).IsDone()) THEN
                    _update := FALSE;
                END_IF;
            END_IF;
            
            IF(_delete) THEN
                IF(DataFragmentManager.Delete(_id).IsDone()) THEN
                    _delete := FALSE;
                END_IF;
            END_IF;
        END_METHOD        
    END_CLASS
    //</UseManager>

    CLASS SharedDataHeaderData EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC                        
            {#ix-set:AttributeName = "Some string data"}
            SomeData : STRING;
            {#ix-set:AttributeName = "Some number"}
            SomeNumber : INT;
            {#ix-set:AttributeName = "Some boolean"}
            SomeBool : BOOL;            
        END_VAR        
    END_CLASS

    CLASS SharedDataHeaderManger EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            {#ix-attr:[Container(Layout.Stack)]} 
            {#ix-set:AttributeName = "Shared Header"}
            Set : SharedDataHeaderData;
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

    CLASS Station_1_Data
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            {#ix-set:AttributeName = "Some string data"}
            SomeData : STRING;
            {#ix-set:AttributeName = "Some number"}
            SomeNumber : INT;
            {#ix-set:AttributeName = "Some boolean"}
            SomeBool : BOOL;
        END_VAR
    END_CLASS       
END_NAMESPACE