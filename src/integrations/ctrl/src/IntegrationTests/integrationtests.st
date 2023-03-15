NAMESPACE IntegrationTests
    CLASS PUBLIC Integrations
        VAR PUBLIC
             Probers : ProbersTestContext;             
             DataExchangeLightTestsContext : IntegrationLightDirect.DataExchangeLightTestsContext;
             DM : IntegrationLightDirect.DataManager;
        END_VAR
        
        METHOD PUBLIC Run 
            Probers.Run();
            DM.Run(DataExchangeLightTestsContext);                     
            DataExchangeLightTestsContext.InjectDM(DM);
            DataExchangeLightTestsContext.Run();
        END_METHOD
    END_CLASS
END_NAMESPACE