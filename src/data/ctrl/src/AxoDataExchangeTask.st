USING AXOpen.Core;
NAMESPACE AXOpen.Data    
    CLASS AxoDataExchangeTask EXTENDS AXOpen.Core.AxoRemoteTask 
        VAR PUBLIC
            DataEntityIdentifier : STRING[254];
        END_VAR                

        METHOD PUBLIC Invoke : IAxoTaskState
            VAR_INPUT
                identifier : STRING[254];
            END_VAR 

            DataEntityIdentifier := identifier;            
            Invoke := SUPER.Invoke();
        END_METHOD    
    END_CLASS   
END_NAMESPACE