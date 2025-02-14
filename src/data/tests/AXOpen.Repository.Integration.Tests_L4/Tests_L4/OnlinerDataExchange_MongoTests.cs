namespace Tests_L4
{
    using AXOpen.Data;
    using Exchange_Test_L4;
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Xunit;

    [Collection("DatabaseTests")]
    public class OnlinerDataExchange_MongoTests : IClassFixture<DataExchangeMongoFixture>
    {
        private readonly DataExchangeMongoFixture _fixture;

        private AxoDataExchange<ProcessData, Pocos.Exchange_Test_L4.ProcessData> _processExchange;
        private IAxoDataExchange _exchange;

        public OnlinerDataExchange_MongoTests(DataExchangeMongoFixture fixture)
        {
            _fixture = fixture;

            // initialize exchange
            _processExchange = axopen_integration_tests_l4.Entry.Plc.ExchangeContext_Test_L4.DataManager;
            _processExchange.SetRepository(_fixture._repository);

            _exchange = _processExchange;
        }

        [Fact]
        public void ContainsRecords()
        {
            Assert.Equal(_fixture._repository.Count, 10);
        }

        [Fact]
        public void should_return_entities()
        {
            IEnumerable<Expression<Func<Pocos.Exchange_Test_L4.ProcessData, bool>>> predicates = new List<Expression<Func<Pocos.Exchange_Test_L4.ProcessData, bool>>>
                {
                    p => (p.vInt > 2 && (p.NestObj.vInt > 3 && p.NestObj.vInt <= 8)),
                    p => (p.vBool == true),
                };

            var c = new PredicateContainer();

            c.AddPredicates<Pocos.Exchange_Test_L4.ProcessData>(predicates);

            var result = _exchange.GetRecords(c, 100, 0, "", false);

            Assert.Equal(5, result.Count());
        }
    }
}