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
 
             {#ix-set:AttributeName = "Dialog AA"}
             AA : AxoDialogTest;
       
             {#ix-set:AttributeName = "Dialog BB"}
             BB : AxoDialogTest;

             init_done : bool := false;
        END_VAR    
    
        METHOD PROTECTED OVERRIDE Main  

            if not init_done THEN
                AA.Caption := 'AA caption';
                BB.Caption := 'BB caption';
                
                AA.Question := 'AA Question';
                BB.Question := 'BB Question';
                
                init_done := true;
            end_if;


            IF _invokeRestoreAll THEN
                AA._restoreDialog := TRUE;
                BB._restoreDialog := TRUE;
                _invokeRestoreAll := FALSE;
            END_IF;

            IF _invokeCallAll THEN
                AA._callDialog := TRUE;
                BB._callDialog := TRUE;
                _invokeCallAll := FALSE;
            END_IF;

            IF _invokeSequnceAll THEN
                AA._callDialogInSequnce := TRUE;
                BB._callDialogInSequnce := TRUE;
                _invokeSequnceAll := FALSE;
            END_IF;

            AA.Run(THIS);
            BB.Run(THIS);

        END_METHOD
    END_CLASS    
END_NAMESPACE
