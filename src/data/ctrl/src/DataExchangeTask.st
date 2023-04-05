USING AXOpen.Core;
NAMESPACE ix.framework.data    
    CLASS DataExchangeTask EXTENDS IxRemoteTask 
        VAR PUBLIC
            DataEntityIdentifier : STRING[254];
        END_VAR                

        METHOD PUBLIC Invoke : IIxTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR 

            DataEntityIdentifier := identifier;            
            Invoke := SUPER.Invoke();
        END_METHOD    
    END_CLASS   
END_NAMESPACE