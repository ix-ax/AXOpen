namespace Tests_L4
{
    using Xunit;

    using PredicateBuilder = AXOpen.Data.Query.PredicateBuilder;

    [Collection(Constants.TESTS_MONGO)]
    public class OnlinerDataExchangeTests_Mongo : OnlinerDataExchange_BaseTests, IClassFixture<SingleRepositoryFixture_Mongo>
    {
        public OnlinerDataExchangeTests_Mongo(SingleRepositoryFixture_Mongo fixture)
        {
            Fixture = fixture;

            ProcessExchange = axopen_integration_tests_l4.Entry.Plc.ExchangeContext_Test_L4.DataManager;
            ProcessExchange.SetRepository(Fixture.Repository);

            Exchange = ProcessExchange;
        }
    }
}