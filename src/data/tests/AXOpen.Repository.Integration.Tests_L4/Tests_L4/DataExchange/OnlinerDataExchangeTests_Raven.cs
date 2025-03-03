namespace Tests_L4
{
    using Xunit;

    using PredicateBuilder = AXOpen.Data.Query.PredicateBuilder;

    [Collection(Constants.TESTS_RAVEN)]
    public class OnlinerDataExchangeTests_Raven : OnlinerDataExchange_BaseTests, IClassFixture<SingleRepositoryFixture_Raven>
    {
        public OnlinerDataExchangeTests_Raven(SingleRepositoryFixture_Raven fixture)
        {
            Fixture = fixture;

            ProcessExchange = axopen_integration_tests_l4.Entry.Plc.ExchangeContext_Test_L4.DataManager;
            ProcessExchange.SetRepository(Fixture.Repository);

            Exchange = ProcessExchange;
        }
    }
}