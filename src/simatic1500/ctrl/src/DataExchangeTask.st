USING AXOpen.core;
NAMESPACE AXOpen.data    
    CLASS DataExchangeTask EXTENDS AXOpen.core.IxRemoteTask 
        VAR PUBLIC
            DataEntityIdentifier : STRING[254];
        END_VAR                

        METHOD PUBLIC Invoke : AXOpen.core.IIxTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR 

            DataEntityIdentifier := identifier;            
            Invoke := SUPER.Invoke();
        END_METHOD    
    END_CLASS   
END_NAMESPACE