using Xunit;
using AXOpen.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AXOpen.Base.Data;
using AXOpen.Data.InMemory;
using AXSharp.Connector;
using NSubstitute;
using AXSharp.Connector;

namespace AXOpen.Data.Tests
{
    using TOnline = AXOpen.Data.AxoDataEntity;
    using TPlain = Pocos.AXOpen.Data.AxoDataEntity;
    using Pocos.AXOpen.Data;

    public class AxoDataExchangeTests
    {

        public class MockData : Pocos.AXOpen.Data.AxoDataEntity, Pocos.AXOpen.Data.IAxoDataEntity, IBrowsableDataObject
        {
            public string Name { get; set; }
            public int Age { get; set; }
            public dynamic RecordId { get; set; }
            public string DataEntityId { get; set; }
            public List<ValueChangeItem> Changes { get; set; }
        }

        public class OnlineMockData : AXOpen.Data.AxoDataEntity
        {
            public OnlineMockData(ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
            {
            }
        }

        [Fact()]
        public async void CreateTest()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new AxoDataExchange<OnlineMockData, MockData>(parent, "a", "b");
            var repo = new InMemoryRepository<MockData>();
            sut.SetRepository(repo);

            await sut.CreateAsync("aa", new MockData() { Name = "hello", Age = 1 });

            Assert.Equal(1, repo.Count);
            Assert.Equal("aa", repo.Queryable.First().DataEntityId);
            Assert.Equal("hello", repo.Queryable.First().Name);
            Assert.Equal(1, repo.Queryable.First().Age);
        }

        [Fact()]
        public async void ReadTest()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new AxoDataExchange<OnlineMockData, MockData>(parent, "a", "b");
            var repo = new InMemoryRepository<MockData>();
            sut.SetRepository(repo);

            await sut.CreateAsync("aa", new MockData() { Name = "hello", Age = 1 });
            await sut.CreateAsync("bb", new MockData() { Name = "hello", Age = 1 });

            var actual = await sut.ReadAsync("aa");

            Assert.Equal(2, repo.Count);
            Assert.Equal("aa", actual.DataEntityId);
            Assert.Equal("hello", actual.Name);
            Assert.Equal(1, actual.Age);
        }

        [Fact()]
        public async void UpdateTest()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new AxoDataExchange<OnlineMockData, MockData>(parent, "a", "b");
            var repo = new InMemoryRepository<MockData>();
            sut.SetRepository(repo);
            var toUpdate = new MockData() { Name = "hello", Age = 1 };
            await sut.CreateAsync("aa", toUpdate);

            toUpdate.Name = "world";
            toUpdate.Age = 100;

            await sut.UpdateAsync("aa", toUpdate);

            var actual = await sut.ReadAsync("aa");

            Assert.Equal(1, repo.Count);
            Assert.Equal("aa", actual.DataEntityId);
            Assert.Equal("world", actual.Name);
            Assert.Equal(100, actual.Age);
        }

        [Fact()]
        public async void DeleteTest()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new AxoDataExchange<OnlineMockData, MockData>(parent, "a", "b");
            var repo = new InMemoryRepository<MockData>();
            sut.SetRepository(repo);

            await sut.CreateAsync("aa", new MockData() { Name = "hello", Age = 1 });
            await sut.CreateAsync("bb", new MockData() { Name = "hello", Age = 1 });

            await sut.DeleteAsync("aa");


            Assert.Equal(1, repo.Count);

        }        
    }
}