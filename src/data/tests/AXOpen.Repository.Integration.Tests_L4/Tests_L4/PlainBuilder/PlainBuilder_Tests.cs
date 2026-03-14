using AXOpen.Data.Query;

namespace Tests_L4
{
    using Pocos.Exchange_Test_L4;

    [Collection("BuilderTest")]
    public class PlainBuilder_Tests
    {
        public PlainBuilder_Tests()
        {
            PlainSymbolBuilder.ClearStaticConfiguration();
        }


        [Fact]
        public void plain_builder_should_ignore_interface_properties()
        {
            PlainSymbolBuilder.IgnoreProperty(typeof(AXSharp.Connector.IPlain), "vBOOL");
            PlainSymbolBuilder.IgnoreProperty(typeof(AXSharp.Connector.IPlain), "vLDATE_AND_TIME");

            var builder = new PlainSymbolBuilder(typeof(BasePrimitives));
            var symbols = builder.GetSymbols();

            Assert.DoesNotContain("BasePrimitives.vBOOL",          symbols);
            Assert.DoesNotContain("BasePrimitives.vLDATE_AND_TIME", symbols);
        }

        [Fact]
        public void plain_builder_should_ignore_casted_properties()
        {
            PlainSymbolBuilder.IgnoreProperty(typeof(Pocos.AXOpen.Data.AxoDataEntity), "_EntityId");

            var builder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.ProcessData));
            var symbols = builder.GetSymbols();

            Assert.DoesNotContain("ProcessData._EntityId", symbols);
        }


        [Fact]
        public void plain_builder_should_take_into_account_nulable_time_properties()
        {
            var builder = new PlainSymbolBuilder(typeof(Pocos.AXOpen.Data.AxoDataEntity));
            var symbols = builder.GetSymbols();

            Assert.Equal(3, symbols.Count());
            Assert.Contains("AxoDataEntity._EntityId",  symbols);
            Assert.Contains("AxoDataEntity.ModifiedAt", symbols);
            Assert.Contains("AxoDataEntity.CreatedAt",  symbols);
        }

        [Fact]
        public void plain_builder_should_take_into_account_nulable_object_properties()
        {
            var builder = new PlainSymbolBuilder(typeof(NulableAxoDataEntity));
            var symbols = builder.GetSymbols();

            Assert.Equal(5, symbols.Count());
            Assert.Contains("NulableAxoDataEntity._EntityId",                       symbols);
            Assert.Contains("NulableAxoDataEntity.ModifiedAt",                      symbols);
            Assert.Contains("NulableAxoDataEntity.CreatedAt",                       symbols);
            Assert.Contains("NulableAxoDataEntity.NulableObject.NulableString",     symbols);
            Assert.Contains("NulableAxoDataEntity.ExcludedNulableObject.NulableString", symbols);
        }

        [Fact]
        public void plain_builder_should_ignore_object_with_attribute()
        {
            PlainSymbolBuilder.IgnoreAttribute(typeof(CustomExcludeAttribute));
            var builder = new PlainSymbolBuilder(typeof(NulableAxoDataEntity));
            var symbols = builder.GetSymbols();

            Assert.Equal(4, symbols.Count());
            Assert.Contains("NulableAxoDataEntity._EntityId",                           symbols);
            Assert.Contains("NulableAxoDataEntity.ModifiedAt",                          symbols);
            Assert.Contains("NulableAxoDataEntity.CreatedAt",                           symbols);
            Assert.Contains("NulableAxoDataEntity.NulableObject.NulableString",         symbols);
            Assert.DoesNotContain("NulableAxoDataEntity.ExcludedNulableObject.NulableString", symbols);
        }

        [Fact]
        public void plain_builder_should_ignore_root_properties()
        {
            PlainSymbolBuilder.IgnoreRootProperty("_EntityId");

            var builder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.ProcessData));

            Assert.DoesNotContain("ProcessData._EntityId", builder.GetSymbols());
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

            Assert.Equal(27000, symbols.Count());
        }
    }
}