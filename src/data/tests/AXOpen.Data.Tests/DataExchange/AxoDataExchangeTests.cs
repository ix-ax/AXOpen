﻿using Xunit;
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
using Microsoft.VisualBasic;
using Pocos.axosimple;

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

        [Fact]
        public void RemoteCreate_ShouldCreateRecordInRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            
            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);


            sut.Set.ComesFrom.SetAsync(10);
            sut.Set.GoesTo.SetAsync(20);
            sut.RemoteCreate("hey remote create");

            var record = repo.Read("hey remote create");
            Assert.Equal(10, record.ComesFrom);
            Assert.Equal(20, record.GoesTo);
        }

        [Fact]
        public async void RemoteRead_ShouldReadRecordFromRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);


      
            repo.Create("hey remote create", new Pocos.axosimple.SharedProductionData() { ComesFrom = 48, GoesTo = 68});

            sut.RemoteRead("hey remote create");
            Assert.Equal(48, await sut.Set.ComesFrom.GetAsync());
            Assert.Equal(68, await sut.Set.GoesTo.GetAsync());
        }

        [Fact]
        public async void FromRepositoryToShadows_ShouldSetDataInShadowsFromPlainPocoObject()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            sut.SetRepository(repo);


            repo.Create("hey remote create", new Pocos.axosimple.SharedProductionData() { ComesFrom = 85, GoesTo = 98 });

            sut.FromRepositoryToShadowsAsync(new SharedProductionData() { DataEntityId = "hey remote create"});


            Assert.Equal("hey remote create", sut.Set.DataEntityId.Shadow);
            Assert.Equal(85, sut.Set.ComesFrom.Shadow);
            Assert.Equal(98, sut.Set.GoesTo.Shadow);
        }

        [Fact]
        public async void FromRepositoryToController_ShouldSetDataFromShadowsToController()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            sut.SetRepository(repo);

            repo.Create("hey remote create", new Pocos.axosimple.SharedProductionData() { ComesFrom = 85, GoesTo = 98 });

            await sut.FromRepositoryToControllerAsync(new Pocos.axosimple.SharedProductionData() { DataEntityId = "hey remote create" });

            Assert.Equal("hey remote create", await sut.Set.DataEntityId.GetAsync());
            Assert.Equal(85, await sut.Set.ComesFrom.GetAsync());
            Assert.Equal(98, await sut.Set.GoesTo.GetAsync());
        }


        [Fact]
        public async void RemoteUpdate_ShouldUpdateRecordInRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);

            repo.Create("hey remote create", new Pocos.axosimple.SharedProductionData() { ComesFrom = 48, GoesTo = 68 });


            sut.Set.ComesFrom.SetAsync(40);
            sut.Set.GoesTo.SetAsync(60);
            sut.RemoteUpdate("hey remote create");

            var record = repo.Read("hey remote create");
            Assert.Equal(40, record.ComesFrom);
            Assert.Equal(60, record.GoesTo);
        }

        [Fact]
        public async void RemoteDelete_ShouldDeleteRecordFromRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);


            sut.Set.ComesFrom.SetAsync(10);
            sut.Set.GoesTo.SetAsync(20);
            sut.RemoteCreate("hey remote create");

            Assert.Equal(1, repo.Count);

            sut.RemoteDelete("hey remote create");

            Assert.Equal(0, repo.Count);
        }

        [Fact]
        public async void GetRecords_Filtered_ShouldReturnRecordsFromRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);

            for (int i = 0; i < 10; i++)
            {
                repo.Create($"{i}Record", new SharedProductionData() { ComesFrom = (short)(i+1), GoesTo = (short)(i * 7) });
            }

            var actual = sut.GetRecords("Rec", 3, 0, eSearchMode.Contains);

            Assert.Equal(3, actual.Count());
        }

        [Fact]
        public async void GetRecords_ShouldReturnRecordsFromRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);

            for (int i = 0; i < 10; i++)
            {
                repo.Create($"{i}Record", new SharedProductionData() { ComesFrom = (short)(i + 1), GoesTo = (short)(i * 7) });
            }

            var actual = sut.GetRecords("*");

            Assert.Equal(10, actual.Count());
        }

        [Fact]
        public async void Delete_ShouldDeleteRecordFromRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);

            for (int i = 0; i < 10; i++)
            {
                repo.Create($"{i}Record", new SharedProductionData() { ComesFrom = (short)(i + 1), GoesTo = (short)(i * 7) });
            }

            await sut.Delete("1Record");

            Assert.Equal(9, sut.Repository.Count);
        }

        [Fact]
        public async void UpdateFromShadows_ShouldUpdateRecordPresentInShadowsInTheReporitory()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);

            repo.Create("hey remote create", new Pocos.axosimple.SharedProductionData() { ComesFrom = 48, GoesTo = 68 });


            sut.Set.DataEntityId.Shadow = "hey remote create";
            sut.Set.ComesFrom.Shadow = 140;
            sut.Set.GoesTo.Shadow = 885;
            await sut.UpdateFromShadowsAsync();

            var record = repo.Read("hey remote create");
            Assert.Equal("hey remote create", record.DataEntityId);
            Assert.Equal(140, record.ComesFrom);
            Assert.Equal(885, record.GoesTo);
        }

        [Fact]
        public async void CreateNew_ShouldCreateNewRecordInRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);

            await sut.CreateNewAsync("hey remote create - brandnew");

            var record = repo.Read("hey remote create - brandnew");
            Assert.Equal("hey remote create - brandnew", record.DataEntityId);
        }

        [Fact]
        public async void CreateCopy_ShouldCreateNewRecordFromShadowsInRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);


            sut.Set.ComesFrom.Shadow = 101;
            sut.Set.GoesTo.Shadow = 201;
           

            sut.CreateCopyCurrentShadowsAsync("hey remote create - new");

            var record = repo.Read("hey remote create - new");
            Assert.Equal("hey remote create - new", record.DataEntityId);
            Assert.Equal(101, record.ComesFrom);
            Assert.Equal(201, record.GoesTo);
        }

        [Fact]
        public async void LoadFromPlc_ShouldCreateNewRecordFromOnlineInRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));

            var sut = new axosimple.SharedProductionDataManager(parent, "a", "b");
            var repo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            sut.SetRepository(repo);


            await sut.Set.ComesFrom.SetAsync(1011);
            await sut.Set.GoesTo.SetAsync(1201);


            await sut.CreateDataFromControllerAsync("hey remote create");

            var record = repo.Read("hey remote create");
            Assert.Equal("hey remote create", record.DataEntityId);
            Assert.Equal(1011, record.ComesFrom);
            Assert.Equal(1201, record.GoesTo);
        }

        [Fact()]
        public async void InitializeRemoteDataExchange_ShouldInitializeRPC_Calls_WithGivenRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new AxoDataExchange<OnlineMockData, MockData>(parent, "a", "b");
            var repo = new InMemoryRepository<MockData>();
            sut.InitializeRemoteDataExchange(repo);

            await sut.CreateTask.DataEntityIdentifier.SetAsync("foo");
            sut.CreateTask.StartTimeStamp.Cyclic = DateAndTime.Now;



            Assert.True(await sut.CreateTask.IsInitialized.GetAsync());
            Assert.True(await sut.ReadTask.IsInitialized.GetAsync());
            Assert.True(await sut.UpdateTask.IsInitialized.GetAsync());
            Assert.True(await sut.DeleteTask.IsInitialized.GetAsync());
        }

        [Fact()]
        public async void InitializeRemoteDataExchange_ShouldInitializeRPC_Calls()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new AxoDataExchange<OnlineMockData, MockData>(parent, "a", "b");
            var repo = new InMemoryRepository<MockData>();
            sut.SetRepository(repo);
            sut.InitializeRemoteDataExchange();

            await sut.CreateTask.DataEntityIdentifier.SetAsync("foo");
            sut.CreateTask.StartTimeStamp.Cyclic = DateAndTime.Now;



            Assert.True(await sut.CreateTask.IsInitialized.GetAsync());
            Assert.True(await sut.ReadTask.IsInitialized.GetAsync());
            Assert.True(await sut.UpdateTask.IsInitialized.GetAsync());
            Assert.True(await sut.DeleteTask.IsInitialized.GetAsync());
        }

        [Fact()]
        public async void DeInitializeRemoteDataExchange_ShouldInitializeRPC_Calls()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new AxoDataExchange<OnlineMockData, MockData>(parent, "a", "b");
            var repo = new InMemoryRepository<MockData>();
            sut.InitializeRemoteDataExchange(repo);

            await sut.CreateTask.DataEntityIdentifier.SetAsync("foo");
            sut.CreateTask.StartTimeStamp.Cyclic = DateAndTime.Now;



            Assert.True(await sut.CreateTask.IsInitialized.GetAsync());
            Assert.True(await sut.ReadTask.IsInitialized.GetAsync());
            Assert.True(await sut.UpdateTask.IsInitialized.GetAsync());
            Assert.True(await sut.DeleteTask.IsInitialized.GetAsync());

            sut.DeInitializeRemoteDataExchange();

            Assert.False(await sut.CreateTask.IsInitialized.GetAsync());
            Assert.False(await sut.ReadTask.IsInitialized.GetAsync());
            Assert.False(await sut.UpdateTask.IsInitialized.GetAsync());
            Assert.False(await sut.DeleteTask.IsInitialized.GetAsync());
        }
    }

}