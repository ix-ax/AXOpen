using AXOpen.Data.Query;

namespace Tests_L4
{
    using Pocos.Exchange_Test_L4;

    [Collection("PlainSymbolBuilder")]
    public class PlainSymbolBuilderTests
    {
        public PlainSymbolBuilderTests()
        {
            PlainSymbolBuilder.ClearStaticConfiguration();
        }

        [Fact]
        public void plain_symbol_builder_should_be_initialized()
        {
            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.NestedPrimitives_L3));

            Assert.Equal(4, plainSymbolBuilder.TypeDictionary.Count);

            Assert.True(plainSymbolBuilder.TypeDictionary.ContainsKey(typeof(BasePrimitives)));
            Assert.True(plainSymbolBuilder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L1)));
            Assert.True(plainSymbolBuilder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L2)));
            Assert.True(plainSymbolBuilder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L3)));
        }

        [Fact]
        public void plain_symbol_builder_should_recognize_all_symbols()
        {
            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(BasePrimitives));
            var plainSymbols = plainSymbolBuilder.GetSymbols().ToList();

            Assert.Equal(typeof(BasePrimitives).FullName, plainSymbolBuilder.RootTypeName);

            var expectedSymbols = new[]
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
                "vWSTRING"
            };

            Assert.Equal(expectedSymbols.Length, plainSymbols.Count);
            foreach (var symbol in expectedSymbols)
            {
                Assert.Contains(symbol, plainSymbols);
            }
        }

        [Fact]
        public void plain_symbol_builder_should_ignore_interface_properties()
        {
            PlainSymbolBuilder.IgnoreProperty(typeof(AXSharp.Connector.IPlain), "vBOOL");
            PlainSymbolBuilder.IgnoreProperty(typeof(AXSharp.Connector.IPlain), "vLDATE_AND_TIME");

            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(BasePrimitives));
            var plainSymbols = plainSymbolBuilder.GetSymbols();

            Assert.DoesNotContain("vBOOL", plainSymbols);
            Assert.DoesNotContain("vLDATE_AND_TIME", plainSymbols);
        }

        [Fact]
        public void plain_symbol_builder_should_ignore_casted_properties()
        {
            PlainSymbolBuilder.IgnoreProperty(typeof(Pocos.AXOpen.Data.AxoDataEntity), "_EntityId");

            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.ProcessData));
            var plainSymbols = plainSymbolBuilder.GetSymbols();

            Assert.DoesNotContain("_EntityId", plainSymbols);
        }

        [Fact]
        public void plain_symbol_builder_should_include_nullable_time_properties()
        {
            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(Pocos.AXOpen.Data.AxoDataEntity));
            var plainSymbols = plainSymbolBuilder.GetSymbols();

            Assert.Equal(3, plainSymbols.Count());
            Assert.Contains("_EntityId", plainSymbols);
            Assert.Contains("ModifiedAt", plainSymbols);
            Assert.Contains("CreatedAt", plainSymbols);
        }

        [Fact]
        public void plain_symbol_builder_should_include_nullable_object_properties()
        {
            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(NulableAxoDataEntity));
            var plainSymbols = plainSymbolBuilder.GetSymbols();

            Assert.Equal(5, plainSymbols.Count());
            Assert.Contains("_EntityId", plainSymbols);
            Assert.Contains("ModifiedAt", plainSymbols);
            Assert.Contains("CreatedAt", plainSymbols);
            Assert.Contains("NulableObject.NulableString", plainSymbols);
            Assert.Contains("ExcludedNulableObject.NulableString", plainSymbols);
        }

        [Fact]
        public void plain_symbol_builder_should_ignore_object_with_attribute()
        {
            PlainSymbolBuilder.IgnoreAttribute(typeof(CustomExcludeAttribute));
            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(NulableAxoDataEntity));
            var plainSymbols = plainSymbolBuilder.GetSymbols();

            Assert.Equal(4, plainSymbols.Count());
            Assert.Contains("_EntityId", plainSymbols);
            Assert.Contains("ModifiedAt", plainSymbols);
            Assert.Contains("CreatedAt", plainSymbols);
            Assert.Contains("NulableObject.NulableString", plainSymbols);
            Assert.DoesNotContain("ExcludedNulableObject.NulableString", plainSymbols);
        }

        [Fact]
        public void plain_symbol_builder_should_ignore_root_properties()
        {
            PlainSymbolBuilder.IgnoreRootProperty("_EntityId");

            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.ProcessData));

            Assert.DoesNotContain("_EntityId", plainSymbolBuilder.GetSymbols());
        }

        [Fact]
        public void plain_symbol_builder_should_return_symbols()
        {
            // 21 ms - 81 000
            // 15 ms - 54 000
            // 7 ms  - 27 000

            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.NestedPrimitives_L3));

            var plainSymbols = plainSymbolBuilder.GetSymbols();

            Assert.Equal(27000, plainSymbols.Count());
        }
    }
}
