USING AXOpen.Core;
USING AXOpen.Data;

NAMESPACE AxoDataDistributedExample  

    //<ContextDeclaration>
    {S7.extern=ReadWrite}
    CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            //Controlled unit that needs to manipulate with data
            {#ix-set:AttributeName = "Unit 1"}
            ControlledUnit_1 : ControlledUnit;

            {#ix-set:AttributeName = "Unit 2"}
            ControlledUnit_2 : ControlledUnit;
        END_VAR
        
        METHOD OVERRIDE Main
            THIS.InitializeRootObject(ControlledUnit);
            ControlledUnit.Run();// run logic of controlled unit 
        END_METHOD
    END_CLASS
    //</ContextDeclaration>
    

    {S7.extern=ReadWrite}
    CLASS PUBLIC SharedHeader_Manager
        EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            {#ix-attr:[Container(Layout.Stack)]} 
            {#ix-set:AttributeName = "Shared Header"}
            Set : SharedHeader_Data;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC SharedHeader_Data
        EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            HeaderPartialName : STRING;
            HeaderIndex : INT;
            HeaderGlogalPass : BOOL;
        END_VAR      
    END_CLASS
        
    {S7.extern=ReadWrite}
    CLASS PUBLIC StationData_Manager
        EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}        
            {#ix-attr:[Container(Layout.Stack)]}    
            {#ix-set:AttributeName = "Station"}    
            Set : Station_Data;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC Station_Data EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            StationName : STRING;
            StaionOperation : INT;
            StationPass : BOOL;
        END_VAR
    END_CLASS

     //<Usage>
     {S7.extern=ReadWrite}
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
                DataManager : AXOpen.Data.AxoDataExchange;
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
    {S7.extern=ReadWrite}
    CLASS PUBLIC ControlledUnit EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            EntityHeader : SharedHeader_Manager;            
            ProcessData : StationData_Manager;

            HeaderUsage : ManagerUsage;
            ProcessUsage : ManagerUsage;

            //Automatic sequence. Contains logic for automatic operations of this unit.
            AutomatSequence : AutomatSequence;
        END_VAR


        METHOD PUBLIC Run
            SUPER.Run(THIS); //??
            THIS.EntityHeader.Run(THIS)
            THIS.ProcessData.Run(THIS)

            HeaderUsage.Run(THIS);
            ProcessUsage.Run(THIS);

            THIS.Execute();
        END_METHOD

        METHOD PRIVATE Execute
            ProcessData^.Run(THIS); // cyclic call of AxoProcessDataManager
            AutomatSequence.Run(THIS, ^ProcessData);
        END_METHOD
    END_CLASS
    //</Execute>

    //<Run>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AutomatSequence EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PRIVATE
            // private reference is used in Main()
            HeaderData : REF_TO SharedHeader_Manager;
            ProcessData : REF_TO StationData_Manager;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                _parent : IAxoObject;
                _processData : REF_TO StationData_Manager;
                _headerData : REF_TO SharedHeader_Manager;
            END_VAR

            ProcessData := _processData;
            HeaderData := _headerData;
        END_METHOD

        METHOD OVERRIDE Main
            ;//cyclic logic
        END_METHOD
    END_CLASS
    //</Run>

END_NAMESPACE
