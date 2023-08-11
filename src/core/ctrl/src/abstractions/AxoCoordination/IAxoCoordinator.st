NAMESPACE AXOpen.Core
    INTERFACE  IAxoCoordinator EXTENDS IAxoObject
        METHOD GetCoordinatorState : AxoCoordinatorStates END_METHOD


        METHOD MoveNext
        END_METHOD

        METHOD RequestStep
            VAR_INPUT
                RequestedStep : IAxoStep;
            END_VAR
        END_METHOD

    
    END_INTERFACE  
END_NAMESPACE
