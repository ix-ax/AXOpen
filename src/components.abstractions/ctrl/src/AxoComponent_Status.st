NAMESPACE AXOpen.Components.Abstractions    
    CLASS PUBLIC AxoComponent_Status
        VAR PUBLIC                        
            {#ix-set:AttributeName = "ActionDescription |[[1]ActionDescription]|"}
            ActionId    :   UINT;	
            {#ix-set:AttributeName = "ErrorDescription |[[1]ErrorDescription]|"}
            ErrorId     :   UINT;	

            {#ix-set:AttributeName = "ActionDescription |[[1]ActionDescription]|"}
            Action    :   AxoDictionaryIdentifier;	
            {#ix-set:AttributeName = "ErrorDescription |[[1]ErrorDescription]|"}
            Error     :   AxoDictionaryIdentifier;	
        END_VAR
    END_CLASS
END_NAMESPACE