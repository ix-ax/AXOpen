using System.Reflection;
using System.Runtime.CompilerServices;
using IntegrationTests;
using axopen_integrations;
using AXOpen.Base.Data;
using AXSharp.Connector;
using AXOpen.Data.InMemory;
using AXOpen.Data.Json;
using AXOpen.Data.MongoDb;
using AXOpen.Data.RavenDb;
using integrations.data.single;
using Pocos.IntegrationLightDirect;
using Raven.Embedded;


namespace integrations.data.fragments
{

    using System;
    using System.Reflection.Metadata;
    using Xunit;

    public abstract class DataExchangeTestBase
    {
        protected IntegrationAxoDataFramentsExchange.AxoDataFragmentExchangeContext testContext = 
            Entry.Plc.Integrations.DataFragmentContext;

        protected IRepository<Pocos.IntegrationAxoDataFramentsExchange.SharedProductionData> SetRepository { get; set; }
        protected IRepository<Pocos.IntegrationAxoDataFramentsExchange.FragmentProcessData> ManipRepository { get; set; }

        protected IRepository<Pocos.IntegrationAxoDataFramentsExchange.SharedProductionData> Repository { get; } =
            new InMemoryRepository<Pocos.IntegrationAxoDataFramentsExchange.SharedProductionData>();

        public DataExchangeTestBase()
        {
            
        }

        [Fact]
        public async Task CreateTest()
        {
            //--Arrange
            var sut = testContext;
            var identifier = "hello-id";
            await sut.CreateTest.Identifier.SetAsync(identifier);

            //-- Act
            await sut.CreateTest.RunTest();

            //-- Assert
            Assert.NotNull(SetRepository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier));
            Assert.NotNull(ManipRepository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier));
        }

        [Fact]
        public async Task ReadTest()
        {
            //--Arrange
            var sut = testContext;
            var identifier1 = "hello-id-to-read-1";
            
            SetRepository.Create(identifier1, new Pocos.IntegrationAxoDataFramentsExchange.SharedProductionData());
            ManipRepository.Create(identifier1, new Pocos.IntegrationAxoDataFramentsExchange.FragmentProcessData());
            
            await sut.ReadTest.Identifier.SetAsync(identifier1);
            await sut.ReadTest.RunTest();

            //-- Assert

            //var record = Repository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier1);

            Assert.Equal("hello-id-to-read-1", testContext.PD.Set.Set.DataEntityId.GetAsync().Result);
            Assert.Equal("hello-id-to-read-1", testContext.PD.Manip.Set.DataEntityId.GetAsync().Result);
        }

        [Fact]
        public async Task UpdateTest()
        {
            //--Arrange
            var sut = testContext;
            var identifier = "hello-id-to-update";
            await sut.UpdateTest.Identifier.SetAsync(identifier);
            SetRepository.Create(identifier, new() { });
            ManipRepository.Create(identifier, new() { });

            //-- Act
            await testContext.PD.Set.Set.GoesTo.SetAsync(500);
            await testContext.PD.Manip.Set.CounterDelay.SetAsync(800ul);
            await sut.UpdateTest.RunTest();

            //-- Assert

            var setRecord = SetRepository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier);
            var manipRecord = ManipRepository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier);
            Assert.Equal(500, setRecord.GoesTo);
            Assert.Equal(800ul, manipRecord.CounterDelay);
        }

        [Fact]
        public async Task DeleteTest()
        {
            //--Arrange
            var sut = testContext;
            var identifier1 = "hello-id-to-delete-1";
            var identifier2 = "hello-id-to-delete-2";


            SetRepository.Create(identifier1, new ());
            ManipRepository.Create(identifier1, new());
            
            await sut.DeleteTest.Identifier.SetAsync(identifier1);
            await sut.DeleteTest.RunTest();

            //-- Assert

            var setRecord = SetRepository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier1);
            Assert.Null(setRecord);

            var manipRecord = ManipRepository.Queryable.FirstOrDefault(p => p.DataEntityId == identifier1);
            Assert.Null(manipRecord);
        }
    }
#if DEBUG

    public class DataExchangeTestInMemory : DataExchangeTestBase
    {
        public DataExchangeTestInMemory() : base()
        {
            Remoting.KickOff();
            

            this.SetRepository = new InMemoryRepository<Pocos.IntegrationAxoDataFramentsExchange.SharedProductionData>();
            this.ManipRepository = new InMemoryRepository<Pocos.IntegrationAxoDataFramentsExchange.FragmentProcessData>();

            testContext.PD.CreateBuilder<IntegrationAxoDataFramentsExchange.ProcessData>();

            testContext.PD.Set.SetRepository(this.SetRepository);
            testContext.PD.Manip.SetRepository(this.ManipRepository);

            testContext.PD.DeInitializeRemoteDataExchange();
            testContext.PD.InitializeRemoteDataExchange();
        }
    }

    public class DataExchangeTestRaven : DataExchangeTestBase
    {
        public DataExchangeTestRaven() : base()
        {
            Remoting.KickOff();
            this.SetRepository = new RavenDbRepository<Pocos.IntegrationAxoDataFramentsExchange.SharedProductionData>(new RavenDbRepositorySettings<Pocos.IntegrationAxoDataFramentsExchange.SharedProductionData>(new string[] { "http://localhost:8080" }, "TestDataBaseSet", "", "credentials"));
            this.ManipRepository = new RavenDbRepository<Pocos.IntegrationAxoDataFramentsExchange.FragmentProcessData>(new RavenDbRepositorySettings<Pocos.IntegrationAxoDataFramentsExchange.FragmentProcessData>(new string[] { "http://localhost:8080" }, "TestDataBaseManip", "", "credentials"));

            var setRecords = this.SetRepository.GetRecords().ToList();

            for (int i = 0; i < setRecords.Count; i++)
            {
                this.SetRepository.Delete(setRecords[i].DataEntityId);
            }

            var manipRecords = this.ManipRepository.GetRecords().ToList();

            for (int i = 0; i < manipRecords.Count; i++)
            {
                this.ManipRepository.Delete(manipRecords[i].DataEntityId);
            }

            testContext.PD.CreateBuilder<IntegrationAxoDataFramentsExchange.ProcessData>();

            testContext.PD.Set.SetRepository(this.SetRepository);
            testContext.PD.Manip.SetRepository(this.ManipRepository);

            testContext.PD.DeInitializeRemoteDataExchange();
            testContext.PD.InitializeRemoteDataExchange();
        }
    }
#endif

    public class DataExchangeTestJson : DataExchangeTestBase
    {
        public DataExchangeTestJson() : base()
        {
            Remoting.KickOff();
            var assemblyFile = new FileInfo(Assembly.GetExecutingAssembly().Location);
            var outputFolder = Path.Combine(assemblyFile.Directory.FullName, "storage");

            if (Directory.Exists(outputFolder))
            {
                Directory.Delete(outputFolder, true);
            }

            testContext.PD.CreateBuilder<IntegrationAxoDataFramentsExchange.ProcessData>();

            this.SetRepository = new JsonRepository<Pocos.IntegrationAxoDataFramentsExchange.SharedProductionData>(new(Path.Combine(assemblyFile.Directory.FullName, "storage", "set")));
            this.ManipRepository = new JsonRepository<Pocos.IntegrationAxoDataFramentsExchange.FragmentProcessData>(new(Path.Combine(assemblyFile.Directory.FullName, "storage", "manip")));

            testContext.PD.Set.SetRepository(this.SetRepository);
            testContext.PD.Manip.SetRepository(this.ManipRepository);

            testContext.PD.DeInitializeRemoteDataExchange();
            testContext.PD.InitializeRemoteDataExchange();
        }
    }
}