using AXOpen.Base.Data;
using AXOpen.Data.MongoDb;
using AXOpen.Data.Query;
using MongoDB.Driver;
using System.Text.Json.Serialization;

namespace Tests_L4
{
    public class Serialization_JsonFixture : IDisposable
    {
        public List<QuerySymbolConfiguration> TestData { get; private set; } = new();

        public Serialization_JsonFixture()
        {
            this.TestData.AddRange(InitializeQuerySymbols());
        }

        public static List<QuerySymbolConfiguration> InitializeQuerySymbols()
        {
            var querySymbols = new List<QuerySymbolConfiguration>
                {
                    new QuerySymbolConfiguration("TestFixture.myBOOL", typeof(bool).FullName, "==", false, true),
                    new QuerySymbolConfiguration("TestFixture.myBYTE", typeof(byte).FullName, "==", byte.MinValue, byte.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.myWORD", typeof(ushort).FullName, "==", ushort.MinValue, ushort.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.myDWORD", typeof(uint).FullName, "==", uint.MinValue, uint.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.myLWORD", typeof(ulong).FullName, "==", ulong.MinValue, ulong.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.mySINT", typeof(sbyte).FullName, "==", sbyte.MinValue, sbyte.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.myINT", typeof(short).FullName, "==", short.MinValue, short.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.myDINT", typeof(int).FullName, "==", int.MinValue, int.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.myLINT", typeof(long).FullName, "==", long.MinValue, long.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.myREAL", typeof(float).FullName, "==", float.MinValue, float.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.myLREAL", typeof(double).FullName, "==", double.MinValue, double.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.myCHAR", typeof(char).FullName, "==", char.MinValue, char.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.mySTRING", typeof(string).FullName, "==", "TEMPORRY : MIN  : VALUE", " MAX VAL "),
                    new QuerySymbolConfiguration("TestFixture.myDATE_AND_TIME", typeof(DateTime).FullName, "==", DateTime.MinValue, DateTime.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.myTIME", typeof(TimeSpan).FullName, "==", TimeSpan.MinValue, TimeSpan.MaxValue),
                    new QuerySymbolConfiguration("TestFixture.myDATE", typeof(DateOnly).FullName, "==", DateOnly.MinValue, DateOnly.MaxValue),
                };

            return querySymbols;
        }

        public void Dispose()
        {
            // Clean up resources if necessary
        }
    }
}