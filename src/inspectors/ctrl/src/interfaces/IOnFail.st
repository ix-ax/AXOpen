NAMESPACE AXOpen.Inspectors
    INTERFACE IOnFail 
    

        METHOD CarryOn : BOOL
        END_METHOD

        METHOD Retry : BOOL
            VAR_INPUT
                inFromState : INT;
            END_VAR
        END_METHOD

        METHOD Terminate : BOOL
        END_METHOD
       
        
    END_INTERFACE
END_NAMESPACE