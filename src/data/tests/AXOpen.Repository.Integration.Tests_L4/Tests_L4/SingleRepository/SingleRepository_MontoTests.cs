namespace Tests_L4
{
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
            IEnumerable<Expression<Func<ProcessData, bool>>> predicates = new List<Expression<Func<ProcessData, bool>>>
                {
                    p => (p.vInt > 2 && (p.NestObj.vInt > 3 && p.NestObj.vInt <= 8)),
                    p => (p.vBool == true),
                };

            var result = _fixture._repository.GetRecords(predicates);

            Assert.Equal( 3, result.Count());
        }

        [Fact]
        public void should_return_entity_ids()
        {
            IEnumerable<Expression<Func<ProcessData, bool>>> predicates = new List<Expression<Func<ProcessData, bool>>>
                {
                    p => (p.vInt > 2 && (p.NestObj.vInt > 3 && p.NestObj.vInt <= 8)),
                    p => (p.vBool == true),
                };

            IEnumerable<string> result = _fixture._repository.GetEntityIds(predicates);

            Assert.Equal(3, result.Count());
        }

    }
}