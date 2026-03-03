NAMESPACE AXOpen.Core
    TYPE PUBLIC
        eAxoStepExecutionMode : INT 
        (          
            ExecuteAndContinue := 0,
            SwitchToStepModeBeforeEnteringStep := 1, 
            SwitchToStepModeAfterLeavingStep := 2
        ) := ExecuteAndContinue;
    END_TYPE
END_NAMESPACE    
