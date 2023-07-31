NAMESPACE AXOpen.Core
    INTERFACE  IAxoCoordinator EXTENDS IAxoObject
        METHOD GetCoordinatorState : AxoCoordinatorStates END_METHOD


        METHOD MoveNext
        END_METHOD

        METHOD Retry 
            VAR_INPUT
                inAxoStep : IAxoStep;
            END_VAR
        END_METHOD

        METHOD Terminate 
        END_METHOD
    END_INTERFACE  
END_NAMESPACE
