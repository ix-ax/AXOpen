namespace Tests_L4
{
    using AXOpen.Data;
    using System;
    using System.Linq;
    using Xunit;
    using Pocos.FragmentExchange_Test_L4;
    using System.Net.NetworkInformation;

    [Collection("DatabaseTests")]
    public class FragmentDataExchange_MongoTests : IClassFixture<FragmentDataExchangeMongoFixture>
    {
        private readonly FragmentDataExchangeMongoFixture _fixture;

        public FragmentDataExchange_MongoTests(FragmentDataExchangeMongoFixture fixture)
        {
            _fixture = fixture;
        }

        [Fact]
        public void ContainsInitialRecords()
        {
            Assert.Equal(_fixture._stationRepository.Count, 10);
            Assert.Equal(_fixture._headerRepository.Count, 10);
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

            Assert.Equal(5, resultHeader.Count());
            Assert.Equal(2, resultStation.Count());
        }

    }
}