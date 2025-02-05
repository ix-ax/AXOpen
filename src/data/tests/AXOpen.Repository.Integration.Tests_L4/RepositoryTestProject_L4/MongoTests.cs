using Microsoft.VisualStudio.TestPlatform.Utilities.Helpers;
using System.Reflection;

namespace RepositoryTestProject_L4
{
    using AXOpen.Base.Data;
    using AXOpen.Data.MongoDb;
    using System;
    using System.Linq.Expressions;
    using Xunit;

    [Collection("DatabaseTests")]
    public class MongoTests : IClassFixture<MongoDatabaseFixture>
    {
        private readonly MongoDatabaseFixture _fixture;

        public MongoTests(MongoDatabaseFixture fixture)
        {
            _fixture = fixture;
        }

        [Fact]
        public void ContainsRecords()
        {
            Assert.Equal(_fixture.repository.Count, 10);
        }

        [Fact]
        public void FindRecord()
        {
            IEnumerable<Expression<Func<DataTestObject, bool>>> predicates = new List<Expression<Func<DataTestObject, bool>>>
                {
                    p => p._Created > DateTime.Parse("2025-01-01T09:09:09"),
                    p => (p.Screw_1.Prog > 15 && p.Screw_2.Prog > 22),
                    p => (p.Screw_1.Torque.Result == 20),
                };

            var result = _fixture.repository.GetRecordsComplex(predicates);

            Assert.Equal(result.Count(), 4);
        }
    }
}