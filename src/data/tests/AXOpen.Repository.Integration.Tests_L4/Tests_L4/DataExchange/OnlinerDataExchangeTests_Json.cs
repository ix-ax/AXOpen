namespace Tests_L4
{
    using Xunit;

    using PredicateBuilder = AXOpen.Data.Query.PredicateBuilder;

    [Collection(Constants.TESTS_JSON)]
    public class OnlinerDataExchangeTests_Json : OnlinerDataExchange_BaseTests, IClassFixture<SingleRepositoryFixture_Json>
    {
        public OnlinerDataExchangeTests_Json(SingleRepositoryFixture_Json fixture)
        {
            Fixture = fixture;

            ProcessExchange = axopen_integration_tests_l4.Entry.Plc.ExchangeContext_Test_L4.DataManager;
            ProcessExchange.SetRepository(Fixture.Repository);

            Exchange = ProcessExchange;
        }
    }
}