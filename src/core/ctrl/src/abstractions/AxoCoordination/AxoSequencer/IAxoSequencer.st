NAMESPACE AXOpen.Core
    INTERFACE PUBLIC IAxoSequencer EXTENDS IAxoCoordinator
    //, IAxoTask
        METHOD  GetSteppingMode : eAxoSteppingMode END_METHOD

        METHOD  SetSteppingMode 
            VAR_INPUT
                inSteppingMode : eAxoSteppingMode; 
            END_VAR
        END_METHOD 

        METHOD IsReady : BOOL END_METHOD   
        METHOD IsDone : BOOL END_METHOD   
        METHOD IsBusy : BOOL END_METHOD   
        METHOD HasError : BOOL END_METHOD 
        METHOD Invoke : IAxoTaskState VAR_INPUT inParent : IAxoObject; END_VAR END_METHOD
        METHOD Restore : IAxoTaskState END_METHOD                     
        METHOD SetIsDisabled
            VAR_INPUT
                Disabled : BOOL;
            END_VAR    
        END_METHOD      
    END_INTERFACE  
END_NAMESPACE
