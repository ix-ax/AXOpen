USING AXOpen;
using AXOpen.Data;

NAMESPACE AxoDataExchangeExample
    
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

    //<AxoProcessDataManagerDeclaration>
    CLASS AxoProcessDataManager EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            Set : AxoProcessData; // <- Manager will operate on this member.
        END_VAR
    END_CLASS
    //</AxoProcessDataManagerDeclaration>
    
    //<AxoProcessDataDeclaration>
    CLASS AxoProcessData EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            {#ix-set:AttributeName = "Some string"}
            SomeString : STRING;
            {#ix-set:AttributeName = "Some int"}
            SomeInt : INT;
        END_VAR
    END_CLASS
    //</AxoProcessDataDeclaration>

    //<Usage>
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
    //</Usage>

    //<Execute>
    CLASS CU EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            ProcessData : REF_TO AxoProcessDataManager;
        END_VAR

        METHOD PRIVATE Execute
            ProcessData^.Run(THIS);
        END_METHOD
    END_CLASS
    //</Execute>

    //<Run>
    CLASS PUBLIC AutomatSequence EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PRIVATE
            ProcessData : REF_TO AxoProcessDataManager;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _processData : REF_TO AxoProcessDataManager;
            END_VAR
            ProcessData := _processData;
        END_METHOD

        METHOD OVERRIDE Main
            ;
        END_METHOD
    END_CLASS
    //</Run>

END_NAMESPACE