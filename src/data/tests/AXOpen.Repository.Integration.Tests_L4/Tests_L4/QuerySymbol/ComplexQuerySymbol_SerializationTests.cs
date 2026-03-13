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
        public void should_match_symbol_paths_with_all_complex_symbols()
        {
            var expectedSymbolPaths = new List<string>
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

            var actualSymbolPaths = _fixture.TestData.Select(x => x.SymbolPath).OrderBy(x => x).ToList();

            Assert.Equal(expectedSymbolPaths.OrderBy(x => x), actualSymbolPaths);
        }
       
        [Fact]
        public void should_validate_complex_query_symbol_collection_serialization()
        {
            var serializedQuerySymbolConfigurations = JsonSerializer.Serialize(_fixture.TestData);

            var deserializedQuerySymbolConfigurations = JsonSerializer.Deserialize<List<QuerySymbolConfiguration>>(serializedQuerySymbolConfigurations);

            Assert.NotNull(deserializedQuerySymbolConfigurations);
            Assert.Equal(_fixture.TestData.Count, deserializedQuerySymbolConfigurations.Count);

            for (int i = 0; i < _fixture.TestData.Count; i++)
            {
                var expectedQuerySymbolConfiguration = _fixture.TestData[i];
                var actualQuerySymbolConfiguration = deserializedQuerySymbolConfigurations[i];

                Assert.Equal(expectedQuerySymbolConfiguration.SymbolPath, actualQuerySymbolConfiguration.SymbolPath);
                Assert.Equal(expectedQuerySymbolConfiguration.SymbolTypeName, actualQuerySymbolConfiguration.SymbolTypeName);
                Assert.Equal(expectedQuerySymbolConfiguration.Operation, actualQuerySymbolConfiguration.Operation);

                Assert.NotNull(actualQuerySymbolConfiguration.MinOrValue);
                Assert.NotNull(actualQuerySymbolConfiguration.Max);

                Assert.Equal(expectedQuerySymbolConfiguration.MinOrValue?.GetType(), actualQuerySymbolConfiguration.MinOrValue?.GetType());
                Assert.Equal(expectedQuerySymbolConfiguration.Max?.GetType(), actualQuerySymbolConfiguration.Max?.GetType());

                Assert.Equal(expectedQuerySymbolConfiguration.MinOrValue, actualQuerySymbolConfiguration.MinOrValue);
                Assert.Equal(expectedQuerySymbolConfiguration.Max, actualQuerySymbolConfiguration.Max);
                    
                Assert.NotNull(expectedQuerySymbolConfiguration.RootType);
                Assert.Equal(expectedQuerySymbolConfiguration.RootType, actualQuerySymbolConfiguration.RootType);
            }
        }
       
    }
}
