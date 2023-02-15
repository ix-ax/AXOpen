NAMESPACE ix.framework.core
    INTERFACE IIxTaskState
        METHOD IsDone : BOOL END_METHOD
        METHOD IsBusy : BOOL END_METHOD
        METHOD IsAborted : BOOL END_METHOD
        METHOD HasError : BOOL END_METHOD    
    END_INTERFACE
END_NAMESPACE        