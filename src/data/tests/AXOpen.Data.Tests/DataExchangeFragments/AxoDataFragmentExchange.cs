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
using Pocos.axosimple;
using Pocos.examples.PneumaticManipulator;
using ProcessData = axosimple.ProcessData;


namespace AXOpen.Data.Fragments.Tests
{
    using TOnline = AXOpen.Data.AxoDataEntity;
    using TPlain = Pocos.AXOpen.Data.AxoDataEntity;
    using Pocos.AXOpen.Data;

    public class AxoDataFragmentExchange
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
        public async void RemoteCreate_ShouldCreateRecordsInEachRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            await sut.Set.Set.ComesFrom.SetAsync(10);
            await sut.Set.Set.GoesTo.SetAsync(20);
            await sut.Manip.Set.CounterDelay.SetAsync(20);
            sut.RemoteCreate("hey remote create");

            var shared = sut.Set.DataRepository.Read("hey remote create");
            Assert.Equal(10, shared.ComesFrom);
            Assert.Equal(20, shared.GoesTo);

            var manip = sut.Manip.DataRepository.Read("hey remote create");
            Assert.Equal(20ul, manip.CounterDelay);
        }

        [Fact]
        public async void RemoteRead_ShouldReadRecordsFromEachRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            var sharedRepo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            var manipRepo = new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>();
            s.Set.SetRepository(sharedRepo);
            s.Manip.SetRepository(manipRepo);

            var id = "hey";

            sharedRepo.Create(id, new SharedProductionData() { ComesFrom = 55, GoesTo = 44});
            manipRepo.Create(id, new FragmentProcessData() { CounterDelay = 8989ul});

            sut.RemoteRead(id);

            Assert.Equal(55, await sut.Set.Set.ComesFrom.GetAsync());
            Assert.Equal(44, await sut.Set.Set.GoesTo.GetAsync());
            Assert.Equal(8989ul, await sut.Manip.Set.CounterDelay.GetAsync());

        }

        [Fact]
        public async void RemoteUpdate_ShouldUpdateRecordsInEachRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            await sut.Set.Set.ComesFrom.SetAsync(10);
            await sut.Set.Set.GoesTo.SetAsync(20);
            await sut.Manip.Set.CounterDelay.SetAsync(20);
            sut.RemoteCreate("hey remote create");

            await sut.Set.Set.ComesFrom.SetAsync(88);
            await sut.Set.Set.GoesTo.SetAsync(64);
            await sut.Manip.Set.CounterDelay.SetAsync(789);
            sut.RemoteUpdate("hey remote create");


            var shared = sut.Set.DataRepository.Read("hey remote create");
            Assert.Equal(88, shared.ComesFrom);
            Assert.Equal(64, shared.GoesTo);

            var manip = sut.Manip.DataRepository.Read("hey remote create");
            Assert.Equal(789ul, manip.CounterDelay);
        }


        [Fact]
        public async void RemoteDelete_ShouldDeleteRecordsFromEachRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            await sut.Set.Set.ComesFrom.SetAsync(10);
            await sut.Set.Set.GoesTo.SetAsync(20);
            await sut.Manip.Set.CounterDelay.SetAsync(20);
            sut.RemoteCreate("hey remote create");


            Assert.Equal(1, sut.Set.DataRepository.Count);
            Assert.Equal(1, sut.Manip.DataRepository.Count);

            sut.RemoteDelete("hey remote create");


            Assert.Equal(0, sut.Set.DataRepository.Count);
            Assert.Equal(0, sut.Manip.DataRepository.Count);
        }

        [Fact]
        public async void FromRepositoryToShadows_ShouldSetDataInShadowsFromPlainPocoObject()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            var sharedRepo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            var manipRepo = new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>();
            s.Set.SetRepository(sharedRepo);
            s.Manip.SetRepository(manipRepo);

            sharedRepo.Create("hey remote create", new Pocos.axosimple.SharedProductionData() 
                { ComesFrom = 185, GoesTo = 398 });
            manipRepo.Create("hey remote create", new () { CounterDelay = 898577ul});

            sut.FromRepositoryToShadowsAsync(new SharedProductionData() { DataEntityId = "hey remote create" });


            Assert.Equal("hey remote create", sut.Set.Set.DataEntityId.Shadow);
            Assert.Equal(185, sut.Set.Set.ComesFrom.Shadow);
            Assert.Equal(398, sut.Set.Set.GoesTo.Shadow);
            Assert.Equal("hey remote create", sut.Manip.Set.DataEntityId.Shadow);
            Assert.Equal(898577ul, sut.Manip.Set.CounterDelay.Shadow);
        }

        [Fact]
        public async void FromRepositoryToController_ShouldSetDataFromShadowsToController()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            var sharedRepo = new InMemoryRepository<Pocos.axosimple.SharedProductionData>();
            var manipRepo = new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>();
            s.Set.SetRepository(sharedRepo);
            s.Manip.SetRepository(manipRepo);

            sharedRepo.Create("hey remote create", new Pocos.axosimple.SharedProductionData()
                { ComesFrom = 485, GoesTo = 898 });
            manipRepo.Create("hey remote create", new() { CounterDelay = 5898577ul });

            await sut.FromRepositoryToControllerAsync(new SharedProductionData() { DataEntityId = "hey remote create" });


            Assert.Equal("hey remote create", await sut.Set.Set.DataEntityId.GetAsync());
            Assert.Equal(485, await sut.Set.Set.ComesFrom.GetAsync());
            Assert.Equal(898, await sut.Set.Set.GoesTo.GetAsync());
            Assert.Equal("hey remote create", await sut.Manip.Set.DataEntityId.GetAsync());
            Assert.Equal(5898577ul, await sut.Manip.Set.CounterDelay.GetAsync());
        }

        [Fact]
        public async void GetRecords_Filtered_ShouldReturnRecordsFromRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            for (int i = 0; i < 10; i++)
            {
               await sut.CreateNewAsync($"{i}Record");
            }

            var actual = sut.GetRecords("Rec", 3, 0, eSearchMode.Contains);

            Assert.Equal(3, actual.Count());
        }

        [Fact]
        public async void GetRecords_ShouldReturnRecordsFromRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            for (int i = 0; i < 10; i++)
            {
                await sut.CreateNewAsync($"{i}Record");
            }

            var actual = sut.GetRecords("*");

            Assert.Equal(10, actual.Count());
        }

        [Fact]
        public async void Delete_ShouldDeleteRecordsFromEachRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            await sut.Set.Set.ComesFrom.SetAsync(10);
            await sut.Set.Set.GoesTo.SetAsync(20);
            await sut.Manip.Set.CounterDelay.SetAsync(20);
            sut.RemoteCreate("hey remote create");


            Assert.Equal(1, sut.Set.DataRepository.Count);
            Assert.Equal(1, sut.Manip.DataRepository.Count);

            await sut.Delete("hey remote create");


            Assert.Equal(0, sut.Set.DataRepository.Count);
            Assert.Equal(0, sut.Manip.DataRepository.Count);
        }

        [Fact]
        public async void UpdateFromShadows_ShouldUpdateRecordsInEachRepository()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            await sut.Set.Set.ComesFrom.SetAsync(10);
            await sut.Set.Set.GoesTo.SetAsync(20);
            await sut.Manip.Set.CounterDelay.SetAsync(20);
            sut.RemoteCreate("hey remote create");

            sut.Set.Set.DataEntityId.Shadow = "hey remote create";
            sut.Set.Set.ComesFrom.Shadow = 188;
            sut.Set.Set.GoesTo.Shadow = 568;
            sut.Manip.Set.DataEntityId.Shadow = "hey remote create";
            sut.Manip.Set.CounterDelay.Shadow = 8566ul;

            await sut.UpdateFromShadowsAsync();


            var shared = sut.Set.DataRepository.Read("hey remote create");
            Assert.Equal(188, shared.ComesFrom);
            Assert.Equal(568, shared.GoesTo);

            var manip = sut.Manip.DataRepository.Read("hey remote create");
            Assert.Equal(8566ul, manip.CounterDelay);
        }

        [Fact]
        public async void LoadFromController_ShouldLoadExistingDataSetToEachShadow()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            await sut.Set.Set.ComesFrom.SetAsync(111);
            await sut.Set.Set.GoesTo.SetAsync(222);
            await sut.Manip.Set.CounterDelay.SetAsync(4859);

            await sut.CreateDataFromControllerAsync("hey remote create");

            var shared = sut.Set.DataRepository.Read("hey remote create");

            Assert.Equal("hey remote create", shared.DataEntityId);
            Assert.Equal(111, shared.ComesFrom);
            Assert.Equal(222, shared.GoesTo);

            var manip = sut.Manip.DataRepository.Read("hey remote create");
            Assert.Equal("hey remote create", manip.DataEntityId);
            Assert.Equal(4859ul, manip.CounterDelay);
        }

        [Fact]
        public async void CreateCopy_ShouldCreateInAllRepositoriesFromExisting()
        {
            var parent = NSubstitute.Substitute.For<ITwinObject>();
            parent.GetConnector().Returns(AXSharp.Connector.ConnectorAdapterBuilder.Build().CreateDummy().GetConnector(null));
            var sut = new ProcessData(parent, "a", "b");
            var s = sut.Builder<ProcessData>();
            s.Set.SetRepository(new InMemoryRepository<Pocos.axosimple.SharedProductionData>());
            s.Manip.SetRepository(new InMemoryRepository<Pocos.examples.PneumaticManipulator.FragmentProcessData>());

            await sut.Set.Set.ComesFrom.SetAsync(111);
            await sut.Set.Set.GoesTo.SetAsync(222);
            await sut.Manip.Set.CounterDelay.SetAsync(4859);

            await sut.CreateDataFromControllerAsync("hey remote create");

           

            await sut.CreateCopyCurrentShadowsAsync("hey remote create - copy");


            var shared = sut.Set.DataRepository.Read("hey remote create - copy");
            Assert.Equal("hey remote create - copy", shared.DataEntityId);
            Assert.Equal(111, shared.ComesFrom);
            Assert.Equal(222, shared.GoesTo);

            var manip = sut.Manip.DataRepository.Read("hey remote create - copy");
            Assert.Equal("hey remote create - copy", manip.DataEntityId);
            Assert.Equal(4859ul, manip.CounterDelay);
        }
    }

}