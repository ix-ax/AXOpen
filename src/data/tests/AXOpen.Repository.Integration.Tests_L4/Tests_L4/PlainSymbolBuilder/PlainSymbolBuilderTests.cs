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
        public void should_resolve_types_for_baseprimitives_symbols()
        {
            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(BasePrimitives));
            var plainSymbolPaths = plainSymbolBuilder.GetSymbolPaths().ToList();

            Assert.Equal(typeof(BasePrimitives).FullName, plainSymbolBuilder.RootTypeName);

            var expectedSymbolsWithTypes = new (string Symbol, Type Type)[]
            {
                ("vBOOL", typeof(bool)),
                ("vBYTE", typeof(byte)),
                ("vWORD", typeof(ushort)),
                ("vDWORD", typeof(uint)),
                ("vLWORD", typeof(ulong)),
                ("vSINT", typeof(sbyte)),
                ("vINT", typeof(short)),
                ("vDINT", typeof(int)),
                ("vLINT", typeof(long)),
                ("vUSINT", typeof(byte)),
                ("vUINT", typeof(ushort)),
                ("vUDINT", typeof(uint)),
                ("vULINT", typeof(ulong)),
                ("vREAL", typeof(float)),
                ("vLREAL", typeof(double)),
                ("vTIME", typeof(TimeSpan)),
                ("vLTIME", typeof(TimeSpan)),
                ("vDATE", typeof(DateOnly)),
                ("vLDATE", typeof(DateOnly)),
                ("vTIME_OF_DAY", typeof(TimeSpan)),
                ("vLTIME_OF_DAY", typeof(TimeSpan)),
                ("vDATE_AND_TIME", typeof(DateTime)),
                ("vLDATE_AND_TIME", typeof(DateTime)),
                ("vCHAR", typeof(char)),
                ("vWCHAR", typeof(char)),
                ("vSTRING", typeof(string)),
                ("vWSTRING", typeof(string))
            };

            Assert.Equal(expectedSymbolsWithTypes.Length, plainSymbolPaths.Count);
            foreach (var expected in expectedSymbolsWithTypes)
            {
                Assert.Contains(expected.Symbol, plainSymbolPaths);

                var symbolType = plainSymbolBuilder.GetSymbolType(expected.Symbol);
                Assert.NotNull(symbolType);
                Assert.Equal(expected.Type, symbolType);
            }
        }

        [Fact]
        public void should_resolve_types_for_stationdata_symbols()
        {
            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(Pocos.FragmentExchange_Test_L4.StationData));
            var plainSymbolPaths = plainSymbolBuilder.GetSymbolPaths().ToList();

            Assert.Equal(typeof(Pocos.FragmentExchange_Test_L4.StationData).FullName, plainSymbolBuilder.RootTypeName);

            var expectedSymbolsWithTypes = new (string Symbol, Type Type)[]
            {
                ("_EntityId", typeof(string)),
                ("ModifiedAt", typeof(DateTime?)),
                ("CreatedAt", typeof(DateTime?)),
                ("vString", typeof(string)),
                ("vInt", typeof(short)),
                ("vBool", typeof(bool)),
                ("NestObj.vString", typeof(string)),
                ("NestObj.vInt", typeof(short)),
                ("NestObj.vBool", typeof(bool)),
            };

            Assert.Equal(expectedSymbolsWithTypes.Length, plainSymbolPaths.Count);
            foreach (var expected in expectedSymbolsWithTypes)
            {
                Assert.Contains(expected.Symbol, plainSymbolPaths);
                var symbolType = plainSymbolBuilder.GetSymbolType(expected.Symbol);
                Assert.NotNull(symbolType);
                Assert.Equal(expected.Type, symbolType);
            }
        }

        [Fact]
        public void should_initialize_type_dictionary()
        {
            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.NestedPrimitives_L3));

            Assert.Equal(4, plainSymbolBuilder.TypeDictionary.Count);

            Assert.True(plainSymbolBuilder.TypeDictionary.ContainsKey(typeof(BasePrimitives)));
            Assert.True(plainSymbolBuilder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L1)));
            Assert.True(plainSymbolBuilder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L2)));
            Assert.True(plainSymbolBuilder.TypeDictionary.ContainsKey(typeof(NestedPrimitives_L3)));
        }

        [Fact]
        public void should_ignore_root_properties()
        {
            PlainSymbolBuilder.IgnoreRootProperty("_EntityId");

            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.ProcessData));

            Assert.DoesNotContain("_EntityId", plainSymbolBuilder.GetSymbolPaths());
        }

        [Fact]
        public void should_ignore_casted_properties()
        {
            PlainSymbolBuilder.IgnoreProperty(typeof(Pocos.AXOpen.Data.AxoDataEntity), "_EntityId");

            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(Pocos.Exchange_Test_L4.ProcessData));
            var plainSymbolPaths = plainSymbolBuilder.GetSymbolPaths();

            Assert.DoesNotContain("_EntityId", plainSymbolPaths);
        }

        [Fact]
        public void should_ignore_interface_properties()
        {
            PlainSymbolBuilder.IgnoreProperty(typeof(AXSharp.Connector.IPlain), "vBOOL");
            PlainSymbolBuilder.IgnoreProperty(typeof(AXSharp.Connector.IPlain), "vLDATE_AND_TIME");

            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(BasePrimitives));
            var plainSymbolPaths = plainSymbolBuilder.GetSymbolPaths();

            Assert.DoesNotContain("vBOOL", plainSymbolPaths);
            Assert.DoesNotContain("vLDATE_AND_TIME", plainSymbolPaths);
        }

        [Fact]
        public void should_include_nullable_time_properties()
        {
            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(Pocos.AXOpen.Data.AxoDataEntity));
            var plainSymbolPaths = plainSymbolBuilder.GetSymbolPaths();

            Assert.Equal(3, plainSymbolPaths.Count());
            Assert.Contains("_EntityId", plainSymbolPaths);
            Assert.Contains("ModifiedAt", plainSymbolPaths);
            Assert.Contains("CreatedAt", plainSymbolPaths);
        }

        [Fact]
        public void should_include_nullable_object_properties()
        {
            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(NulableAxoDataEntity));
            var plainSymbolPaths = plainSymbolBuilder.GetSymbolPaths();

            Assert.Equal(5, plainSymbolPaths.Count());
            Assert.Contains("_EntityId", plainSymbolPaths);
            Assert.Contains("ModifiedAt", plainSymbolPaths);
            Assert.Contains("CreatedAt", plainSymbolPaths);
            Assert.Contains("NulableObject.NulableString", plainSymbolPaths);
            Assert.Contains("ExcludedNulableObject.NulableString", plainSymbolPaths);
        }

        [Fact]
        public void should_ignore_object_with_attribute()
        {
            PlainSymbolBuilder.IgnoreAttribute(typeof(CustomExcludeAttribute));
            var plainSymbolBuilder = new PlainSymbolBuilder(typeof(NulableAxoDataEntity));
            var plainSymbolPaths = plainSymbolBuilder.GetSymbolPaths();

            Assert.Equal(4, plainSymbolPaths.Count());
            Assert.Contains("_EntityId", plainSymbolPaths);
            Assert.Contains("ModifiedAt", plainSymbolPaths);
            Assert.Contains("CreatedAt", plainSymbolPaths);
            Assert.Contains("NulableObject.NulableString", plainSymbolPaths);
            Assert.DoesNotContain("ExcludedNulableObject.NulableString", plainSymbolPaths);
        }

        [Fact]
        public void should_return_symbols()
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
