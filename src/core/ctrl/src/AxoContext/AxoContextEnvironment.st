USING AXOpen.Messaging.Dynamic;

NAMESPACE AXOpen.Core
    CLASS PUBLIC AxoContextEnvironment IMPLEMENTS IAxoContextEnvironment        
        VAR PRIVATE                        
            _messenger : AxoMessengerEnv;
        END_VAR       
        METHOD PUBLIC Messaging : IAxoMessengerEnv 
            Messaging := _messenger;
        END_METHOD
    END_CLASS    
END_NAMESPACE
