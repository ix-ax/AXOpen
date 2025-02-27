using AXOpen.Data.Query;
using System.Text.Json;
using Xunit;

namespace Tests_L4
{
    [Collection("Serialization")]
    public class Serialization_JsonTests : IClassFixture<Serialization_JsonFixture>
    {
        private readonly Serialization_JsonFixture _fixture;

        public Serialization_JsonTests(Serialization_JsonFixture fixture)
        {
            _fixture = fixture;
        }

        [Fact]
        public void should_preserve_all_query_symbol_configuration_properties()
        {
            var serialized = JsonSerializer.Serialize(_fixture.TestData);
            var deserialized = JsonSerializer.Deserialize<List<QuerySymbolConfiguration>>(serialized);

            Assert.NotNull(deserialized);
            Assert.Equal(_fixture.TestData.Count, deserialized.Count);

            for (int i = 0; i < _fixture.TestData.Count; i++)
            {
                var expected = _fixture.TestData[i];
                var actual = deserialized[i];

                Assert.Equal(expected.SymbolPathWithParent, actual.SymbolPathWithParent);
                Assert.Equal(expected.SymbolTypeFullName, actual.SymbolTypeFullName);
                Assert.Equal(expected.Operation, actual.Operation);

                Assert.NotNull(actual.MinOrValue);
                Assert.NotNull(actual.Max);

                Assert.Equal(expected.MinOrValue?.GetType(), actual.MinOrValue?.GetType());
                Assert.Equal(expected.Max?.GetType(), actual.Max?.GetType());

                Assert.Equal(expected.MinOrValue, actual.MinOrValue);
                Assert.Equal(expected.Max, actual.Max);

            }
        }


        [Theory]
        [InlineData("TestFixture.myBOOL", typeof(bool))]
        [InlineData("TestFixture.myBYTE", typeof(byte))]
        [InlineData("TestFixture.myWORD", typeof(ushort))]
        [InlineData("TestFixture.myDWORD", typeof(uint))]
        [InlineData("TestFixture.myLWORD", typeof(ulong))]
        [InlineData("TestFixture.mySINT", typeof(sbyte))]
        [InlineData("TestFixture.myINT", typeof(short))]
        [InlineData("TestFixture.myDINT", typeof(int))]
        [InlineData("TestFixture.myLINT", typeof(long))]
        [InlineData("TestFixture.myREAL", typeof(float))]
        [InlineData("TestFixture.myLREAL", typeof(double))]
        [InlineData("TestFixture.myTIME", typeof(TimeSpan))]
        [InlineData("TestFixture.myDATE", typeof(DateOnly))]
        [InlineData("TestFixture.myDATE_AND_TIME", typeof(DateTime))]
        [InlineData("TestFixture.myCHAR", typeof(char))]
        [InlineData("TestFixture.mySTRING", typeof(string))]
        public void should_correctly_serialize_and_deserialize_various_types(string symbolPath, Type type)
        {
            var item = _fixture.TestData.Find(x => x.SymbolPathWithParent.Equals(symbolPath));

            Assert.NotNull(item);
            Assert.Equal(type.FullName, item.SymbolTypeFullName);

            var serialized = JsonSerializer.Serialize(item);
            var deserialized = JsonSerializer.Deserialize<QuerySymbolConfiguration>(serialized);

            Assert.NotNull(deserialized);
            Assert.Equal(item.SymbolPathWithParent, deserialized.SymbolPathWithParent);
            Assert.Equal(item.MinOrValue.GetType(), deserialized.MinOrValue.GetType());
            Assert.Equal(item.MinOrValue, deserialized.MinOrValue);
            Assert.Equal(item.Max.GetType(), deserialized.Max.GetType());
            Assert.Equal(item.Max, deserialized.Max);
        }
    }
}
