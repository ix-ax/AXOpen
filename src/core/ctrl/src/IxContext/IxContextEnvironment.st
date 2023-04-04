USING AXOpen.Messaging;

NAMESPACE ix.framework.core
    CLASS PUBLIC IxContextEnvironment IMPLEMENTS IIxContextEnvironment        
        VAR PRIVATE                        
            _messenger : AxoMessengerEnv;
        END_VAR       
        METHOD PUBLIC Messaging : IAxoMessengerEnv 
            Messaging := _messenger;
        END_METHOD
    END_CLASS    
END_NAMESPACE
