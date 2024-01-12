NAMESPACE AXOpen.Core
    {S7.extern=ReadWrite}
    CLASS PUBLIC AxoDialogBase EXTENDS AxoRemoteTask
        VAR PUBLIC
            _closeSignal : BOOL;
        END_VAR
       
        ///<summary>
        /// Restore dialog. In special case context can be null.
        ///</summary>
        METHOD PUBLIC OVERRIDE Restore : IAxoTaskState
            IF _context_ = NULL THEN
                THIS.OnRestore();
            ELSE
                SUPER.Restore(); 
            END_IF;

            Restore := THIS;
        END_METHOD  

        ///<summary>
        /// Executes once when the task is restored.
        ///</summary>
        METHOD PROTECTED OVERRIDE OnRestore 
            _closeSignal := true; // close all dialogs...
        END_METHOD
    END_CLASS
END_NAMESPACE
