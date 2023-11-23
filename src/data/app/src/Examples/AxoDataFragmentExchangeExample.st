USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE AxoDataFramentsExchangeExample  

    //<ContextDeclaration>
    CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            //Controlled unit that needs to manipulate with data
            ControlledUnit : ControlledUnit;
            //DataManager instance
            DataManager  : AxoProcessDataManager;

            //Testing usage of the manager
            ManagerUsage : ManagerUsage;
        END_VAR
        
        METHOD OVERRIDE Main
            
            // DataManager.Run(THIS); - is called iside of controlle unit
            ControlledUnit.ProcessData := REF(DataManager);//Set REF to DataManager (reason depth of data structure)
            ControlledUnit.Run(THIS);// run logic of controlled unit 

            ManagerUsage.Use(DataManager);
        END_METHOD
    END_CLASS
    //</ContextDeclaration>

    //<AxoProcessDataManagerDeclaration>
    CLASS PUBLIC AxoProcessDataManager
        EXTENDS AXOpen.Data.AxoDataFragmentExchange
        VAR PUBLIC                    
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            SharedHeader : SharedDataHeaderManager;            
            {#ix-attr:[AXOpen.Data.AxoDataFragmentAttribute]}
            Station_1 : Station_1_ProcessDataManager;
        END_VAR
    END_CLASS
    //</AxoProcessDataManagerDeclaration>

    CLASS PUBLIC SharedDataHeaderManager
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

    CLASS PUBLIC SharedDataHeaderData
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            {#ix-set:AttributeName = "Some string"}
            SomeString : STRING;
            {#ix-set:AttributeName = "Some int"}
            SomeInt : INT;
        END_VAR      
    END_CLASS
        
    CLASS PUBLIC Station_1_ProcessDataManager
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

    CLASS PUBLIC Station_1_Data EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            {#ix-set:AttributeName = "Some string"}
            SomeString : STRING;
            {#ix-set:AttributeName = "Some int"}
            SomeInt : INT;
        END_VAR
    END_CLASS

     //<Usage>
     CLASS PUBLIC ManagerUsage
        VAR PUBLIC
            _id : STRING;
            _create : BOOL;
            _update : BOOL;
            _read : BOOL;
            _delete : BOOL;
        END_VAR   

        METHOD PUBLIC Use
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
    CLASS PUBLIC ControlledUnit EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            //Reference to ProcessDataManager
            ProcessData : REF_TO AxoProcessDataManager;
            //Automatic sequence. Contains logic for automatic operations of this unit.
            AutomatSequence : AutomatSequence;
        END_VAR

        METHOD PUBLIC Run
            VAR_INPUT
                _parent : IAxoContext;
            END_VAR
            THIS.Initialize(_parent);
            THIS.Execute();
        END_METHOD

        METHOD PRIVATE Execute
            ProcessData^.Run(THIS); // cyclic call of AxoProcessDataManager
            AutomatSequence.Run(THIS, ProcessData);
        END_METHOD
    END_CLASS
    //</Execute>

    //<Run>
    CLASS PUBLIC AutomatSequence EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PRIVATE
            // private reference is used in Main()
            ProcessData : REF_TO AxoProcessDataManager;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _parent : IAxoObject;
                _processData : REF_TO AxoProcessDataManager;
            END_VAR

            ProcessData := _processData;
        END_METHOD

        METHOD OVERRIDE Main
            ;//cyclic logic
        END_METHOD
    END_CLASS
    //</Run>

END_NAMESPACE