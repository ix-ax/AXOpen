NAMESPACE AXOpen.Core
    INTERFACE PUBLIC IAxoSequencer EXTENDS IAxoCoordinator, IAxoTask
        METHOD  GetSteppingMode : eAxoSteppingMode END_METHOD

        METHOD  SetSteppingMode 
            VAR_INPUT
                inSteppingMode : eAxoSteppingMode; 
            END_VAR
        END_METHOD
        
    END_INTERFACE  
END_NAMESPACE
