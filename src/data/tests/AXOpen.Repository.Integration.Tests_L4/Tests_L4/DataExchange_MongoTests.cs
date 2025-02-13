namespace RepositoryTestProject_L4
{
    using Pocos.RepositoryTestProject_L4.DataExchange;
    using System;
    using System.Linq;
    using System.Linq.Expressions;
    using Xunit;

    [Collection("DatabaseTests")]
    public class DataExchange_MongoTests : IClassFixture<DataExchangeMongoFixture>
    {
        private readonly DataExchangeMongoFixture _fixture;

        public DataExchange_MongoTests(DataExchangeMongoFixture fixture)
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
            IEnumerable<Expression<Func<AxoProcessData, bool>>> predicates = new List<Expression<Func<AxoProcessData, bool>>>
                {
                    p => (p.vInt > 2 && (p.NestObj.vInt > 3 && p.NestObj.vInt <= 8)),
                    p => (p.vBool == true),
                };

            var result = _fixture._repository.GetRecords(predicates);

            Assert.Equal( 5, result.Count());
        }

        [Fact]
        public void should_return_entity_ids()
        {
            IEnumerable<Expression<Func<AxoProcessData, bool>>> predicates = new List<Expression<Func<AxoProcessData, bool>>>
                {
                    p => (p.vInt > 2 && (p.NestObj.vInt > 3 && p.NestObj.vInt <= 8)),
                    p => (p.vBool == true),
                };

            IEnumerable<string> result = _fixture._repository.GetEntityIds(predicates);

            Assert.Equal(5, result.Count());
        }

    }
}