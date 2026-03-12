using AXOpen.Data.Query;
using System.Text.Json;
using Xunit;

namespace Tests_L4
{
    [Collection("ComplexQuerySymbol")]
    public class ComplexQuerySymbol_SerializationTests : IClassFixture<ComplexQuerySymbol_Fixture>
    {
        private readonly ComplexQuerySymbol_Fixture _fixture;

        public ComplexQuerySymbol_SerializationTests(ComplexQuerySymbol_Fixture fixture)
        {
            _fixture = fixture;
        }

        [Fact]
        public void should_match_symbol_paths_with_all_baseprimitives_variables()
        {
            var expectedSymbols = new List<string>
            {
                "_EntityId",
                "ModifiedAt",
                "CreatedAt",
                "vBool",
                "vInt",
                "vString",
                "NestObj.vBool",
                "NestObj.vInt",
                "NestObj.vString",
            };

            var actualSymbols = _fixture.TestData.Select(x => x.SymbolPath).OrderBy(x => x).ToList();

            Assert.Equal(expectedSymbols.OrderBy(x => x), actualSymbols);
        }
       
        [Fact]
        public void should_validate_primitives_query_symbol_serialization()
        {
            var serialized = JsonSerializer.Serialize(_fixture.TestData);

            var deserialized = JsonSerializer.Deserialize<List<QuerySymbolConfiguration>>(serialized);

            Assert.NotNull(deserialized);
            Assert.Equal(_fixture.TestData.Count, deserialized.Count);

            for (int i = 0; i < _fixture.TestData.Count; i++)
            {
                var expected = _fixture.TestData[i];
                var actual = deserialized[i];

                Assert.Equal(expected.SymbolPath, actual.SymbolPath);
                Assert.Equal(expected.SymbolTypeName, actual.SymbolTypeName);
                Assert.Equal(expected.Operation, actual.Operation);

                Assert.NotNull(actual.MinOrValue);
                Assert.NotNull(actual.Max);

                Assert.Equal(expected.MinOrValue?.GetType(), actual.MinOrValue?.GetType());
                Assert.Equal(expected.Max?.GetType(), actual.Max?.GetType());

                Assert.Equal(expected.MinOrValue, actual.MinOrValue);
                Assert.Equal(expected.Max, actual.Max);
                    
                Assert.NotNull(expected.RootType);
                Assert.Equal(expected.RootType, actual.RootType);
            }
        }
       
    }
}
