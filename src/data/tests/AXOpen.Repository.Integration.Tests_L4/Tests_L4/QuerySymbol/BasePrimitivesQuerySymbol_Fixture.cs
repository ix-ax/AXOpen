using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using AXOpen.Data.Query;
using MongoDB.Driver;
using System.Text.Json.Serialization;

namespace Tests_L4
{
    public class BasePrimitivesQuerySymbol_Fixture : IDisposable
    {
        public List<QuerySymbolConfiguration> TestData { get; private set; } = new();

        public BasePrimitivesQuerySymbol_Fixture()
        {
            this.TestData.AddRange(InitializeQuerySymbols());
        }

        static string TypeName<T>() => typeof(T).FullName ?? throw new InvalidOperationException($"Unable to resolve full name for {typeof(T)}.");
        public static List<QuerySymbolConfiguration> InitializeQuerySymbols()
        {

            var rootTypeName = typeof(Pocos.Exchange_Test_L4.BasePrimitives).FullName
                ?? throw new InvalidOperationException("Unable to resolve full name of Pocos.Exchange_Test_L4.BasePrimitives.");

            var querySymbols = new List<QuerySymbolConfiguration>
                {
                    new QuerySymbolConfiguration(rootTypeName, "vBOOL", TypeName<bool>(), "==", false, true),
                    new QuerySymbolConfiguration(rootTypeName, "vBYTE", TypeName<byte>(), "==", byte.MinValue, byte.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vWORD", TypeName<ushort>(), "==", ushort.MinValue, ushort.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vDWORD", TypeName<uint>(), "==", uint.MinValue, uint.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vLWORD", TypeName<ulong>(), "==", ulong.MinValue, ulong.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vSINT", TypeName<sbyte>(), "==", sbyte.MinValue, sbyte.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vINT", TypeName<short>(), "==", short.MinValue, short.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vDINT", TypeName<int>(), "==", int.MinValue, int.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vLINT", TypeName<long>(), "==", long.MinValue, long.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vUSINT", TypeName<byte>(), "==", byte.MinValue, byte.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vUINT", TypeName<ushort>(), "==", ushort.MinValue, ushort.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vUDINT", TypeName<uint>(), "==", uint.MinValue, uint.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vULINT", TypeName<ulong>(), "==", ulong.MinValue, ulong.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vREAL", TypeName<float>(), "==", float.MinValue, float.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vLREAL", TypeName<double>(), "==", double.MinValue, double.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vTIME", TypeName<TimeSpan>(), "==", TimeSpan.MinValue, TimeSpan.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vLTIME", TypeName<TimeSpan>(), "==", TimeSpan.MinValue, TimeSpan.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vDATE", TypeName<DateOnly>(), "==", DateOnly.MinValue, DateOnly.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vLDATE", TypeName<DateOnly>(), "==", DateOnly.MinValue, DateOnly.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vTIME_OF_DAY", TypeName<TimeSpan>(), "==", TimeSpan.MinValue, TimeSpan.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vLTIME_OF_DAY", TypeName<TimeSpan>(), "==", TimeSpan.MinValue, TimeSpan.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vDATE_AND_TIME", TypeName<DateTime>(), "==", DateTime.MinValue, DateTime.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vLDATE_AND_TIME", TypeName<DateTime>(), "==", DateTime.MinValue, DateTime.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vCHAR", TypeName<char>(), "==", char.MinValue, char.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vWCHAR", TypeName<char>(), "==", char.MinValue, char.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vSTRING", TypeName<string>(), "==", "Min Or Value", "Max value"),
                    new QuerySymbolConfiguration(rootTypeName, "vWSTRING", TypeName<string>(), "==", "Min Or Value", "Max value"),
                };

            return querySymbols;
        }

        public void Dispose()
        {
            // Clean up resources if necessary
        }
    }
}