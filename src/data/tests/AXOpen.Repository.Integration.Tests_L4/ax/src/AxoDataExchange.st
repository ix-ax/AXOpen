USING AXOpen.Core;
USING AXOpen;
using AXOpen.Data;

NAMESPACE Exchange_Test_L4  
    
    {S7.extern=ReadWrite}
    CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            
            DataManager  : ProcessManager;

        END_VAR
        
        METHOD OVERRIDE Main
            
        END_METHOD
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC ProcessManager EXTENDS AXOpen.Data.AxoDataExchange
        VAR PUBLIC
            {#ix-generic:TOnline}
            {#ix-generic:TPlain as POCO}
            {#ix-attr:[AXOpen.Data.AxoDataEntityAttribute]}
            Set : ProcessData; 
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC ProcessData EXTENDS AXOpen.Data.AxoDataEntity
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

    {S7.extern=ReadWrite}
    CLASS PUBLIC NestedPrimitives_L3  //27 * 10 * 10 * 10 = 27 000 vars
        VAR PUBLIC
            Instance_0 : NestedPrimitives_L2;
            Instance_1 : NestedPrimitives_L2;
            Instance_2 : NestedPrimitives_L2;
            Instance_3 : NestedPrimitives_L2;
            Instance_4 : NestedPrimitives_L2;
            Instance_5 : NestedPrimitives_L2;
            Instance_6 : NestedPrimitives_L2;
            Instance_7 : NestedPrimitives_L2;
            Instance_8 : NestedPrimitives_L2;
            Instance_9 : NestedPrimitives_L2;

        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC NestedPrimitives_L2  //27 * 10 * 10 = 2700 vars
        VAR PUBLIC
            Instance_0 : NestedPrimitives_L1;
            Instance_1 : NestedPrimitives_L1;
            Instance_2 : NestedPrimitives_L1;
            Instance_3 : NestedPrimitives_L1;
            Instance_4 : NestedPrimitives_L1;
            Instance_5 : NestedPrimitives_L1;
            Instance_6 : NestedPrimitives_L1;
            Instance_7 : NestedPrimitives_L1;
            Instance_8 : NestedPrimitives_L1;
            Instance_9 : NestedPrimitives_L1;
        END_VAR
    END_CLASS

    {S7.extern=ReadWrite}
    CLASS PUBLIC NestedPrimitives_L1 //27 * 10 = 270 vars
        VAR PUBLIC
            Instance_0 : BasePrimitives;
            Instance_1 : BasePrimitives;
            Instance_2 : BasePrimitives;
            Instance_3 : BasePrimitives;
            Instance_4 : BasePrimitives;
            Instance_5 : BasePrimitives;
            Instance_6 : BasePrimitives;
            Instance_7 : BasePrimitives;
            Instance_8 : BasePrimitives;
            Instance_9 : BasePrimitives;
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
