namespace Tests_L4
{
    using AXOpen.Base.Data.Query;
    using Pocos.Exchange_Test_L4;
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Xunit;

    [Collection("DatabaseTests")]
    public class SingleRepository_MontoTests : IClassFixture<SingleRepository_MongoFixture>
    {
        private readonly SingleRepository_MongoFixture _fixture;

        public SingleRepository_MontoTests(SingleRepository_MongoFixture fixture)
        {
            _fixture = fixture;
        }

        [Fact]
        public void ContainsRecords()
        {
            Assert.Equal(_fixture._repository.Count, 10);
        }

        [Fact]
        public void should_return_entities()
        {

            var pc = new PredicateContainer();

            pc.AddPredicates<ProcessData>(p => (p.vInt > 2 && (p.NestObj.vInt > 3 && p.NestObj.vInt <= 8)));
            pc.AddPredicates<ProcessData>(p => (p.vBool == true));

            var result = _fixture._repository.GetRecords(pc,100,0);

            Assert.Equal( 3, result.Count());
        }

        [Fact]
        public void should_return_entity_ids()
        {

            var pc = new PredicateContainer();

            pc.AddPredicates<ProcessData>(p => (p.vInt > 2 && (p.NestObj.vInt > 3 && p.NestObj.vInt <= 8)));
            pc.AddPredicates<ProcessData>(p => (p.vBool == true));


            IEnumerable<string> result = _fixture._repository.GetEntityIds(pc);

            Assert.Equal(3, result.Count());
        }

    }
}