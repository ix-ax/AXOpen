NAMESPACE ix.framework.core
    CLASS PUBLIC IxContextEnvironment IMPLEMENTS IIxContextEnvironment        
        VAR                        
            _messenger : IxMessengerEnv;
        END_VAR       

        METHOD PUBLIC Messaging : IIxMessengerEnv
            Messaging := _messenger;
        END_METHOD    
    END_CLASS    
END_NAMESPACE
