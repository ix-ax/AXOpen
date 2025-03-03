namespace Tests_L4
{
    using Xunit;

    using PredicateBuilder = AXOpen.Data.Query.PredicateBuilder;

    [Collection(Constants.TESTS_MEMORY)]
    public class OnlinerDataExchangeTests_InMemory : OnlinerDataExchange_BaseTests, IClassFixture<SingleRepositoryFixture_InMemory>
    {
        public OnlinerDataExchangeTests_InMemory(SingleRepositoryFixture_InMemory fixture)
        {
            Fixture = fixture;

            ProcessExchange = axopen_integration_tests_l4.Entry.Plc.ExchangeContext_Test_L4.DataManager;
            ProcessExchange.SetRepository(Fixture.Repository);

            Exchange = ProcessExchange;
        }
    }
}