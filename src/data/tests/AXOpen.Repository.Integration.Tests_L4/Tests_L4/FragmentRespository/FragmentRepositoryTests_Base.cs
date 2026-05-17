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
        public void should_contain_initial_records()
        {
            Assert.Equal(Fixture.RepositoryStation.Count, 10);
            Assert.Equal(Fixture.RepositoryHeader.Count, 10);
        }

        [Fact]
        public void should_return_entities_from_fragments()
        {
            var predicateContainer = new PredicateContainer();

            predicateContainer.AddPredicates<HeaderData>(p => (p.vInt > 3 && p.vInt <= 8));
            predicateContainer.AddPredicates<StationData>(p => (p.vInt > 5 && p.vInt <= 7));

            var headerPredicates = predicateContainer.GetPredicates<HeaderData>();
            var stationPredicates = predicateContainer.GetPredicates<StationData>();

            IEnumerable<string> headerEntityIds = Fixture.RepositoryHeader.GetEntityIds(predicateContainer);
            IEnumerable<string> stationEntityIds = Fixture.RepositoryStation.GetEntityIds(predicateContainer);

            Assert.Equal(5, headerEntityIds.Count());
            Assert.Equal(2, stationEntityIds.Count());
        }
    }
}
