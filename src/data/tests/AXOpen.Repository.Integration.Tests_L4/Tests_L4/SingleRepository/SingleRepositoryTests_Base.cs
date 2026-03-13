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
        public void should_contain_records()
        {
            Assert.Equal(Fixture.Repository.Count, 10);
        }

        [Fact]
        public void should_return_entities()
        {
            var predicateContainer = new PredicateContainer();

            predicateContainer.AddPredicates<ProcessData>(p => (p.vInt > 2 && (p.Primitives.vINT > 3 && p.Primitives.vINT <= 8)));
            predicateContainer.AddPredicates<ProcessData>(p => (p.vBool == true));

            var records = Fixture.Repository.GetRecords(predicateContainer, 100, 0).ToList();

            Assert.Equal(3, records.Count());

            Assert.Equal("7", records[0]._EntityId);
            Assert.Equal("5", records[1]._EntityId);
            Assert.Equal("3", records[2]._EntityId);
        }

        [Fact]
        public void should_return_entity_ids()
        {
            var predicateContainer = new PredicateContainer();

            predicateContainer.AddPredicates<ProcessData>(p => (p.vInt > 2 && (p.Primitives.vINT > 3 && p.Primitives.vINT <= 8)));
            predicateContainer.AddPredicates<ProcessData>(p => (p.vBool == true));

            List<string> entityIds = Fixture.Repository.GetEntityIds(predicateContainer).ToList();

            Assert.Equal(3, entityIds.Count());

            Assert.Equal("7", entityIds[0]);
            Assert.Equal("5", entityIds[1]);
            Assert.Equal("3", entityIds[2]);
        }

        [Fact]
        public void should_return_entity_ids_in_order()
        {
            var ascendingPredicateContainer = new PredicateContainer();
            ascendingPredicateContainer.AddSortMember<ProcessData>(p => (p._EntityId), isAscending: true);

            List<string> requestedIds = new() { "1", "9", "3", "7", };

            List<ProcessData> ascendingRecords = Fixture.Repository.GetRecords(requestedIds, ascendingPredicateContainer).ToList();

            Assert.Equal(4, ascendingRecords.Count());

            Assert.Equal("1", ascendingRecords[0]._EntityId);
            Assert.Equal("3", ascendingRecords[1]._EntityId);
            Assert.Equal("7", ascendingRecords[2]._EntityId);
            Assert.Equal("9", ascendingRecords[3]._EntityId);

            var descendingPredicateContainer = new PredicateContainer();
            descendingPredicateContainer.AddSortMember<ProcessData>(p => (p._EntityId), isAscending: false);

            List<ProcessData> descendingRecords = Fixture.Repository.GetRecords(requestedIds, descendingPredicateContainer).ToList();

            Assert.Equal(4, descendingRecords.Count());

            Assert.Equal("9", descendingRecords[0]._EntityId);
            Assert.Equal("7", descendingRecords[1]._EntityId);
            Assert.Equal("3", descendingRecords[2]._EntityId);
            Assert.Equal("1", descendingRecords[3]._EntityId);
        }


        [Fact]
        public void should_return_intersected_ids_in_order()
        {
            var predicateContainer = new PredicateContainer();
            predicateContainer.AddSortMember<ProcessData>(p => (p._EntityId), isAscending: true);
            predicateContainer.AddPredicates<ProcessData>(p => (p.vInt > 1 && p.vInt < 9));


            List<string> requestedIds = new() { "1", "9", "3", "7", };

            List<string> intersectedEntityIds = Fixture.Repository.GetEntityIds(predicateContainer, requestedIds).ToList();

            Assert.Equal(2, intersectedEntityIds.Count());

            Assert.Equal("3", intersectedEntityIds[0]);
            Assert.Equal("7", intersectedEntityIds[1]);

        }


        [Fact]
        public void should_return_records_with_created_at_from_initial_time()
        {
            var predicateContainer = new PredicateContainer();
            predicateContainer.AddPredicates<ProcessData>(p => (p.CreatedAt >= Fixture.InitialTestTime));

            var records = Fixture.Repository.GetRecords(predicateContainer, 100, 0).ToList();

            Assert.Equal(10, records.Count);
        }



    }
}
