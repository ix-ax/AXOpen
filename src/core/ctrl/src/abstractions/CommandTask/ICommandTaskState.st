NAMESPACE ix.framework.core
    INTERFACE ICommandTaskState
        METHOD IsDone : BOOL END_METHOD
        METHOD IsBusy : BOOL END_METHOD
        METHOD IsAborted : BOOL END_METHOD
        METHOD HasError : BOOL END_METHOD    
    END_INTERFACE
END_NAMESPACE        