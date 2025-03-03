namespace Tests_L4
{
    using System;
    using System.Linq;
    using Xunit;
    using Pocos.FragmentExchange_Test_L4;
    using AXOpen.Base.Data.Query;

    public abstract class FragmentRepositoryTests_Base
    {
        protected FragmentRepositoryFixture_Base Fixture { set; get; }

        [Fact]
        public void ContainsInitialRecords()
        {
            Assert.Equal(Fixture.RepositoryStation.Count, 10);
            Assert.Equal(Fixture.RepositoryHeader.Count, 10);
        }

        [Fact]
        public void should_return_entities_from_framgents()
        {
            var pc = new PredicateContainer();

            pc.AddPredicates<HeaderData>(p => (p.vInt > 3 && p.vInt <= 8));
            pc.AddPredicates<StationData>(p => (p.vInt > 5 && p.vInt <= 7));

            var headerProdicates = pc.GetPredicates<HeaderData>();
            var stationProdicates = pc.GetPredicates<StationData>();

            IEnumerable<string> resultHeader = Fixture.RepositoryHeader.GetEntityIds(pc);
            IEnumerable<string> resultStation = Fixture.RepositoryStation.GetEntityIds(pc);

            Assert.Equal(5, resultHeader.Count());
            Assert.Equal(2, resultStation.Count());
        }
    }
}