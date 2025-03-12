using AXOpen.Data.Query;
using System.Text.Json;
using Xunit;

namespace Tests_L4
{
    using Pocos.Exchange_Test_L4;

    [Collection("BuilderTest")]
    public class PlainBuilder_Tests : IClassFixture<PlainBuilder_Fixture>
    {
        private readonly PlainBuilder_Fixture _fixture;

        public PlainBuilder_Tests(PlainBuilder_Fixture fixture)
        {
            _fixture = fixture;
        }

        [Fact]
        public void plain_builder_should_be_initialized()
        {
            Assert.Equal(4, _fixture.builder.TypeDictionary.Count);

            Assert.True(_fixture.builder.TypeDictionary.ContainsKey(typeof(BasePrimitives)));
            Assert.True(_fixture.builder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L1)));
            Assert.True(_fixture.builder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L2)));
            Assert.True(_fixture.builder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L3)));
        }

        [Fact]
        public void plain_builder_should_retunt_symbols()
        {
            // 21 ms - 81 000
            // 15 ms - 54 000
            // 7 ms  - 27 000

            var symbols = _fixture.builder.GetSymbols();

            Assert.Equal(27001, symbols.Count());
        }
    }
}