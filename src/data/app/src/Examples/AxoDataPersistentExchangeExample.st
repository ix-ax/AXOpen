USING AXOpen;
using AXOpen.Data;

NAMESPACE AxoDataPersistentExchangeExample
    
    //<ContextDeclaration>
    {S7.extern=ReadWrite}
    CLASS PUBLIC Context EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            //persistent manager instance
            DataManager : AXOpen.Data.AxoDataPersistentExchange;
            //Testing usage of the manager
            ManagerUsage : ManagerUsage; 
            // Object that propertie will be tracked by persistent manager
            PersistentRootObject : PersistentRootObject; 
        END_VAR
        
        METHOD OVERRIDE Main
            DataManager.Run(THIS);
            ManagerUsage.Use(DataManager);
        END_METHOD
    END_CLASS
    //</ContextDeclaration>
    

    //<Usage>
    {S7.extern=ReadWrite}
    CLASS PUBLIC ManagerUsage EXTENDS AxOpen.Core.AxoObject
        VAR PUBLIC
            _persistentGroupId : STRING;
            _update : BOOL;
            _read : BOOL;
            _updateAll : BOOL;
            _readAll : BOOL;
            _exist : BOOL;
            _recordExist : BOOL;
        END_VAR  
    
        METHOD PUBLIC Use
            VAR_IN_OUT
                DataManager : AXOpen.Data.AxoDataPersistentExchange;
            END_VAR  

            IF(_read) THEN 
                IF(DataManager.InvokeRead(THIS,_persistentGroupId)) THEN
                    ;
                END_IF;

                IF(DataManager.IsReadDone(THIS)) THEN
                    _read := FALSE;
                END_IF;
            END_IF;
            
            IF(_update) THEN
                IF(DataManager.InvokeUpdate(THIS,_persistentGroupId)) THEN
                   ;
                END_IF;

                IF(DataManager.IsUpdateDone(THIS)) THEN
                    _update := FALSE;
                END_IF;
            END_IF;

            IF(_readAll) THEN
                IF(DataManager.InvokeReadAll(THIS)) THEN
                   ;
                END_IF;
                IF(DataManager.IsReadAllDone(THIS)) THEN
                    _readAll := FALSE;
                END_IF;
            END_IF;
            
            IF(_updateAll) THEN
                IF(DataManager.InvokeUpdateAll(THIS)) THEN
                    ;
                END_IF;

                IF(DataManager.IsUpdateAllDone(THIS)) THEN
                    _updateAll := FALSE;
                END_IF;
            END_IF;

            IF(_exist) THEN
                IF(DataManager.InvokeEntityExist(THIS, _persistentGroupId)) THEN
                    ;
                END_IF;

                IF(DataManager.IsEntityExistDone(THIS)) THEN
                    _exist := FALSE;
                    _recordExist := DataManager.Operation._exist;
                END_IF;
            END_IF;
        END_METHOD        
    END_CLASS
    //</Usage>

    //<PersistentAttribute>
    {S7.extern=ReadWrite}
    CLASS PUBLIC PersistentRootObject
        VAR PUBLIC 
            NotPersistentVariable : BOOL; 
            
            {#ix-attr:[Persistent()]}
            {#ix-set:AttributeName = "PersistentVariable_1 (in default pg.))"} 
            PersistentVariable_1 : INT; // will be saved to 'default' persistent group
            
            {#ix-attr:[Persistent("default","1")]} // will be saved to 'default' and '1' persistent group
            {#ix-set:AttributeName = "PersistentVariable_2 (in default & 1 pg.)"} 
            PersistentVariable_2 : INT;
            
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "PropertyWithPersistentMember"} 
            PropertyWithPersistentMember : ObjectWithPersistentMember;
        END_VAR
    END_CLASS
        
    {S7.extern=ReadWrite}
    CLASS PUBLIC ObjectWithPersistentMember
        VAR PUBLIC 
            NotPersistentVariable : INT; 
            
            {#ix-attr:[Persistent("2")]}
            {#ix-attr:[Container(Layout.Stack)]}
            {#ix-attr:[Group(GroupLayout.GroupBox)]}
            {#ix-set:AttributeName = "InitializedPrimitives (in 2 pg.)"} 
            InitializedPrimitives : InitializedPrimitives; 
        END_VAR
    END_CLASS
    
    {S7.extern=ReadWrite}
    CLASS PUBLIC InitializedPrimitives
        VAR PUBLIC
            myBOOL          :       BOOL	      := true;
            myBYTE          :       BYTE	      := BYTE#255;
            myWORD          :       WORD	      := WORD#60000;
            myDWORD         :       DWORD	      := DWORD#16#ABCD_EF01;
            myLWORD	        :       LWORD	      := LWORD#18446744073709551615;
            mySINTMin       :       SINT	      := SINT#-128;
            mySINTMax       :       SINT	      := SINT#127;
            myINT	        :       INT           := INT#32767;
            myDINT	        :       DINT	      := DINT#2147483647;
            myLINT	        :       LINT	      := LINT#9223372036854775807;
            myUSINT	        :       USINT	      := USINT#255;
            myUINT	        :       UINT	      := UINT#65535;
            myUDINT	        :       UDINT	      := UDINT#4294967295;
            myULINT	        :       ULINT	      := ULINT#18446744073709551615;
            myREAL	        :       REAL	      := REAL#+3.402823e+38;
            myLREAL	        :       LREAL	      := LREAL#1.79769313486231e+308;
            myTIME	        :       TIME	      := TIME#2147483647ms;
            myLTIME	        :       LTIME	      := LTIME#100000d2h4m8s16ms32ns;
            myDATE	        :       DATE	      := DATE#2262-04-11;
            myLDATE	        :       LDATE	      := LDATE#2262-04-11;
            myTIME_OF_DAY	:       TIME_OF_DAY   := TIME_OF_DAY#23:59:59.999999999;
            myLTIME_OF_DAY	:       LTIME_OF_DAY  := LTIME_OF_DAY#23:59:59.999999999;
            myDATE_AND_TIME :      DATE_AND_TIME  := DATE_AND_TIME#2262-04-11-23:47:16.854775807;
            myLDATE_AND_TIME :      LDATE_AND_TIME := LDATE_AND_TIME#2262-04-11-23:47:16.854775807;
            myCHAR	        :       CHAR	      := CHAR#255;
            myWCHAR	        :       WCHAR	      := WCHAR#65535;
            mySTRING        :       STRING	      := 'o\zxcvbnm,./asdfghjkl;\\qwertyuiop[]1234567890-~!@#^&*()_+';
            myWSTRING       :       WSTRING	      := WSTRING#"o\zxcvbnm,./asdfghjkl;'\qwertyuiop[]1234567890-~!@#^&*()_+";
        END_VAR    
    END_CLASS
    //</PersistentAttribute>
    
END_NAMESPACE
