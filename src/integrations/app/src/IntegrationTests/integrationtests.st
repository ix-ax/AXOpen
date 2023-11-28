NAMESPACE IntegrationTests
    {S7.extern=ReadWrite}
    CLASS PUBLIC Integrations
        VAR PUBLIC
             Probers : ProbersTestContext;             
             DataExchangeLightTestsContext : IntegrationLightDirect.DataExchangeLightTestsContext;
             DataFragmentContext : IntegrationAxoDataFramentsExchange.AxoDataFragmentExchangeContext;
             DM : IntegrationLightDirect.DataManager;
        END_VAR
        
        METHOD PUBLIC Run 
            Probers.Run();
            DM.Run(DataExchangeLightTestsContext);                     
            DataExchangeLightTestsContext.InjectDM(DM);
            DataExchangeLightTestsContext.Run();
            DataFragmentContext.Run();
        END_METHOD
    END_CLASS
END_NAMESPACE
