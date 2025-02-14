namespace Tests_L4
{
    using AXOpen.Data;
    using System;
    using System.Linq;
    using Xunit;
    using Pocos.FragmentExchange_Test_L4;
    using System.Collections.Frozen;

    [Collection("DatabaseTests")]
    public class OnlinerFragmentDataExchange_MongoTests : IClassFixture<FragmentDataExchangeMongoFixture>
    {
        private readonly FragmentDataExchangeMongoFixture _fixture;
        private FragmentExchange_Test_L4.FragmentProcessDataManager _FramgentManager;

        private IAxoDataExchange _exchange;

        public OnlinerFragmentDataExchange_MongoTests(FragmentDataExchangeMongoFixture fixture)
        {
            _fixture = fixture;

            _FramgentManager = axopen_integration_tests_l4.Entry.Plc.FragmentsExchangeContext_Test_L4.DataManager;

            _FramgentManager.CreateDataFragments<FragmentExchange_Test_L4.FragmentProcessDataManager>();

            _FramgentManager.Header.SetRepository(_fixture._headerRepository);
            _FramgentManager.St1.SetRepository(_fixture._stationRepository);

            _exchange = _FramgentManager;
        }

        [Fact]
        public void ContainsInitialRecords()
        {
            Assert.Equal(10, _exchange.GetRecords("").Count());
        }

        [Fact]
        public void should_return_entities_from_framgents()
        {
            var builder = new PredicateContainer();

            builder.AddPredicates<HeaderData>(p => (p.vInt > 3 && p.vInt <= 8));
            builder.AddPredicates<StationData>(p => (p.vInt > 5 && p.vInt <= 7));

            var headerProdicates = builder.GetPredicates<HeaderData>();
            var stationProdicates = builder.GetPredicates<StationData>();

            IEnumerable<string> resultHeader = _fixture._headerRepository.GetEntityIds(headerProdicates);
            IEnumerable<string> resultStation = _fixture._stationRepository.GetEntityIds(stationProdicates);

            var result = _exchange.GetRecords(builder, 1000, 0, "", false).ToList();

            Assert.Equal(2, result.Count());

            Assert.Equal("6", result[0].DataEntityId);
            Assert.Equal("7", result[1].DataEntityId);
        }

        [Fact]
        public void should_return_entities_from_framgents_string()
        {
            var builder = new PredicateContainer();

            //builder.AddPredicates<HeaderData>(p => (p.vString.Equals("odd 4")));
            builder.AddPredicates<HeaderData>(p => (p.vInt == 4));

            var result = _exchange.GetRecords(builder, 1000, 0, "", false).ToList();

            Assert.Equal(1, result.Count());

            Assert.Equal("4", result[0].DataEntityId);
        }
    }
}