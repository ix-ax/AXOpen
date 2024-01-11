USING AXOpen.Core;

NAMESPACE AxoDialogExamples

    {S7.extern=ReadWrite}
    CLASS Dialogs EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            
            {#ix-set:AttributeName = "Restore All"}
            _invokeRestoreAll : BOOL;

            {#ix-set:AttributeName = "Call ALL"}
            _invokeCallAll : BOOL;
 
             {#ix-set:AttributeName = "Dialog Test 1"}
             _dailogTest_1 : AxoDialogTest;
       
             {#ix-set:AttributeName = "Dialog Test 2"}
             _dailogTest_2 : AxoDialogTest;
        END_VAR    
    
        METHOD PROTECTED OVERRIDE Main  

            IF _invokeRestoreAll THEN
                _dailogTest_1._restoreDialog := TRUE;
                _dailogTest_2._restoreDialog := TRUE;
                _invokeRestoreAll := FALSE;
            END_IF;

            IF _invokeCallAll THEN
                _dailogTest_1._callDialog := TRUE;
                _dailogTest_2._callDialog := TRUE;
                _invokeCallAll := FALSE;
            END_IF;

            _dailogTest_1.Run(THIS);
            _dailogTest_2.Run(THIS);

        END_METHOD
    END_CLASS    
END_NAMESPACE
