USING AXOpen.Core;
USING AXOpen;
using AXOpen.Data;

NAMESPACE AxoDataExchangeExample
    
    //<ContextDeclaration>
    {S7.extern=ReadWrite}
    CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            //Controlled unit that needs to manipulate with data
            ControlledUnit : ControlledUnit;
            //DataManager instance
            DataManager  : AxoProcessDataManager;

            //Testing usage of the manager
            ManagerUsage : ManagerUsage;
        END_VAR
        
        METHOD PUBLIC Execute
            
            // DataManager.Run(THIS); - is called iside of controlle unit
            ControlledUnit.Run(THIS);
            ControlledUnit.ProcessData := REF(DataManager);//Set REF to DataManager (reason depth of data structure)
            ControlledUnit.Run();// run logic of controlled unit 

            ManagerUsage.Use(DataManager);
        END_METHOD
    END_CLASS
    //</ContextDeclaration>

    //<AxoProcessDataManagerDeclaration>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoProcessDataManager EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            Set : AxoProcessData; // <- Manager will operate on this member.
        END_VAR
    END_CLASS
    //</AxoProcessDataManagerDeclaration>
    
    //<AxoProcessDataDeclaration>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoProcessData EXTENDS AXOpen.Data.AxoDataEntity
        VAR PUBLIC
            {#ix-set:AttributeName = "Some string"}
            SomeString : STRING;
            {#ix-set:AttributeName = "Some int"}
            SomeInt : INT;

            AllPrimitives : BasePrimitives;
        END_VAR
    END_CLASS
    //</AxoProcessDataDeclaration>

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
    {S7.extern=ReadWrite}
    CLASS PUBLIC ControlledUnit EXTENDS AXOpen.Core.AxoObject
        VAR PUBLIC
            //Reference to ProcessDataManager
            ProcessData : REF_TO AxoProcessDataManager;
            //Automatic sequence. Contains logic for automatic operations of this unit.
            AutomatSequence : AutomatSequence;
        END_VAR

        METHOD PUBLIC Run
            SUPER.Run(THIS); //??
            THIS.Execute();
        END_METHOD

        METHOD PRIVATE Execute
            ProcessData^.Run(THIS); // cyclic call of AxoProcessDataManager
            AutomatSequence.Run(THIS, ProcessData);
        END_METHOD
    END_CLASS
    //</Execute>

    //<Run>
    {S7.extern=ReadWrite}
    CLASS PUBLIC AutomatSequence EXTENDS AXOpen.Core.AxoSequencerContainer
        VAR PRIVATE
            // private reference is used in Main()
            ProcessData : REF_TO AxoProcessDataManager;
        END_VAR

        METHOD INTERNAL Run
            VAR_INPUT
                inParent : IAxoObject;
                _processData : REF_TO AxoProcessDataManager;
            END_VAR

            ProcessData := _processData;
        END_METHOD

        METHOD OVERRIDE Main
            ;//cyclic logic
        END_METHOD
    END_CLASS
    //</Run>

    
    {S7.extern=ReadWrite}
    CLASS PUBLIC NestedPrimitives_L3  //27 * 10 * 10 * 10 = 27 000 vars
        VAR PUBLIC
            Instance_0 : AxoDataExchangeExample.NestedPrimitives_L2;
            Instance_1 : AxoDataExchangeExample.NestedPrimitives_L2;
            Instance_2 : AxoDataExchangeExample.NestedPrimitives_L2;
            Instance_3 : AxoDataExchangeExample.NestedPrimitives_L2;
            Instance_4 : AxoDataExchangeExample.NestedPrimitives_L2;
            Instance_5 : AxoDataExchangeExample.NestedPrimitives_L2;
            Instance_6 : AxoDataExchangeExample.NestedPrimitives_L2;
            Instance_7 : AxoDataExchangeExample.NestedPrimitives_L2;
            Instance_8 : AxoDataExchangeExample.NestedPrimitives_L2;
            Instance_9 : AxoDataExchangeExample.NestedPrimitives_L2;

        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC NestedPrimitives_L2  //27 * 10 * 10 = 2700 vars
        VAR PUBLIC
            Instance_0 : AxoDataExchangeExample.NestedPrimitives_L1;
            Instance_1 : AxoDataExchangeExample.NestedPrimitives_L1;
            Instance_2 : AxoDataExchangeExample.NestedPrimitives_L1;
            Instance_3 : AxoDataExchangeExample.NestedPrimitives_L1;
            Instance_4 : AxoDataExchangeExample.NestedPrimitives_L1;
            Instance_5 : AxoDataExchangeExample.NestedPrimitives_L1;
            Instance_6 : AxoDataExchangeExample.NestedPrimitives_L1;
            Instance_7 : AxoDataExchangeExample.NestedPrimitives_L1;
            Instance_8 : AxoDataExchangeExample.NestedPrimitives_L1;
            Instance_9 : AxoDataExchangeExample.NestedPrimitives_L1;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC NestedPrimitives_L1 //27 * 10 = 270 vars
        VAR PUBLIC
            Instance_0 : AxoDataExchangeExample.BasePrimitives;
            Instance_1 : AxoDataExchangeExample.BasePrimitives;
            Instance_2 : AxoDataExchangeExample.BasePrimitives;
            Instance_3 : AxoDataExchangeExample.BasePrimitives;
            Instance_4 : AxoDataExchangeExample.BasePrimitives;
            Instance_5 : AxoDataExchangeExample.BasePrimitives;
            Instance_6 : AxoDataExchangeExample.BasePrimitives;
            Instance_7 : AxoDataExchangeExample.BasePrimitives;
            Instance_8 : AxoDataExchangeExample.BasePrimitives;
            Instance_9 : AxoDataExchangeExample.BasePrimitives;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC BasePrimitives //27 vars
        VAR PUBLIC
            vBOOL           :       BOOL	      ;
            vBYTE           :       BYTE	      ;
            vWORD           :       WORD	      ;
            vDWORD          :       DWORD	      ;
            vLWORD	        :       LWORD	      ;
            vSINT           :       SINT	      ;
            vINT	        :       INT           ;
            vDINT	        :       DINT	      ;
            vLINT	        :       LINT	      ;
            vUSINT	        :       USINT	      ;
            vUINT	        :       UINT	      ;
            vUDINT	        :       UDINT	      ;
            vULINT	        :       ULINT	      ;
            vREAL	        :       REAL	      ;
            vLREAL	        :       LREAL	      ;
            vTIME	        :       TIME	      ;
            vLTIME	        :       LTIME	      ;
            vDATE	        :       DATE	      ;
            vLDATE	        :       LDATE	      ;
            vTIME_OF_DAY	:       TIME_OF_DAY   ;
            vLTIME_OF_DAY	:       LTIME_OF_DAY  ;
            vDATE_AND_TIME  :      DATE_AND_TIME  ;
            vLDATE_AND_TIME :      LDATE_AND_TIME ;
            vCHAR	        :       CHAR	      ;
            vWCHAR	        :       WCHAR	      ;
            vSTRING         :       STRING	      ;
            vWSTRING        :       WSTRING	      ;
        END_VAR    
    END_CLASS

END_NAMESPACE
