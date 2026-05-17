using AXOpen.Data.Query;
using System.Text.Json;
using Xunit;

namespace Tests_L4
{
    [Collection("BasePrimitivesQuerySymbol")]
    public class BasePrimitivesQuerySymbol_SerializationTests : IClassFixture<BasePrimitivesQuerySymbol_Fixture>
    {
        private readonly BasePrimitivesQuerySymbol_Fixture _fixture;

        public BasePrimitivesQuerySymbol_SerializationTests(BasePrimitivesQuerySymbol_Fixture fixture)
        {
            _fixture = fixture;
        }

        [Fact]
        public void should_match_symbol_paths_with_all_base_primitives_symbols()
        {
            var expectedSymbolPaths = new List<string>
            {
                "vBOOL",
                "vBYTE",
                "vWORD",
                "vDWORD",
                "vLWORD",
                "vSINT",
                "vINT",
                "vDINT",
                "vLINT",
                "vUSINT",
                "vUINT",
                "vUDINT",
                "vULINT",
                "vREAL",
                "vLREAL",
                "vTIME",
                "vLTIME",
                "vDATE",
                "vLDATE",
                "vTIME_OF_DAY",
                "vLTIME_OF_DAY",
                "vDATE_AND_TIME",
                "vLDATE_AND_TIME",
                "vCHAR",
                "vWCHAR",
                "vSTRING",
                "vWSTRING",
            };

            var actualSymbolPaths = _fixture.TestData.Select(x => x.SymbolPath).OrderBy(x => x).ToList();

            Assert.Equal(expectedSymbolPaths.OrderBy(x => x), actualSymbolPaths);
        }

        [Fact]
        public void should_validate_query_symbol_serialization()
        {
            var expectedQuerySymbolConfiguration = _fixture.TestData.First(); // it should be QuerySymbolConfiguration("Pocos.Exchange_Test_L4.BasePrimitives", "vBOOL", TypeName<bool>(), "==", false, true),
            var serializedQuerySymbolConfiguration = JsonSerializer.Serialize(expectedQuerySymbolConfiguration);
            var deserializedQuerySymbolConfiguration = JsonSerializer.Deserialize<QuerySymbolConfiguration>(serializedQuerySymbolConfiguration);

            Assert.NotNull(deserializedQuerySymbolConfiguration);

            Assert.Equal(expectedQuerySymbolConfiguration.RootTypeName, deserializedQuerySymbolConfiguration.RootTypeName);
            Assert.Equal(expectedQuerySymbolConfiguration.SymbolPath, deserializedQuerySymbolConfiguration.SymbolPath);
            Assert.Equal(expectedQuerySymbolConfiguration.SymbolTypeName, deserializedQuerySymbolConfiguration.SymbolTypeName);
            Assert.Equal(expectedQuerySymbolConfiguration.Operation, deserializedQuerySymbolConfiguration.Operation);

            Assert.NotNull(deserializedQuerySymbolConfiguration.MinOrValue);
            Assert.NotNull(deserializedQuerySymbolConfiguration.Max);

            Assert.Equal(expectedQuerySymbolConfiguration.MinOrValue?.GetType(), deserializedQuerySymbolConfiguration.MinOrValue?.GetType());
            Assert.Equal(expectedQuerySymbolConfiguration.Max?.GetType(), deserializedQuerySymbolConfiguration.Max?.GetType());

            Assert.Equal(expectedQuerySymbolConfiguration.MinOrValue, deserializedQuerySymbolConfiguration.MinOrValue);
            Assert.Equal(expectedQuerySymbolConfiguration.Max, deserializedQuerySymbolConfiguration.Max);

            Assert.NotNull(expectedQuerySymbolConfiguration.RootType);
            Assert.Equal(expectedQuerySymbolConfiguration.RootType, deserializedQuerySymbolConfiguration.RootType);
        }


        [Fact]
        public void should_validate_base_primitives_query_symbol_collection_serialization()
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
