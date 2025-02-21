namespace Tests_L4
{
    using AXOpen.Data;
    using System;
    using System.Linq;
    using Xunit;
    using Pocos.FragmentExchange_Test_L4;
    using System.Net.NetworkInformation;
    using AXOpen.Data.Query;
    using AXOpen.Base.Data.Query;

    [Collection("DatabaseTests")]
    public class MultipleRepository_MongoTests : IClassFixture<MultipleRepository_MongoFixture>
    {
        private readonly MultipleRepository_MongoFixture _fixture;

        public MultipleRepository_MongoTests(MultipleRepository_MongoFixture fixture)
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
            var pc = new PredicateContainer();

            pc.AddPredicates<HeaderData>(p => (p.vInt > 3 && p.vInt <= 8));
            pc.AddPredicates<StationData>(p => (p.vInt > 5 && p.vInt <= 7));

            var headerProdicates = pc.GetPredicates<HeaderData>();
            var stationProdicates = pc.GetPredicates<StationData>();

            IEnumerable<string> resultHeader = _fixture._headerRepository.GetEntityIds(pc);
            IEnumerable<string> resultStation = _fixture._stationRepository.GetEntityIds(pc);

            Assert.Equal(5, resultHeader.Count());
            Assert.Equal(2, resultStation.Count());
        }

    }
}