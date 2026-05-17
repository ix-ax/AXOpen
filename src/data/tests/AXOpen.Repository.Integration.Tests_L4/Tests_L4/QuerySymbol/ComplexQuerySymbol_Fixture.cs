using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using AXOpen.Data.Query;
using MongoDB.Driver;
using System.Text.Json.Serialization;

namespace Tests_L4
{
    public class ComplexQuerySymbol_Fixture : IDisposable
    {
        public List<QuerySymbolConfiguration> TestData { get; private set; } = new();

        public ComplexQuerySymbol_Fixture()
        {
            this.TestData.AddRange(InitializeQuerySymbols());
        }

        static string TypeName<T>() => typeof(T).FullName ?? throw new InvalidOperationException($"Unable to resolve full name for {typeof(T)}.");
        public static List<QuerySymbolConfiguration> InitializeQuerySymbols()
        {

            var rootTypeName = typeof(Pocos.FragmentExchange_Test_L4.StationData).FullName
                ?? throw new InvalidOperationException("Unable to resolve full name of Pocos.FragmentExchange_Test_L4.StationData.");

            var querySymbols = new List<QuerySymbolConfiguration>
                {
                    new QuerySymbolConfiguration(rootTypeName, "_EntityId", TypeName<string>(), "==","Min Or Value", "Max value"),
                  
                    new QuerySymbolConfiguration(rootTypeName, "ModifiedAt", TypeName<DateTime?>(),"==", DateTime.MinValue, DateTime.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "CreatedAt", TypeName<DateTime?>(),"==", DateTime.MinValue, DateTime.MaxValue),

                    new QuerySymbolConfiguration(rootTypeName, "vBool", TypeName<bool>(), "==", false, true),
                    new QuerySymbolConfiguration(rootTypeName, "vInt", TypeName<short>(), "==", short.MinValue, short.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "vString", TypeName<string>(), "==", "Min Or Value", "Max value"),
                    new QuerySymbolConfiguration(rootTypeName, "NestObj.vBool", TypeName<bool>(), "==", false, true),
                    new QuerySymbolConfiguration(rootTypeName, "NestObj.vInt", TypeName<short>(), "==", short.MinValue, short.MaxValue),
                    new QuerySymbolConfiguration(rootTypeName, "NestObj.vString", TypeName<string>(), "==", "Min Or Value", "Max value"),
                };

            return querySymbols;
        }

        public void Dispose()
        {
            // Clean up resources if necessary
        }
    }
}