NAMESPACE AXOpen.Core
    INTERFACE IAxoTask EXTENDS IAxoObject,IAxoTaskInt
        METHOD Execute : BOOL VAR_INPUT inParent : IAxoObject; END_VAR END_METHOD
        METHOD Invoke : IAxoTaskState VAR_INPUT inParent : IAxoObject; END_VAR END_METHOD
        METHOD Restore : IAxoTaskState END_METHOD
        METHOD Abort END_METHOD
        METHOD Resume END_METHOD
        METHOD DoneWhen VAR_INPUT Condition : BOOL; END_VAR END_METHOD            
        METHOD ThrowWhen VAR_INPUT HasErrorState : BOOL; END_VAR END_METHOD        
        METHOD IsReady : BOOL END_METHOD   
        METHOD IsDone : BOOL END_METHOD   
        METHOD IsBusy : BOOL END_METHOD   
        METHOD IsEngaged : BOOL END_METHOD   
        METHOD HasError : BOOL END_METHOD   
    END_INTERFACE
    INTERFACE INTERNAL IAxoTaskInt 
        METHOD SetIsDisabled  VAR_INPUT Disabled : BOOL; END_VAR END_METHOD
        METHOD GetIsDisabled : BOOL END_METHOD
    END_INTERFACE
END_NAMESPACE    
