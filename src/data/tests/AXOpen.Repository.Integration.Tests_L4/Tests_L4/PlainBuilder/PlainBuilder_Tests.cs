using AXOpen.Data.Query;

namespace Tests_L4
{
    using Pocos.Exchange_Test_L4;

    [Collection("BuilderTest")]
    public class PlainBuilder_Tests
    {
        public PlainBuilder_Tests()
        {
        }

        [Fact]
        public void plain_builder_should_ignore_interface_properties()
        {
            PlainSymbolBuilder.IgnoreProperty(typeof(AXSharp.Connector.IPlain), "vBOOL");
            PlainSymbolBuilder.IgnoreProperty(typeof(AXSharp.Connector.IPlain), "vLDATE_AND_TIME");

            var builder = new PlainSymbolBuilder(typeof(BasePrimitives));

            Assert.False(builder.GetSymbols().Where(s => s.Contains("vBOOL")).Any());
            Assert.False(builder.GetSymbols().Where(s => s.Contains("vLDATE_AND_TIME")).Any());
        }

        [Fact]
        public void plain_builder_should_ignore_casted_properties()
        {
            PlainSymbolBuilder.IgnoreProperty(typeof(Pocos.AXOpen.Data.AxoDataEntity), "DataEntityId");

            var builder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.ProcessData));

            Assert.False(builder.GetSymbols().Where(s => s.Contains("DataEntityId")).Any());
        }

        [Fact]
        public void plain_builder_should_be_initialized()
        {
            var builder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.NestedPrimitives_L3));

            Assert.Equal(4, builder.TypeDictionary.Count);

            Assert.True(builder.TypeDictionary.ContainsKey(typeof(BasePrimitives)));
            Assert.True(builder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L1)));
            Assert.True(builder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L2)));
            Assert.True(builder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L3)));
        }

        [Fact]
        public void plain_builder_should_retunt_symbols()
        {
            // 21 ms - 81 000
            // 15 ms - 54 000
            // 7 ms  - 27 000

            var builder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.NestedPrimitives_L3));

            var symbols = builder.GetSymbols();

            Assert.Equal(27001, symbols.Count());
        }
    }
}