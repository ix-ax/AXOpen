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
        public void should_match_symbol_paths_with_all_baseprimitives_variables()
        {
            var expectedSymbols = new List<string>
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

            var actualSymbols = _fixture.TestData.Select(x => x.SymbolPath).OrderBy(x => x).ToList();

            Assert.Equal(expectedSymbols.OrderBy(x => x), actualSymbols);
        }

        [Fact]
        public void should_validate_query_symbol_serialization()
        {
            var expected = _fixture.TestData.First(); // it should be QuerySymbolConfiguration("Pocos.Exchange_Test_L4.BasePrimitives", "vBOOL", TypeName<bool>(), "==", false, true),
            var serialized = JsonSerializer.Serialize(expected);
            var deserialized = JsonSerializer.Deserialize<QuerySymbolConfiguration>(serialized);

            Assert.NotNull(deserialized);

            Assert.Equal(expected.RootTypeName, deserialized.RootTypeName);
            Assert.Equal(expected.SymbolPath, deserialized.SymbolPath);
            Assert.Equal(expected.SymbolTypeName, deserialized.SymbolTypeName);
            Assert.Equal(expected.Operation, deserialized.Operation);

            Assert.NotNull(deserialized.MinOrValue);
            Assert.NotNull(deserialized.Max);

            Assert.Equal(expected.MinOrValue?.GetType(), deserialized.MinOrValue?.GetType());
            Assert.Equal(expected.Max?.GetType(), deserialized.Max?.GetType());

            Assert.Equal(expected.MinOrValue, deserialized.MinOrValue);
            Assert.Equal(expected.Max, deserialized.Max);

            Assert.NotNull(expected.RootType);
            Assert.Equal(expected.RootType, deserialized.RootType);
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
