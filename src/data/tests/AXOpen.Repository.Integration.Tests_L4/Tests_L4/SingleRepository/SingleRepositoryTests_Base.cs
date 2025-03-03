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

            pc.AddPredicates<ProcessData>(p => (p.vInt > 2 && (p.NestObj.vInt > 3 && p.NestObj.vInt <= 8)));
            pc.AddPredicates<ProcessData>(p => (p.vBool == true));

            pc.AddSortMember<ProcessData>(p => p.DataEntityId, false);

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

            pc.AddPredicates<ProcessData>(p => (p.vInt > 2 && (p.NestObj.vInt > 3 && p.NestObj.vInt <= 8)));
            pc.AddPredicates<ProcessData>(p => (p.vBool == true));

            pc.AddSortMember<ProcessData>(p => p.DataEntityId, false);

            List<string> result = Fixture.Repository.GetEntityIds(pc).ToList();

            Assert.Equal(3, result.Count());

            Assert.Equal("7", result[0]);
            Assert.Equal("5", result[1]);
            Assert.Equal("3", result[2]);
        }
    }
}