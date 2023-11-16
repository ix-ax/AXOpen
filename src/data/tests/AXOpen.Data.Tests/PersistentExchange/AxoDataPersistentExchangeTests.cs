using AXOpen.Data.InMemory;
using AXSharp.Connector;
using Microsoft.VisualBasic;
using NSubstitute;

namespace AXOpen.Data.Persistent.Tests
{
    public class AxoDataPersistentExchangeTests
    {
        public class OnlineMockData : AxoDataPersistentExchangeExample.PersistentRootObject
        {
            public OnlineMockData(ITwinObject parent, string readableTail, string symbolTail) : base(parent, readableTail, symbolTail)
            {
            }
        }

        [Fact()]
        public async void CreateInRepositoryTest()
        {
            const string PersistentGroupName = "default";

            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var data = new OnlineMockData(parent, "a", "b");
            var repo = new InMemoryRepository<AXOpen.Data.PersistentRecord>();
            //var sut = new AXOpen.Data.AxoDataPersistentExchange(parent, "perExchange", "PerExchange");
            //sut.InitializeRemoteDataExchange(data, repo);

            PersistentRecord pr = new AXOpen.Data.PersistentRecord() { DataEntityId = PersistentGroupName };

            pr.Tags.Add(new TagObject() { Symbol = data.PersistentVariable_1.Symbol, Value = 10 });
            pr.Tags.Add(new TagObject() { Symbol = data.PersistentVariable_2.Symbol, Value = 20 });
            pr.Tags.Add(new TagObject() { Symbol = data.NotPersistentVariable.Symbol, Value = true });

            repo.Create(PersistentGroupName, pr);

            Assert.Equal(1, repo.Count);
            Assert.Equal(PersistentGroupName, repo.Queryable.First().DataEntityId);
            Assert.Equal(3, repo.Queryable.First().Tags.Count());

            Assert.Equal(data.PersistentVariable_1.Symbol, repo.Queryable.First().Tags[0].Symbol);
            Assert.Equal(data.PersistentVariable_2.Symbol, repo.Queryable.First().Tags[1].Symbol);
            Assert.Equal(data.NotPersistentVariable.Symbol, repo.Queryable.First().Tags[2].Symbol);

            Assert.Equal(10, repo.Queryable.First().Tags[0].Value);
            Assert.Equal(20, repo.Queryable.First().Tags[1].Value);
            Assert.Equal(true, repo.Queryable.First().Tags[2].Value);
        }

        [Fact()]
        public async void ReadFromRepositoryTest()
        {
            const string PersistentGroupName = "default";
            const string PersistentGroupName_1 = "1";

            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var data = new OnlineMockData(parent, "a", "b");
            var repo = new InMemoryRepository<AXOpen.Data.PersistentRecord>();
            // var sut = new AXOpen.Data.AxoDataPersistentExchange(parent, "perExchange", "PerExchange");
            // await sut.InitializeRemoteDataExchange(data, repo);

            PersistentRecord pr = new AXOpen.Data.PersistentRecord() { DataEntityId = PersistentGroupName };
            pr.Tags.Add(new TagObject() { Symbol = data.PersistentVariable_1.Symbol, Value = 10 });
            pr.Tags.Add(new TagObject() { Symbol = data.PersistentVariable_2.Symbol, Value = 20 });
            pr.Tags.Add(new TagObject() { Symbol = data.NotPersistentVariable.Symbol, Value = false });

            repo.Create(PersistentGroupName, pr);

            PersistentRecord pr_1 = new AXOpen.Data.PersistentRecord() { DataEntityId = PersistentGroupName_1 };
            pr.Tags.Add(new TagObject() { Symbol = data.PersistentVariable_1.Symbol, Value = 110 });
            pr.Tags.Add(new TagObject() { Symbol = data.PersistentVariable_2.Symbol, Value = 120 });
            pr.Tags.Add(new TagObject() { Symbol = data.NotPersistentVariable.Symbol, Value = true });

            repo.Create(PersistentGroupName_1, pr_1);

            var recordFromRepo = repo.Read(PersistentGroupName);

            Assert.Equal(2, repo.Count);
            Assert.Equal(PersistentGroupName, recordFromRepo.DataEntityId);
            Assert.False(recordFromRepo.Tags.Where(p => p.Symbol == data.NotPersistentVariable.Symbol).First().Value);
            Assert.Equal(10, recordFromRepo.Tags.Where(p => p.Symbol == data.PersistentVariable_1.Symbol).First().Value);
            Assert.Equal(20, recordFromRepo.Tags.Where(p => p.Symbol == data.PersistentVariable_2.Symbol).First().Value);
        }

        [Fact()]
        public async void RemoteRead_ShouldWriteFromRepositoryToController()
        {
            const string PersistentGroupName = "default";

            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var data = new OnlineMockData(parent, "a", "b");
            var repo = new InMemoryRepository<AXOpen.Data.PersistentRecord>();
            var sut = new AXOpen.Data.AxoDataPersistentExchange(parent, "perExchange", "PerExchange");
            sut.InitializeRemoteDataExchange(data, repo);

            PersistentRecord pr = new AXOpen.Data.PersistentRecord() { DataEntityId = PersistentGroupName };

            pr.Tags.Add(new TagObject() { Symbol = data.PersistentVariable_1.Symbol, Value = 10 });
            pr.Tags.Add(new TagObject() { Symbol = data.PersistentVariable_2.Symbol, Value = 20 });
            pr.Tags.Add(new TagObject() { Symbol = data.NotPersistentVariable.Symbol, Value = false });

            repo.Create(PersistentGroupName, pr);

            data.NotPersistentVariable.Cyclic = true;
            data.PersistentVariable_1.Cyclic = 100;
            data.PersistentVariable_2.Cyclic = 100;

            await data.WriteAsync();

            await sut.WritePersistentGroupFromRepository(PersistentGroupName);

            Assert.True(data.NotPersistentVariable.Cyclic);
            Assert.Equal(10, data.PersistentVariable_1.Cyclic);
            Assert.Equal(20, data.PersistentVariable_2.Cyclic);
        }

        [Fact()]
        public async void RemoteUpadate_ShouldWriteToRpositoryFromController()
        {
            const string PersistentGroupName = "default";

            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var data = new OnlineMockData(parent, "a", "b");
            var repo = new InMemoryRepository<AXOpen.Data.PersistentRecord>();
            var sut = new AXOpen.Data.AxoDataPersistentExchange(parent, "perExchange", "PerExchange");

            await sut.InitializeRemoteDataExchange(data, repo);

            data.NotPersistentVariable.Cyclic = true;
            data.PersistentVariable_1.Cyclic = 10;
            data.PersistentVariable_2.Cyclic = 20;
            await data.WriteAsync();

            await sut.UpdatePersistentGroupFromPlcToRepository(PersistentGroupName);

            PersistentRecord pr = repo.Read(PersistentGroupName);

            var TagValue_PersistentVariable_1 = pr.Tags.Where(p => p.Symbol == data.PersistentVariable_1.Symbol).First().Value;
            var TagValue_PersistentVariable_2 = pr.Tags.Where(p => p.Symbol == data.PersistentVariable_2.Symbol).First().Value;
            var TagValue_NotPersistentVariable_Exist = pr.Tags.Where(p => p.Symbol == data.NotPersistentVariable.Symbol).Any();

            Assert.False(TagValue_NotPersistentVariable_Exist);
            Assert.Equal(10, TagValue_PersistentVariable_1);
            Assert.Equal(20, TagValue_PersistentVariable_2);
        }

        [Fact()]
        public async void CollectPersistentVariablesTest()
        {
            const string DefaultPersistentGroupName = "default";
            const string PersistentGroupName_1 = "1";
            const string PersistentGroupName_2 = "2";

            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var data = new OnlineMockData(parent, "a", "b");
            var repo = new InMemoryRepository<AXOpen.Data.PersistentRecord>();
            var sut = new AXOpen.Data.AxoDataPersistentExchange(parent, "perExchange", "PerExchange");

            await sut.InitializeRemoteDataExchange(data, repo);

            var groups = sut.CollectedGroups;

            Assert.Equal(3, groups.Count);
            Assert.Equal(DefaultPersistentGroupName, groups[0]);
            Assert.Equal(PersistentGroupName_1, groups[1]);
            Assert.Equal(PersistentGroupName_2, groups[2]);

            foreach (var group in groups)
            {
                await sut.UpdatePersistentGroupFromPlcToRepository(group);
            }

            var group_default = repo.Read(groups[0]);
            var group_1 = repo.Read(groups[1]);
            var group_2 = repo.Read(groups[2]);

            Assert.Equal(2, group_default.Tags.Count());
            Assert.Equal(1, group_1.Tags.Count());
            Assert.Equal(28, group_2.Tags.Count());
        }

        [Fact()]
        public async void InitializeRemoteDataExchange_ShouldInitializeRPC_Calls_WithGivenRepository()
        {
            const string PersistentGroupName = "default";

            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var data = new OnlineMockData(parent, "a", "b");
            var repo = new InMemoryRepository<AXOpen.Data.PersistentRecord>();
            var sut = new AXOpen.Data.AxoDataPersistentExchange(parent, "perExchange", "PerExchange");

            await sut.InitializeRemoteDataExchange(data, repo);

            await sut.Operation.DataEntityIdentifier.SetAsync(PersistentGroupName);
            sut.Operation.StartTimeStamp.Cyclic = DateAndTime.Now;

            Assert.True(await sut.Operation.IsInitialized.GetAsync());
        }

        [Fact()]
        public async void DeInitializeRemoteDataExchange_ShouldInitializeRPC_Calls()
        {
            const string PersistentGroupName = "default";

            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var data = new OnlineMockData(parent, "a", "b");
            var repo = new InMemoryRepository<AXOpen.Data.PersistentRecord>();
            var sut = new AXOpen.Data.AxoDataPersistentExchange(parent, "perExchange", "PerExchange");

            await sut.InitializeRemoteDataExchange(data, repo);

            await sut.Operation.DataEntityIdentifier.SetAsync(PersistentGroupName);
            sut.Operation.StartTimeStamp.Cyclic = DateAndTime.Now;

            Assert.True(await sut.Operation.IsInitialized.GetAsync());

            await sut.DeInitializeRemoteDataExchange();

            Assert.False(await sut.Operation.IsInitialized.GetAsync());
        }
    }
}