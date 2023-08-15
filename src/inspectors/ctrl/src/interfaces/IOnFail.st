
NAMESPACE AXOpen.Inspectors
    INTERFACE IOnFail 
    
        METHOD CarryOn : BOOL
        END_METHOD

        METHOD RetryWithStep : BOOL
            VAR_INPUT
                /// State from which the inspection will restart.	
                inRetryStep : AXOpen.Core.IAxoStep;
            END_VAR
        END_METHOD

       
        METHOD Dialog : BOOL
            VAR_INPUT
                inRetryStep: AXOpen.Core.IAxoStep;
                inTerminateStep: AXOpen.Core.IAxoStep;
            END_VAR
        END_METHOD


        METHOD TerminateWithStep : BOOL
            VAR_INPUT
                /// State from which the inspection will restart.	
                inTerminateStep : AXOpen.Core.IAxoStep;
            END_VAR
        END_METHOD

    
        
    END_INTERFACE
END_NAMESPACE