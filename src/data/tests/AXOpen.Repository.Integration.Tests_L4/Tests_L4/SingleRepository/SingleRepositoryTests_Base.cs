namespace Tests_L4
{
    using AXOpen.Base.Data.Query;
    using Pocos.Exchange_Test_L4;
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Xunit;

    public abstract class SingleRepositoryTests_Base
    {
        protected SingleRepositoryFixture_Base Fixture { set; get; }

        [Fact]
        public void ContainsRecords()
        {
            Assert.Equal(Fixture.Repository.Count, 10);
        }

        [Fact]
        public void should_return_entities()
        {
            var pc = new PredicateContainer();

            pc.AddPredicates<ProcessData>(p => (p.vInt > 2 && (p.Primitives.vINT > 3 && p.Primitives.vINT <= 8)));
            pc.AddPredicates<ProcessData>(p => (p.vBool == true));

            var result = Fixture.Repository.GetRecords(pc, 100, 0).ToList();

            Assert.Equal(3, result.Count());

            Assert.Equal("7", result[0].DataEntityId);
            Assert.Equal("5", result[1].DataEntityId);
            Assert.Equal("3", result[2].DataEntityId);
        }

        [Fact]
        public void should_return_entity_ids()
        {
            var pc = new PredicateContainer();

            pc.AddPredicates<ProcessData>(p => (p.vInt > 2 && (p.Primitives.vINT > 3 && p.Primitives.vINT <= 8)));
            pc.AddPredicates<ProcessData>(p => (p.vBool == true));

            List<string> result = Fixture.Repository.GetEntityIds(pc).ToList();

            Assert.Equal(3, result.Count());

            Assert.Equal("7", result[0]);
            Assert.Equal("5", result[1]);
            Assert.Equal("3", result[2]);
        }

        [Fact]
        public void should_return_entity_ids_in_order()
        {
            var pcAscending = new PredicateContainer();
            pcAscending.AddSortMember<ProcessData>(p => (p.DataEntityId), isAscending: true);

            List<string> requeestedIds = new() { "1", "9", "3", "7", };

            List<ProcessData> ascendingRecords = Fixture.Repository.GetRecords(requeestedIds, pcAscending).ToList();

            Assert.Equal(4, ascendingRecords.Count());

            Assert.Equal("1", ascendingRecords[0].DataEntityId);
            Assert.Equal("3", ascendingRecords[1].DataEntityId);
            Assert.Equal("7", ascendingRecords[2].DataEntityId);
            Assert.Equal("9", ascendingRecords[3].DataEntityId);

            var pcDescending = new PredicateContainer();
            pcDescending.AddSortMember<ProcessData>(p => (p.DataEntityId), isAscending: false);

            List<ProcessData> descendingRecords = Fixture.Repository.GetRecords(requeestedIds, pcDescending).ToList();

            Assert.Equal(4, descendingRecords.Count());

            Assert.Equal("9", descendingRecords[0].DataEntityId);
            Assert.Equal("7", descendingRecords[1].DataEntityId);
            Assert.Equal("3", descendingRecords[2].DataEntityId);
            Assert.Equal("1", descendingRecords[3].DataEntityId);
        }


        [Fact]
        public void should_return_intersected_ids_in_order()
        {
            var pc = new PredicateContainer();
            pc.AddSortMember<ProcessData>(p => (p.DataEntityId), isAscending: true);
            pc.AddPredicates<ProcessData>(p => (p.vInt > 1 && p.vInt < 9));


            List<string> requeestedIds = new() { "1", "9", "3", "7", };

            List<string> ascendingRecords = Fixture.Repository.GetEntityIds(pc, requeestedIds).ToList();

            Assert.Equal(2, ascendingRecords.Count());

            Assert.Equal("3", ascendingRecords[0]);
            Assert.Equal("7", ascendingRecords[1]);

        }
    }
}