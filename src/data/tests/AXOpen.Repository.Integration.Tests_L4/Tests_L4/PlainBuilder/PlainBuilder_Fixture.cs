using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using AXOpen.Data.Query;
using MongoDB.Driver;
using System.Text.Json.Serialization;

namespace Tests_L4
{
    public class PlainBuilder_Fixture : IDisposable
    {
        public Pocos.Exchange_Test_L4.NestedPrimitives_L3 TestData { get; private set; }

        public PlainSymbolBuilder builder { get; private set; }

        public PlainBuilder_Fixture()
        {
            TestData = new Pocos.Exchange_Test_L4.NestedPrimitives_L3();
            builder = new PlainSymbolBuilder(TestData.GetType());
        }

        public void Dispose()
        {
            // Clean up resources if necessary
        }
    }
}