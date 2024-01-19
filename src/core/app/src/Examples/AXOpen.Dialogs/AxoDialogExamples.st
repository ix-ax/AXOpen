USING AXOpen.Core;

NAMESPACE AxoDialogExamples

    {S7.extern=ReadWrite}
    CLASS Dialogs EXTENDS AXOpen.Core.AxoContext
        VAR PUBLIC
            
            {#ix-set:AttributeName = "Restore All"}
            _invokeRestoreAll : BOOL;

            {#ix-set:AttributeName = "Call ALL"}
            _invokeCallAll : BOOL;

            {#ix-set:AttributeName = "Call ALL in Sequnce"}
            _invokeSequnceAll : BOOL;
 
             {#ix-set:AttributeName = "Dialog Test 1"}
             AA : AxoDialogTest;
       
             {#ix-set:AttributeName = "Dialog Test 2"}
             BB : AxoDialogTest;

             {#ix-set:AttributeName = "Dialog Test 1"}
             CC : AxoDialogTest;
       
             {#ix-set:AttributeName = "Dialog Test 2"}
             DD : AxoDialogTest;

             init_done : bool := false;
        END_VAR    
    
        METHOD PROTECTED OVERRIDE Main  

            if not init_done THEN
                AA.Caption := 'AA caption';
                BB.Caption := 'BB caption';
                CC.Caption := 'CC caption';
                DD.Caption := 'DD caption';
                
                AA.Question := 'AA Question';
                BB.Question := 'BB Question';
                CC.Question := 'CC Question';
                DD.Question := 'DD Question';
                
                init_done := true;
                
            end_if;


            IF _invokeRestoreAll THEN
                AA._restoreDialog := TRUE;
                BB._restoreDialog := TRUE;
                CC._restoreDialog := TRUE;
                DD._restoreDialog := TRUE;
                _invokeRestoreAll := FALSE;
            END_IF;

            IF _invokeCallAll THEN
                AA._callDialog := TRUE;
                BB._callDialog := TRUE;
                CC._callDialog := TRUE;
                DD._callDialog := TRUE;
                _invokeCallAll := FALSE;
            END_IF;

            IF _invokeSequnceAll THEN
                AA._callDialogInSequnce := TRUE;
                BB._callDialogInSequnce := TRUE;
                CC._callDialogInSequnce := TRUE;
                DD._callDialogInSequnce := TRUE;
                _invokeSequnceAll := FALSE;
            END_IF;

            AA.Run(THIS);
            BB.Run(THIS);
            CC.Run(THIS);
            DD.Run(THIS);

        END_METHOD
    END_CLASS    
END_NAMESPACE
