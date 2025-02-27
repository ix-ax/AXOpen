USING AXOpen.Core;
NAMESPACE IntegrationTests
    {S7.extern=ReadWrite}
    CLASS PUBLIC Integrations
        VAR PUBLIC
             Probers : ProbersTestContext;             
             DataExchangeLightTestsContext : IntegrationLightDirect.DataExchangeLightTestsContext;
             DataFragmentContext : IntegrationAxoDataFramentsExchange.AxoDataFragmentExchangeContext;
             DM : IntegrationLightDirect.DataManager;
             _rootObject    :   AxoObject;
        END_VAR
        
        METHOD PUBLIC Run 
            _rootObject.InitializeWithContext(DataExchangeLightTestsContext);
            Probers.Run();
            DM.Run(_rootObject);                     
            DataExchangeLightTestsContext.InjectDM(DM);
            DataExchangeLightTestsContext.Run();
            DataFragmentContext.Run();
        END_METHOD
    END_CLASS
END_NAMESPACE
