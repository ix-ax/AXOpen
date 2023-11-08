USING AXOpen;
using AXOpen.Data;

NAMESPACE AxoDataPersistentExchangeExample
    
    //<ContextDeclaration>
    CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            DataManager : AXOpen.Data.AxoDataPersistentExchange;
        END_VAR
        
        METHOD OVERRIDE Main
            DataManager.Run(THIS);
        END_METHOD
    END_CLASS
    //</ContextDeclaration>

    //<Usage>
    CLASS PUBLIC UseManager
        VAR
            _read : BOOL;
            _update : BOOL;
            _persistentGroupId : STRING;
        END_VAR  
        //<PersistentAttribute>
        VAR PUBLIC 
            {#ix-attr:[Persistent()]}
            PersistentVariable_1 : INT; // will be saved to 'default' persistent group

            {#ix-attr:[Persistent("default","first")]} // will be saved to 'default' and 'first' spersistent group
            PersistentVariable_2 : INT;
        END_VAR
        //</PersistentAttribute>
        METHOD Use
            VAR_IN_OUT
                DataManager : AXOpen.Data.AxoDataPersistentExchange;
            END_VAR    
            IF(_read) THEN
                IF(DataManager.Read(_persistentGroupId).IsDone()) THEN
                    _read := FALSE;
                END_IF;
            END_IF;
            
            IF(_update) THEN
                IF(DataManager.Update(_persistentGroupId).IsDone()) THEN
                    _update := FALSE;
                END_IF;
            END_IF;
        END_METHOD        
    END_CLASS
    //</Usage>

       
END_NAMESPACE