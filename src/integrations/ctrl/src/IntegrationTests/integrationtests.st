NAMESPACE IntegrationTests
    CLASS PUBLIC Integrations
        VAR PUBLIC
             Probers : ProbersTestContext;
             DataExchangeTestsContext : DataExchangeTestsContext;
        END_VAR
        
        METHOD PUBLIC Run 
            Probers.Run();
            DataExchangeTestsContext.Run();            
        END_METHOD
    END_CLASS
END_NAMESPACE