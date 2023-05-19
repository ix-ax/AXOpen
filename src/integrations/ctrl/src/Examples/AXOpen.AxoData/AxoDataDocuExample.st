using AXOpen.Data;

NAMESPACE AxoDataExamplesDocu
    
    //<ProcessDataMangerDeclaration>
    CLASS AxoProcessDataManager EXTENDS AXOpen.Data.AxoDataExchange 
        VAR PUBLIC             
            {#ix-generic:TOnline}              
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AxoDataEntityAttribute]}
            Data       : AxoProductionData;    // <-  Manager will operate on this member.                   
        END_VAR  
    END_CLASS
    //</ProcessDataMangerDeclaration>
    
    //<ProcessDataDeclaration>
    CLASS AxoProductionData EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            {#ix-set:AttributeName = "Some string data"}
            SomeData : STRING;
            {#ix-set:AttributeName = "Some number"}
            SomeNumber : INT;
            {#ix-set:AttributeName = "Some boolean"}
            SomeBool : BOOL;
        END_VAR 
    END_CLASS
    //</ProcessDataDeclaration>
    
    //<ContextDeclaration>
    CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            DataManager : AxoProcessDataManager;
        END_VAR
        
        METHOD OVERRIDE Main 
            DataManager.Run(THIS);
        END_METHOD          
    END_CLASS
    //</ContextDeclaration>

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
                DataManager : AxoProcessDataManager;
            END_VAR    
            IF(_create) THEN
                IF(DataManager.Create(_id).IsDone()) THEN
                    _create := FALSE;
                END_IF;
            END_IF;
            
            IF(_read) THEN
                IF(DataManager.Read(_id).IsDone()) THEN
                    _read := FALSE;
                END_IF;
            END_IF;
            
            IF(_update) THEN
                IF(DataManager.Update(_id).IsDone()) THEN
                    _update := FALSE;
                END_IF;
            END_IF;
            
            IF(_delete) THEN
                IF(DataManager.Delete(_id).IsDone()) THEN
                    _delete := FALSE;
                END_IF;
            END_IF;
        END_METHOD        
    END_CLASS
    //</UseManager>

END_NAMESPACE